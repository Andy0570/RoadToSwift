import Foundation
import RxSwift
import RxCocoa

class EONET {
    // <https://eonet.gsfc.nasa.gov/docs/v2.1#categoriesAPI>
    static let API = "https://eonet.gsfc.nasa.gov/api/v2.1"
    static let categoriesEndpoint = "/categories"
    static let eventsEndpoint = "/events"
    
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    // 一次性获取所有 EOEvent 后，对它们按照 EOCategory.id 进行分类， 按照日期进行排序
    static func filteredEvents(events: [EOEvent], forCategory category: EOCategory) -> [EOEvent] {
        return events.filter { event in
            return event.categories.contains(where: { $0.id == category.id }) && !category.events.contains {
                $0.id == event.id
            }
        }
        .sorted(by: EOEvent.compareDates)
    }

    // 泛型网络请求方法
    static func request<T: Decodable>(endpoint: String, query: [String: Any] = [:], contentIdentifier: String) -> Observable<T> {
        do {
            // 构建网络请求 URL
            guard let url = URL(string: API)?.appendingPathComponent(endpoint),
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw EOError.invalidURL(endpoint)
            }
            // 添加查询参数
            components.queryItems = try query.compactMap({ key, value in
                guard let value = value as? CustomStringConvertible else {
                    throw EOError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: value.description)
            })
            // 获取最终 URL
            guard let finalURL = components.url else {
                throw EOError.invalidURL(endpoint)
            }
            // 发起网络请求，URLSession 的 rx.response 从请求结果中创建可观察序列
            let request = URLRequest(url: finalURL)
            return URLSession.shared.rx.response(request: request).map { (response: HTTPURLResponse, data: Data) -> T in
                // 将数据解码为模型
                let decoder = self.jsonDecoder(contentIdentifier: contentIdentifier)
                let envelope = try decoder.decode(EOEnvelope<T>.self, from: data)
                return envelope.content
            }
        } catch {
            // 这里暂时简单处理，忽略错误
            return Observable.empty()
        }
    }

    // 由于类别很少变化，因此这里设计成一个单例
    static var categories: Observable<[EOCategory]> = {
        // 从 categories API 端点请求获取数据
        let request: Observable<[EOCategory]> = EONET.request(endpoint: categoriesEndpoint, contentIdentifier: "categories")

        return request
            .map { categories in
                categories.sorted { $0.name < $1.name }
            } // 将包含 EOCategory 的数组映射到一个按类别名称排序的数组中
            .catchAndReturn([]) // 如果在这个阶段发生网络错误，则输出一个空数组
            .share(replay: 1, scope: .forever) // 单例类型的可观察对象，确保所有的订阅者获得的是同一个！
    }()

    static func events(forLast days: Int = 360, category: EOCategory) -> Observable<[EOEvent]> {
        let openEvents = events(forLast: days, closed: false, endpoint: category.endpoint)
        let closedEvents = events(forLast: days, closed: true, endpoint: category.endpoint)

        // 依次下载开放事件和关闭事件，然后将两组结果串联起来
        // concat() 会按时间先后次序发起两个网络请求（顺序下载），第一个请求返回后才会发起第二个请求。
        // return openEvents.concat(closedEvents)

        // 优化：并行下载任务
        return Observable.of(openEvents, closedEvents) // 创建一个包含可观察序列的可观察序列
            .merge() // merge() 接收一个包含可观察变量的可观察序列。它订阅了由源可观察序列发射的每个可观察序列，并转发所有发射的元素。
            .reduce([]) { running, new in // 把结果还原成一个数组。[] 表示初始值，从一个空数组开始。
                running + new
            }
    }

    // 按类别下载事件
    private static func events(forLast days: Int, closed: Bool, endpoint: String) -> Observable<[EOEvent]> {
        let query: [String: Any] = [
            "days": days,
            "status": (closed ? "closed" : "open")
        ]
        let request: Observable<[EOEvent]> = EONET.request(endpoint: endpoint, query: query, contentIdentifier: "events")
        // 在这个小程序中，我们只是简单地捕捉错误并返回空数据。更先进的策略是重试请求，然后在用户界面处理错误以提醒用户。
        return request.catchAndReturn([])
    }
}
