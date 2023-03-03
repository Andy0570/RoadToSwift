import Foundation

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift
import Reachability
import Unbox

// TimelineFetcher 负责在应用连接时自动重新获取最新的推文
class TimelineFetcher {
    private let timerDelay = 30
    private let bag = DisposeBag()
    private let feedCursor = BehaviorRelay<TimelineCursor>(value: .none)

    // MARK: input
    let paused = BehaviorRelay<Bool>(value: false)

    // MARK: output
    let timeline: Observable<[Tweet]>

    // MARK: Init with list or user
    // 从指定的 Twitter 列表中获取推文
    convenience init(account: Driver<TwitterAccount.AccountStatus>, list: ListIdentifier, apiType: TwitterAPIProtocol.Type) {
        self.init(account: account, jsonProvider: apiType.timeline(of: list))
    }

    // 获取指定用户的推文
    convenience init(account: Driver<TwitterAccount.AccountStatus>, username: String, apiType: TwitterAPIProtocol.Type) {
        self.init(account: account, jsonProvider: apiType.timeline(of: username))
    }

    private init(account: Driver<TwitterAccount.AccountStatus>,
                 jsonProvider: @escaping (AccessToken, TimelineCursor) -> Observable<[JSONObject]>) {
        //
        // subscribe for the current twitter account（订阅当前的 twitter 账户）
        //
        let currentAccount: Observable<AccessToken> = account
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
            .asObservable()

        // timer that emits a reachable logged account（定时器，发射一个可获得的已登录账户）
        let reachableTimerWithAccount = Observable.combineLatest(
            Observable<Int>.timer(.seconds(0), period: .seconds(timerDelay), scheduler: MainScheduler.instance),
            Reachability.rx.reachable,
            currentAccount,
            paused.asObservable(),
            resultSelector: { _, reachable, account, paused in
                return (reachable && !paused) ? account : nil
            })
            .filter { $0 != nil }
            .map { $0! }

        // 重置光标
        let feedCursor = BehaviorRelay<TimelineCursor>(value: .none)

        // Re-fetch the timeline
        timeline = reachableTimerWithAccount
            .withLatestFrom(feedCursor.asObservable()) { account, cursor in
                return (account: account, cursor: cursor)
            }
            .flatMapLatest(jsonProvider) // jsonProvider 返回一个 Observable<[JSONObject]>
            .map(Tweet.unboxMany) // 将 jsonProvider 返回类型映射到 Observable<[Tweet]>
            .share(replay: 1)

        // Store the latest position through timeline（通过时间轴存储最新的位置/光标）
        // 每当你抓取一批新的推文，你就更新 feedCursor 的值
        timeline
            .scan(.none, accumulator: TimelineFetcher.currentCursor)
            .bind(to: feedCursor)
            .disposed(by: bag)
    }

    static func currentCursor(lastCursor: TimelineCursor, tweets: [Tweet]) -> TimelineCursor {
        return tweets.reduce(lastCursor) { status, tweet in
            let max: Int64 = tweet.id < status.maxId ? tweet.id-1 : status.maxId
            let since: Int64 = tweet.id > status.sinceId ? tweet.id : status.sinceId
            return TimelineCursor(max: max, since: since)
        }
    }
}
