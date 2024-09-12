import UIKit
import RxSwift
import RxCocoa
import Kingfisher

// !!!: 本 Demo 用于演示 RxSwift “转换操作符”
class ActivityController: UITableViewController {
    private let repo = "ReactiveX/RxSwift"
    private let eventsFileURL = cachedFileURL("events.json")
    private let modifiedFileURL = cachedFileURL("modified.txt")

    private let events = BehaviorRelay<[Event]>(value: [])
    private let lastModified = BehaviorRelay<String?>(value: nil)
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = repo

        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!

        refreshControl.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        // 尝试从本地磁盘中读取缓存的数据
        let decoder = JSONDecoder()
        if let eventsData = try? Data(contentsOf: eventsFileURL),
            let persistedEvents = try? decoder.decode([Event].self, from: eventsData) {
            events.accept(persistedEvents)
        }

        // 优化网络请求，只请求它之前没有获取到的事件。如果没有人 fork 或者喜欢你跟踪的 repo，你就会从服务器收到一个空的响应，从而节省网络流量和处理能力。
        // 注：该功能需要服务器端提供支持，在响应头中添加一个 Last-Modified 字段，以在下一次请求时发出。
        if let lastModifiedString = try? String(contentsOf: modifiedFileURL, encoding: .utf8) {
            lastModified.accept(lastModifiedString)
        }

        refresh()
    } 

    @objc func refresh() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            self.fetchEvents(repo: self.repo)
        }
    }

    func fetchEvents(repo: String) {
        // String -> URL -> URLRequest -> Observable<(response: HTTPURLResponse, data: Data)>
        // Challenge: 寻找最热门的 Swift 仓库，并在应用中显示它们的综合活动，而不是总是获取某一特定仓库的最新活动。
        // 每次启动应用或下拉刷新时，应用都会得到前五个 Swift 仓库的列表，然后向 GitHub 发出五个不同的请求，获取每个仓库的事件。
        // 这个 API 端点将返回前五名热门 Swift 仓库的列表
        let response = Observable.from(["https://api.github.com/search/repositories?q=language:swift&per_page=5"])
            .map { urlString -> URL in
                return URL(string: urlString)!
            }
            .flatMap { url -> Observable<Any> in // 添加异步特性
                let request = URLRequest(url: url)
                return URLSession.shared.rx.json(request: request)
            }
            .flatMap { response -> Observable<String> in
                guard let response = response as? [String: Any], let items = response["items"] as? [[String: Any]] else {
                    return Observable.empty()
                }
                return Observable.from(items.map{ $0["full_name"] as! String })
            }
            .map { urlString -> URL in // 通过主动说明闭包输入和输出类型，帮助编译器解决类型丢失/不匹配问题
                return URL(string: "https://api.github.com/repos/\(urlString)/events")!
            }
            .map { [weak self] url -> URLRequest in
                var request = URLRequest(url: url)

                // 将上一次请求缓存的响应头添加到本次请求头中
                if let modifiedHeader = self?.lastModified.value {
                    request.addValue(modifiedHeader, forHTTPHeaderField: "Last-Modified")
                }
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            // 如果你的请求已经完成，并且一个新的观察者订阅了共享序列（通过 share(replay:scope:)），它将立即收到来自先前执行的网络请求的缓冲响应
            .share(replay: 1)

        // Observable<(response: HTTPURLResponse, data: Data)> -> [Event]
        response
            // 通过 filter 过滤网络请求响应失败的情况，只让状态码在 200 和 300 之间的响应通过
            .filter { response, _ in
                // ~= 操作符检查左边的范围是否包括右边的值
                return 200..<300 ~= response.statusCode
            }
            .compactMap { (response: HTTPURLResponse, data: Data) -> [Event]? in
                return try? JSONDecoder().decode([Event].self, from: data)
            }
            .subscribe(onNext: { [weak self] newEvents in
                self?.processEvents(newEvents)
            })
            .disposed(by: bag)

        // 缓存 Last-Modified 的 HTTP 响应头
        response
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            // 过滤所有不包括 Last-Modified 头的响应
            .flatMap({ (response: HTTPURLResponse, data: Data) -> Observable<String> in
                // 检查响应是否包含一个名为 Last-Modified 的 HTTP 响应头，并将其转换为一个字符串
                guard let value = response.allHeaderFields["Last-Modified"] as? String else {
                    return Observable.empty()
                }
                return Observable.just(value)
            }).subscribe(onNext: { [weak self] modifiedHeader in
                guard let self else { return }

                self.lastModified.accept(modifiedHeader)

                // 缓存 Last-Modified 数据到本地磁盘缓存文件（modified.txt）
                try? modifiedHeader.write(to: self.modifiedFileURL, atomically: true, encoding: .utf8)
            })
            .disposed(by: bag)
    }

    func processEvents(_ newEvents: [Event]) {
        // 截取最近的 50 个 Event
        var updatedEvents = newEvents + events.value
        if updatedEvents.count > 50 {
            updatedEvents = [Event](updatedEvents.prefix(upTo: 50))
        }

        events.accept(updatedEvents)

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }

        // 尝试将 updatedEvents 编码为一个 Data 对象，然后保存到本地磁盘缓存文件（events.json）
        let encoder = JSONEncoder()
        if let eventData = try? encoder.encode(updatedEvents) {
            try? eventData.write(to: eventsFileURL, options: .atomic)
        }
    }

    // MARK: - Table Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events.value[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = event.actor.name
        cell.detailTextLabel?.text = event.repo.name + ", " + event.action.replacingOccurrences(of: "Event", with: "").lowercased()
        cell.imageView?.kf.setImage(with: event.actor.avatar, placeholder: UIImage(named: "blank-avatar"))
        return cell
    }
}

func cachedFileURL(_ fileName: String) -> URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first!.appendingPathComponent(fileName)
}
