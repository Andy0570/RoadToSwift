import RxCocoa
import UIKit
import RxSwift

// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
    static func make() -> TimelineView<E> {
        return TimelineView(width: 400, height: 100)
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

let button = UIButton(type: .system)
button.setTitle("Press me now", for: .normal)
button.sizeToFit()

// 捕捉按钮点击，如果按钮在5秒内被按下，打印一些东西并终止序列。如果按钮没有被按下，则打印错误情况。
let tapsTimeline = TimelineView<String>.make()

let stack = UIStackView.makeVertical([
    button,
    UILabel.make("Taps on button above"),
    tapsTimeline
])

let _ = button.rx.tap
    .map { _ in "•" }
    .timeout(.seconds(5), other: Observable.just("X"), scheduler: MainScheduler.instance)
    .subscribe(tapsTimeline)

let hostView = setupHostView()
hostView.addSubview(stack)
hostView
