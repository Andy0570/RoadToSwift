import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

class ListTimelineViewModel {
    private let bag = DisposeBag()
    private let fetcher: TimelineFetcher

    let list: ListIdentifier
    let account: Driver<TwitterAccount.AccountStatus>

    // MARK: - Input
    // 一个让你暂停和恢复 TimelineFetcher 实例获取推文数据的输入属性
    var paused: Bool = false {
        didSet {
            fetcher.paused.accept(paused)
        }
    }
    
    // MARK: - Output
    // 获取的推文列表
    private(set) var tweets: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)>!
    // 登录状态
    private(set) var loggedIn: Driver<Bool>!
    
    // MARK: - Init
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        self.account = account
        self.list = list

        // fetch and store tweets
        fetcher = TimelineFetcher(account: account, list: list, apiType: apiType)

        // 订阅 TimelineFetcher 的结果并将推文存储到 Realm 中
        // Realm.rx.add 将收到的对象持久化到应用程序的默认 Realm 数据库中
        fetcher.timeline
            .subscribe(Realm.rx.add(update: .all))
            .disposed(by: bag)

        bindOutput()
    }
    
    // MARK: - Methods
    private func bindOutput() {
        // Bind tweets
        guard let realm = try? Realm() else {
            return
        }
        // 从所有持久化的 tweets 中创建了一个结果集，并对该集合的变化进行订阅
        tweets = Observable.changeset(from: realm.objects(Tweet.self))
        
        // Bind if an account is available
        // 订阅帐户并将其元素映射为 true 或 false。附加到 bindOutput
        loggedIn = account.map({ status in
            switch status {
            case .unavailable:
                return false
            case .authorized:
                return true
            }
        }).asDriver(onErrorJustReturn: false)
    }
}
