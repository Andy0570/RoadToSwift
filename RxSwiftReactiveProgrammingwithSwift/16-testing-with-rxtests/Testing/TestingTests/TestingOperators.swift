import XCTest
import RxSwift
import RxTest
import RxBlocking

class TestingOperators : XCTestCase {
    var scheduler: TestScheduler!
    var subscription: Disposable!

    // 每个测试用例开始前，都会调用 setUp() 方法
    override func setUp() {
        super.setUp()

        // 初始时钟为 0 的测试调度器
        scheduler = TestScheduler(initialClock: 0)
    }

    // tearDown() 在每个测试完成后被调用
    override func tearDown() {
        // 在 1000 个虚拟时间单位后弃置测试的订阅，并将调度器设置为 nil 以释放内存
        // 你所使用的时间值并不对应于实际的秒数；它们是 RxTest 内部计算的虚拟时间单位。
        scheduler.scheduleAt(1000) {
            self.subscription.dispose()
        }
        scheduler = nil
        super.tearDown()
    }

    // 与所有使用 XCTest 的测试一样，测试方法名必须以 test 开头
    // 测试 amb 运算符：同时订阅两个可观察序列，它等待它们中的任何一个发出一个元素，然后取消对另一个的订阅。
    func testAmb() {
        let observer = scheduler.createObserver(String.self)

        let observableA = scheduler.createHotObservable([
            .next(100, "a"),
            .next(200, "b"),
            .next(300, "c"),
        ])

        let observableB = scheduler.createHotObservable([
            .next(90, "1"),
            .next(200, "2"),
            .next(300, "3"),
        ])

        let ambObservable = observableA.amb(observableB)
        // 将订阅分配给 subscription 属性，这样它将在 tearDown() 中被弃置
        self.subscription = ambObservable.subscribe(observer)
        scheduler.start()

        let results = observer.events.compactMap {
            $0.value.element
        }
        // 验证实际结果与预期相符
        XCTAssertEqual(results, ["1", "2", "3"])
    }

    func testFilter() {
        // 创建一个 Int 类型的观察者
        let observer = scheduler.createObserver(Int.self)

        // 创建一个热信号，每隔一段虚拟世界发送一个 next 事件
        let observable = scheduler.createHotObservable([
            .next(100, 1),
            .next(200, 2),
            .next(300, 3),
            .next(400, 2),
            .next(500, 1),
        ])

        // 过滤可观察序列，要求元素值 < 3
        let filterObservable = observable.filter {
            $0 < 3
        }

        // 在虚拟时间 0 时开始订阅，
        scheduler.scheduleAt(0) {
            self.subscription = filterObservable.subscribe(observer)
        }
        scheduler.start()

        // 收集结果
        let result = observer.events.compactMap {
            $0.value.element
        }

        // 断言结果是否满足预期
        XCTAssertEqual(result, [1, 2, 2, 1])
    }

    func testToArray() throws {
        // 创建一个并发调度器来执行该异步测试
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

        // toBlocking() 操作符将 toArrayObservable 转换为一个阻塞的可观察序列，阻塞由调度器产生的线程，直到它终止。
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)

        XCTAssertEqual(try toArrayObservable.toBlocking().toArray(), [1, 2])
    }

    func testToArrayMaterialized() {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)

        let result = toArrayObservable
            .toBlocking()
            .materialize()

        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements, [1, 2])
        case .failed(_, let error):
            XCTFail(error.localizedDescription)
        }
    }
}
