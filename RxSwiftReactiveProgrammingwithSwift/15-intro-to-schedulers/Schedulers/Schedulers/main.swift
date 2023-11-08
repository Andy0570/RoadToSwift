import Foundation
import RxSwift

print("\n\n\n===== Schedulers =====\n")

// 使用全局调度队列创建的并发队列
let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
let bag = DisposeBag()
let animal = BehaviorSubject(value: "[狗]")

animal
    .subscribe(on: MainScheduler.instance)
    .dump()
    .observe(on: globalScheduler)
    .dumpingSubscription()
    .disposed(by: bag)

//let fruit = Observable<String>.create { observer in
//    observer.onNext("[苹果]")
//    sleep(2)
//    observer.onNext("[菠萝]")
//    sleep(2)
//    observer.onNext("[草莓]")
//    return Disposables.create()
//}
//
//fruit
//    .subscribe(on: globalScheduler) // 改变发射器的调度器
//    .dump()
//    .observe(on: MainScheduler.instance) // 改变订阅者的调度器
//    .dumpingSubscription()
//    .disposed(by: bag)

// !!!: 原始计算在指定的 Thread() {} 线程中
let animalsThread = Thread() {
    sleep(3)
    animal.onNext("[猫]")
    sleep(3)
    animal.onNext("[老虎]")
    sleep(3)
    animal.onNext("[狐狸]")
    sleep(3)
    animal.onNext("[豹子]")
}

animalsThread.name = "动物线程"
animalsThread.start()

// 让终端额外存活 13s
RunLoop.main.run(until: Date(timeIntervalSinceNow: 13))
