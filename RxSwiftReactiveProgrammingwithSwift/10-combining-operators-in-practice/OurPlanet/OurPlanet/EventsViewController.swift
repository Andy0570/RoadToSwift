import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var daysLabel: UILabel!

    let events = BehaviorRelay<[EOEvent]>(value: [])
    let days = BehaviorRelay<Int>(value: 360)
    let filteredEvents = BehaviorRelay<[EOEvent]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        // 绑定 tableView 到 filteredEvents 以更新 UI
        filteredEvents.asObservable().subscribe { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.disposed(by: disposeBag)

        // days + events => filteredEvents
        // 注意，combineLatest 在开始调用你的闭包之前，会等待它的所有可观察序列发出一个元素。
        Observable.combineLatest(days, events) { days, events -> [EOEvent] in
            let maxInterval = TimeInterval(days * 24 * 3600)
            
            // 过滤并保留你感兴趣的最后 N 天
            return events.filter { event in
                if let date = event.date {
                    return abs(date.timeIntervalSinceNow) < maxInterval
                }
                return true
            }
        }
        .bind(to: filteredEvents)
        .disposed(by: disposeBag)

        days.asObservable().subscribe(onNext: { [weak self] days in
            self?.daysLabel.text = "Last \(days) days"
        })
        .disposed(by: disposeBag)
    }

    // 绑定 UISlider 滑块的值到 days
    @IBAction func sliderAction(slider: UISlider) {
        days.accept(Int(slider.value))
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        let event = filteredEvents.value[indexPath.row]
        cell.configure(event: event)
        return cell
    }
}
