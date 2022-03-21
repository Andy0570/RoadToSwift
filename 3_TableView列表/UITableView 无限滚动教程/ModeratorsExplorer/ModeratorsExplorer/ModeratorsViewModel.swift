/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

protocol ModeratorsViewModelDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {
  private weak var delegate: ModeratorsViewModelDelegate?
  
  private var moderators: [Moderator] = []
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false
  
  let client = StackExchangeClient()
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

    client.fetchModerators(with: request, page: currentPage) { result in
      switch result {
      case .failure(let error):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.delegate?.onFetchFailed(with: error.reason)
        }
      case .success(let response):
        DispatchQueue.main.async {
          self.currentPage += 1
          self.isFetchInProgress = false

          self.total = response.total
          self.moderators.append(contentsOf: response.moderators)

          if response.page > 1 {
            let indexPathToReload = self.calculateIndexPathsToReload(form: response.moderators)
            self.delegate?.onFetchCompleted(with: indexPathToReload)
          } else {
            self.delegate?.onFetchCompleted(with: .none)
          }
        }
      }
    }
  }

  // 计算需要重新加载的 IndexPath 索引
  private func calculateIndexPathsToReload(form newModerators: [Moderator]) -> [IndexPath] {
    let startIndex = moderators.count - newModerators.count
    let endIndex = startIndex + newModerators.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }

}
