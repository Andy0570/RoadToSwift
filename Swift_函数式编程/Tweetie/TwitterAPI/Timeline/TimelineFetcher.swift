import Foundation

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift
import Reachability
import Unbox

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
        // subscribe for the current twitter account
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

        // timer that emits a reachable logged account
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

        let feedCursor = BehaviorRelay<TimelineCursor>(value: .none)

        // Re-fetch the timeline

        // timeline = Observable<[Tweet]>.empty()
        timeline = reachableTimerWithAccount.withLatestFrom(feedCursor.asObservable()) { account, cursor in
            return (account: account, cursor: cursor)
        }
        .flatMapLatest(jsonProvider)
        .map(Tweet.unboxMany)
        .share(replay: 1)


        // Store the latest position through timeline

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
