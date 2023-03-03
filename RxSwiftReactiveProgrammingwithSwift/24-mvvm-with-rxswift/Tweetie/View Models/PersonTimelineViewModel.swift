import Foundation

import RxSwift
import RxCocoa

class PersonTimelineViewModel {
    private let fetcher: TimelineFetcher

    let username: String

    // MARK: - Input
    let account: Driver<TwitterAccount.AccountStatus>

    // MARK: - Output
    public lazy var tweets: Driver<[Tweet]> = {
        return self.fetcher.timeline
            .asDriver(onErrorJustReturn: [])
            .scan([]) { lastList, newList in
                return newList + lastList
            }
    }()

    // MARK: - Init
    init(account: Driver<TwitterAccount.AccountStatus>, username: String, apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
        self.account = account
        self.username = username

        fetcher = TimelineFetcher(account: account, username: username, apiType: apiType)
    }
}
