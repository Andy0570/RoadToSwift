import UIKit
import RxSwift
import RxCocoa

// !!!: 本 Demo 演示 RxSwift 中的 “组合操作符”
class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    // CHALLEGBE 1，在导航栏上添加活动指示器
    var activityIndicator: UIActivityIndicatorView!

    // CHALLEGBE 2，在事件下载过程中添加一个显示下载进度的 progress 进度条
    var downloadView = DownloadView()

    let categories = BehaviorRelay<[EOCategory]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // CHALLEGBE 1
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating() // 开始下载时转动菊花

        // CHALLEGBE 2
        view.addSubview(downloadView)
        view.layoutIfNeeded()

        // 订阅 BehaviorRelay 以更新列表视图
        categories.asObservable().subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        startDownload()
    }
    
    func startDownload() {
        // CHALLEGBE 2
        downloadView.progress.progress = 0.0
        downloadView.label.text = "Download: 0%"

        // 下载所有类别
        let eoCategories = EONET.categories

        /*
         // 1.1 一次性下载过去一年中的所有事件
         let downloadedEvents = EONET.events(forLast: 360)

         // 使用 combineLatest() 将下载的 categories 和 下载的 events 结合起来
         // combineLatest() 可以确保 eoCategories 网络请求和 downloadedEvents 网络请求两者都返回数据之后，闭包才执行（类似于 GCD 任务调度组）
         let updatedCategories = Observable.combineLatest(eoCategories, downloadedEvents) { (categories, events) -> [EOCategory] in
         return categories.map { category in
         var cat = category
         // 把下载的事件分类到不同的类别中
         cat.events = events.filter {
         $0.categories.contains(where: { $0.id == category.id })
         }
         return cat
         }
         }
         */

        // 1.2 优化：按类别下载事件
        let downloadedEvents = eoCategories
            .flatMap { categories in
                return Observable.from(categories.map({ category in
                    EONET.events(forLast: 360, category: category)
                }))
            }
            .merge(maxConcurrent: 2) // 限制网络请求并发数量

//        let updatedCategories = eoCategories.flatMap { categories in
//            // 每次包含事件的源可观察序列（downloadedEvents）发出一个元素时，scan(_:accumulator:) 都会调用你的闭包
//            // 每当一组新的事件到来时，scan就会发出一个类别更新
//            downloadedEvents.scan(categories) { updated, events in
//                return updated.map { category in
//                    let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
//                    if !eventsForCategory.isEmpty {
//                        var cat = category
//                        cat.events = cat.events + eventsForCategory
//                        return cat // 返回更新后的类别
//                    }
//                    return category // 否则返回原类别
//                }
//            }
//        }
        let updatedCategories: Observable<(Int, [EOCategory])> = eoCategories.flatMap { categories -> Observable<(Int, [EOCategory])> in
            // CHALLEGBE 2
            downloadedEvents.scan((0, categories)) { tuple, events in
                // 返回元组类型 （Int, [EOCategory]）
                return (tuple.0 + 1, tuple.1.map { category in
                    let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
                    if !eventsForCategory.isEmpty {
                        var updatedCategory = category
                        updatedCategory.events = updatedCategory.events + eventsForCategory
                        return updatedCategory
                    }
                    return category
                })
            }
        }.do(onCompleted: { [weak self] in // CHALLEGBE 1
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating() // 下载完成后隐藏菊花
                self?.downloadView.isHidden = true // CHALLEGBE 2
            }
        }).do(onNext: { [weak self] tuple in // CHALLENGE 2，下载过程中实时更新下载进度条
            DispatchQueue.main.async {
                let progress = Float(tuple.0) / Float(tuple.1.count)
                self?.downloadView.progress.progress = progress
                let percent = Int(progress * 100.0)
                self?.downloadView.label.text = "Download: \(percent)%"
            }
        })

        // bind(to:) 将一个源可观察序列（Observable<[EOCategory]>）连接到另一个可观察序列（BehaviorRelay<[EOCategory]>）
        eoCategories.concat(updatedCategories.map(\.1)).bind(to: categories).disposed(by: disposeBag)
    }
    
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        let category = categories.value[indexPath.row]
        cell.textLabel?.text = "\(category.name) \(category.events.count)"
        cell.accessoryType = (category.events.count > 0) ? .disclosureIndicator : .none
        cell.detailTextLabel?.text = category.description
        return cell
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories.value[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        guard !category.events.isEmpty else {
            return
        }

        let eventsController = storyboard!.instantiateViewController(withIdentifier: "events") as! EventsViewController
        eventsController.title = category.name
        eventsController.events.accept(category.events) // 传递事件
        navigationController?.pushViewController(eventsController, animated: true)
    }
}
