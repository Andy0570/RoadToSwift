import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Testing

class TestingViewModel : XCTestCase {
    var viewModel: ViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUp() {
        super.setUp()

        viewModel = ViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    func testColorIsRedWhenHexStringIsFF0000_async() {
        let disposeBag = DisposeBag()

        // 创建一个期望，以便日后实现
        let expect = expectation(description: #function)
        // 创建一个预期的测试结果expectedColor，等于红色。
        let expectedColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        // 定义以后要分配的结果
        var result: UIColor!
        // 创建一个对视图模型的 color drivew 的订阅
        viewModel.color.asObservable()
            .skip(1) // 跳过第一个元素，因为 Driver 会在订阅时重放初始元素。
            .subscribe(onNext: {
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.hexString.accept("#ff0000")

        // 用1秒的超时来等待期望值的实现
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            // 断言预期的颜色与实际的结果相等
            XCTAssertEqual(expectedColor, result)
        }
    }

    func testColorIsRedWhenHexStringIsFF0000() throws {
        // 创建 colorObservable 以确保在并发调度器上订阅可观察序列。
        let colorObservable = viewModel.color.asObservable().subscribeOn(scheduler)

        viewModel.hexString.accept("#ff0000")

        // 阻塞可观察序列，等待第一个元素被发射出来，断言它发出预期的颜色
        XCTAssertEqual(try colorObservable.toBlocking(timeout: 1.0).first(), .red)
    }

    func testRgbIs010WhenHexStringIs00FF00() throws {
        let rgbObservable = viewModel.rgb.asObservable().subscribeOn(scheduler)

        viewModel.hexString.accept("#00ff00")

        let result = try rgbObservable.toBlocking().first()!

        XCTAssertEqual(0 * 255, result.0)
        XCTAssertEqual(1 * 255, result.1)
        XCTAssertEqual(0 * 255, result.2)
    }

    func testColorNameIsRayWenderlichGreenWhenHexStringIs006636() throws {
        let colorNameObservable = viewModel.colorName.asObservable().subscribeOn(scheduler)

        viewModel.hexString.accept("#006636")

        XCTAssertEqual("rayWenderlichGreen", try colorNameObservable.toBlocking().first()!)
    }
}
