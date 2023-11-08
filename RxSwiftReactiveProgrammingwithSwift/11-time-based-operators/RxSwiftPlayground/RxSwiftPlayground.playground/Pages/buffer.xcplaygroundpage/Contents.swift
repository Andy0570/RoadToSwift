// 如果这一行报错，请先编译一遍 RxCocoa 组件！
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

let bufferTimeSpan: RxTimeInterval = .seconds(4)
let bufferMaxCount = 2

let sourceObservable = PublishSubject<String>()

let sourceTimeline = TimelineView<String>.make()
let bufferedTimeline = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("buffer"),
    UILabel.make("Emitted elements:"),
    sourceTimeline,
    UILabel.make("Buffered elements (at most \(bufferMaxCount) every \(bufferTimeSpan) seconds):"),
    bufferedTimeline
])

_ = sourceObservable.subscribe(sourceTimeline)

// 缓冲时间轴将显示每个缓冲数组中包含的元素数量
// 每个数组最多可以容纳 bufferMaxCount 个元素
sourceObservable.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance)
    .map(\.count)
    .subscribe(bufferedTimeline)

let hostView = setupHostView()
hostView.addSubview(stack)
hostView

// 在五秒钟内推送三个元素
//DispatchQueue.main.asyncAfter(deadline: .now() + 5) { sourceObservable.onNext("🐱")
//    sourceObservable.onNext("🐱")
//    sourceObservable.onNext("🐱")
//}

let elementsPerSecond = 0.7
let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
    sourceObservable.onNext("🐱")
}
