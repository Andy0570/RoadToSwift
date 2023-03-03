import RxCocoa
import UIKit
import RxSwift

// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
    static func make() -> TimelineView<E> {
        let view = TimelineView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        view.setup()
        return view
    }
    public func on(_ event: Event<E>) {
        switch event {
        case .next(let value):
            add(.next(String(describing: value)))
        case .completed:
            add(.completed())
        case .error(_):
            add(.error())
        }
    }
}

let elementsPerSecond = 3
let windowTimeSpan: RxTimeInterval = .seconds(4)
let windowMaxCount = 10
let sourceObservable = PublishSubject<String>()

let sourceTimeline = TimelineView<String>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("window"),
    UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
    sourceTimeline,
    UILabel.make("Windowed observables (at most \(windowMaxCount) every \(windowTimeSpan) sec):")
])

let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
    sourceObservable.onNext("🐱")
}

_ = sourceObservable.subscribe(sourceTimeline)

_ = sourceObservable
    .window(timeSpan: windowTimeSpan, count: windowMaxCount, scheduler: MainScheduler.instance)
    .flatMap({ windowObservable -> Observable<(TimelineView<Int>, String?)> in
        let timeline = TimelineView<Int>.make()
        stack.insert(timeline, at: 4)
        stack.keep(atMost: 8)
        return windowObservable
            .map { value in (timeline, value) }
            .concat(Observable.just((timeline, nil)))
    })
    .subscribe(onNext: { tuple in
        let (timeline, value) = tuple
        if let value = value {
            timeline.add(.next(value))
        } else {
            // 如果元组中的值为 nil，意味着该可观察序列已完成
            timeline.add(.completed(true))
        }
    })

let hostView = setupHostView()
hostView.addSubview(stack)
hostView
