import Foundation
import Accounts
import Unbox

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

class ListPeopleViewModel {
    
    private let bag = DisposeBag()
    
    let list: ListIdentifier
    let apiType: TwitterAPIProtocol.Type
    
    // MARK: - Input
    let account: Driver<TwitterAccount.AccountStatus>
    
    // MARK: - Output
    let people = BehaviorRelay<[User]?>(value: nil)
    
    // MARK: - Init
    // 在初始化方法中，通过依赖注入的方式注入视图模型所需要的对象（在视图模型之间传递对象）
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        
        self.account = account
        self.list = list
        self.apiType = apiType
        
        bindOutput()
    }
    
    func bindOutput() {
        //observe the current account status
        let currentAccount = account
            .filter { account in
                switch account {
                case .authorized: return true
                default: return false
                }
            }
            .map { account -> AccessToken in
                switch account {
                case .authorized(let acaccount):
                    return acaccount
                default: fatalError()
                }
            }
            .distinctUntilChanged()
        
        //fetch list members
        currentAccount.asObservable()
            .flatMapLatest(apiType.members(of: list))
            .map { users in
                return (try? unbox(dictionaries: users, allowInvalidElements: true) as [User]) ?? []
            }
            .bind(to: people)
            .disposed(by: bag)
    }
}
