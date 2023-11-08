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
    private let feedCursor = BehaviorRelay<TimelineCursor>(value: .none) // 重置光标

    // MARK: input
    let paused = BehaviorRelay<Bool>(value: false)

    // MARK: output
    let timeline: Observable<[Tweet]>

    // MARK: Init with list or user
    // 1.从指定的 Twitter 列表中获取推文
    convenience init(account: Driver<TwitterAccount.AccountStatus>, list: ListIdentifier, apiType: TwitterAPIProtocol.Type) {
        self.init(account: account, jsonProvider: apiType.timeline(of: list))
    }

    // 2.获取指定用户的推文
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
            // 当处于联网状态时，通过 Rx 计时器每隔 30 秒抓取一次推文数据
            Observable<Int>.timer(.seconds(0), period: .seconds(timerDelay), scheduler: MainScheduler.instance),
            Reachability.rx.reachable, // 网络检测可达
            currentAccount, // 当前账户已登录
            paused.asObservable(), // 应用处于“非暂定”状态
            resultSelector: { _, reachable, account, paused in
                return (reachable && !paused) ? account : nil
            })
            .filter { $0 != nil }
            .map { $0! }

        // Re-fetch the timeline
        timeline = reachableTimerWithAccount
            .withLatestFrom(feedCursor.asObservable()) { account, cursor in
                return (account: account, cursor: cursor)
            }
            .flatMapLatest(jsonProvider) // jsonProvider 是一个被注入 init 方法的闭包，它返回一个 Observable<[JSONObject]>
            .map(Tweet.unboxMany) // 通过 Tweet.unboxMany 方法将 jsonProvider 返回类型映射到 Observable<[Tweet]>
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
