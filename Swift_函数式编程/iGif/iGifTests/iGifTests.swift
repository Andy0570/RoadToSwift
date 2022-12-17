import XCTest
import RxSwift
import RxBlocking
import Nimble
import RxNimble
import OHHTTPStubs

@testable import iGif

class iGifTests: XCTestCase {
    let obj = ["array": ["foo", "bar"], "foo": "bar"] as [String: AnyHashable]
    let request = URLRequest(url: URL(string: "http://raywenderlich.com")!)
    let errorRequest = URLRequest(url: URL(string: "http://rw.com")!)

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
        stub(condition: isHost("raywenderlich.com")) { _ in
            return HTTPStubsResponse(jsonObject: self.obj, statusCode: 200, headers: nil)
        }
        stub(condition: isHost("rw.com")) { _ in
            return HTTPStubsResponse(error: RxURLSessionError.unknown)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }

    // 数据请求测试，检查一个请求是否返回 nil
    func testData() {
        let observable = URLSession.shared.rx.data(request: self.request)
        expect(observable.toBlocking().firstOrNil()).toNot(beNil())
    }

    func testString() {
        let observable = URLSession.shared.rx.string(request: self.request)
        let result = observable.toBlocking().firstOrNil() ?? ""

        let option1 = "{\"array\":[\"foo\",\"bar\"],\"foo\":\"bar\"}"
        let option2 = "{\"foo\":\"bar\",\"array\":[\"foo\",\"bar\"]}"

        expect(result == option1 || result == option2).to(beTrue())
    }

    // 将JSON响应转换为一个Dictionary，并与原始对象进行比较。
    func testJSON() {
        let observable = URLSession.shared.rx.json(request: self.request)
        let obj = self.obj
        let result = observable.toBlocking().firstOrNil()

        expect(result as? [String: AnyHashable]) == obj
    }

    // 最后一个测试是确保错误被正确返回。比较两个错误是一个相当不常见的过程，所以对一个错误有一个相等的操作符是没有意义的。
    // 因此，测试应该使用do、try和catch来处理未知的错误。
    func testError() {
        var erroredCorrectly = false
        let observable = URLSession.shared.rx.json(request: self.errorRequest)
        do {
            _ = try observable.toBlocking().first()
            assertionFailure()
        } catch RxURLSessionError.unknown {
            erroredCorrectly = true
        } catch {
            //assertionFailure()
            erroredCorrectly = true
        }
        expect(erroredCorrectly) == true
    }
}

extension BlockingObservable {
    func firstOrNil() -> Element? {
        do {
            return try first()
        } catch {
            return nil
        }
    }
}
