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

let elementsPerSecond = 1 // 发射频率
let maxElements = 58 // 发射元素数量上限
let replayedElements = 1 // 重放元素数量
let replayDelay: TimeInterval = 3 // 重放元素延迟时间间隔

//let sourceObservable = Observable<Int>.create { observer in
//    var value = 1
//    let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
//        if value <= maxElements {
//            observer.onNext(value)
//            value += 1
//        }
//    }
//
//    return Disposables.create {
//        timer.suspend()
//    }
//}.replayAll()

let sourceObservable = Observable<Int>.interval(.milliseconds(Int(1000.0/Double(elementsPerSecond))), scheduler: MainScheduler.instance).replay(replayedElements)


let sourceTimeline = TimelineView<Int>.make()
let replayedTimeline = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("replayAll"),
    UILabel.make("Emit \(elementsPerSecond) per second:"),
    sourceTimeline,
    UILabel.make("Replay All after \(replayDelay) sec:"),
    replayedTimeline
])

// 订阅源可观察序列，绑定到源时间轴视图上显示
_ = sourceObservable.subscribe(sourceTimeline)

// 延迟3秒后，继续订阅源可观察序列，绑定到另一个时间轴视图上
DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
    _ = sourceObservable.subscribe(replayedTimeline)
}

// replay(_:) 创建了一个 connectable observable，你需要将它连接到它的底层源，以开始接收元素。
_ = sourceObservable.connect()

let hostView = setupHostView()
hostView.addSubview(stack)
hostView
