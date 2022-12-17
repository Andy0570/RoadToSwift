import Foundation

import RxSwift
import RxCocoa

class PersonTimelineViewModel {
  private let fetcher: TimelineFetcher

  let username: String

  // MARK: - Input
  let account: Driver<TwitterAccount.AccountStatus>

  // MARK: - Output
  public var tweets: Driver<[Tweet]>!

  // MARK: - Init
  init(account: Driver<TwitterAccount.AccountStatus>, username: String, apiType: TwitterAPIProtocol.Type = TwitterAPI.self) {
    self.account = account
    self.username = username

    fetcher = TimelineFetcher(account: account, username: username, apiType: apiType)
  }
}
