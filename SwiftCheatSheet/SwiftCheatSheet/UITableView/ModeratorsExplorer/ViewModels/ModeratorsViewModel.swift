//
//  ModeratorsViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

protocol ModeratorsViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {
    private weak var delegate: ModeratorsViewModelDelegate?

    private var moderators: [Moderator] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false

    let cliend = StackExchangeClient()
    let request: ModeratorRequest

    init(request: ModeratorRequest, delegate: ModeratorsViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }

    var totalCount: Int {
        return total
    }

    var currentCount: Int {
        return moderators.count
    }

    func moderator(at index: Int) -> Moderator {
        return moderators[index]
    }

    func fetchModerators() {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true
        cliend.fetchModerators(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.currentPage += 1 // 网络请求成功，分页查询参数自增1

                    self.total = response.total
                    self.moderators.append(contentsOf: response.moderators)

                    if response.page > 1 {
                        let indexPathToReload = self.calculateIndexPathsToReload(from: response.moderators)
                        self.delegate?.onFetchCompleted(with: indexPathToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }

    // 计算需要重新加载的 IndexPath 索引
    private func calculateIndexPathsToReload(from newModerators: [Moderator]) -> [IndexPath] {
        let startIndex = moderators.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
