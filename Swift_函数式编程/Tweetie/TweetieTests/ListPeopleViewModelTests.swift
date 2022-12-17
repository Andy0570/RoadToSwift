import XCTest
import Accounts
import RxSwift
import RxCocoa
import Unbox

@testable import Tweetie

class ListPeopleViewModelTests: XCTestCase {
    
    private func createViewModel(_ account: Driver<TwitterAccount.AccountStatus>) -> ListPeopleViewModel {
        return ListPeopleViewModel(
            account: account,
            list: TestData.listId,
            apiType: TwitterTestAPI.self)
    }
    
    func test_whenInitialized_storesInitParams() {
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        
        XCTAssertNotNil(viewModel.account)
        XCTAssertEqual(viewModel.list.username+viewModel.list.slug, TestData.listId.username+TestData.listId.slug)
        XCTAssertNotNil(viewModel.apiType)
    }
    
    func test_whenAccountAvailable_thenFetchesPeople() {
        TwitterTestAPI.reset()
        
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        XCTAssertNil(viewModel.people.value, "people is not nil by default")
        
        let people = viewModel.people.asObservable()
        
        DispatchQueue.main.async {
            accountSubject.onNext(.authorized(AccessToken()))
            TwitterTestAPI.objects.onNext([TestData.personJSON])
        }
        
        let emitted = try! people.take(2).toBlocking(timeout: 1).toArray()
        XCTAssertNil(emitted[0])
        XCTAssertEqual(emitted[1]![0].id, TestData.personUserObject.id)
        XCTAssertEqual(TwitterTestAPI.lastMethodCall, "members(of:)")
    }
}
