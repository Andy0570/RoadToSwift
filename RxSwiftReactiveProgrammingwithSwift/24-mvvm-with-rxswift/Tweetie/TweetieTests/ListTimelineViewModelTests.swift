import XCTest
import Accounts
import RxSwift
import RxCocoa
import RxBlocking
import Unbox
import RealmSwift
import RxRealm

@testable import Tweetie

class ListTimelineViewModelTests: XCTestCase {
    private func createViewModel(_ account: Driver<TwitterAccount.AccountStatus>) -> ListTimelineViewModel {
        return ListTimelineViewModel(
            account: account,
            list: TestData.listId,
            apiType: TwitterTestAPI.self)
    }

    // 测试视图模型是否坚持其注入的依赖关系
    func test_whenInitialized_storesInitParams() {
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))

        XCTAssertNotNil(viewModel.account)
        XCTAssertEqual(viewModel.list.username+viewModel.list.slug,
                       TestData.listId.username+TestData.listId.slug)
        XCTAssertFalse(viewModel.paused)
    }

    // 检查视图模型是否通过其 tweets 属性公开最新的持久化的 tweets
    func test_whenInitialized_bindsTweets() {
        Realm.useCleanMemoryRealmByDefault(identifier: #function)

        let realm = try! Realm()
        try! realm.write {
            realm.add(TestData.tweets)
        }

        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        let result = viewModel.tweets

        let emitted = try! result!.toBlocking(timeout: 1).first()!
        XCTAssertTrue(emitted.0.count == 3)
    }

    // 检查 loggedIn 输出属性是否反映账户认证状态
    func test_whenAccountAvailable_updatesAccountStatus() {
        // 你将测试由视图模型的 loggedIn 属性发出的元素，因此你告诉观察者要监听 Bool 元素
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))

        let loggedIn = viewModel.loggedIn.asObservable().materialize()

        DispatchQueue.main.async {
            accountSubject.onNext(.authorized(AccessToken()))
            accountSubject.onNext(.unavailable)
            accountSubject.onCompleted()
        }

        // 订阅 loggedIn，取3个事件并检查它们是否符合期望
        let emitted = try! loggedIn.take(3).toBlocking(timeout: 1).toArray()
        
        XCTAssertEqual(emitted[0].element, true)
        XCTAssertEqual(emitted[1].element, false)
        XCTAssertTrue(emitted[2].isCompleted)
    }
}
