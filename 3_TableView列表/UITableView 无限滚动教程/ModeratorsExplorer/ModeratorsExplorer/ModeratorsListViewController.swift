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

import UIKit

class ModeratorsListViewController: UIViewController, AlertDisplayer {
  private enum CellIdentifiers {
    static let list = "List"
  }
  
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  @IBOutlet var tableView: UITableView!
  
  var site: String!
  
  private var viewModel: ModeratorsViewModel!
  
  private var shouldShowLoadingCell = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    indicatorView.color = ColorPalette.RWGreen
    indicatorView.startAnimating()
    
    tableView.isHidden = true
    tableView.separatorColor = ColorPalette.RWGreen
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    
    let request = ModeratorRequest.from(site: site)
    viewModel = ModeratorsViewModel(request: request, delegate: self)
    
    viewModel.fetchModerators()
  }
}

// MARK: - UITableViewDataSource

extension ModeratorsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 返回所有数据源数量
    return viewModel.totalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! ModeratorTableViewCell
    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: viewModel.moderator(at: indexPath.row))
    }
    return cell
  }
}

extension ModeratorsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.fetchModerators()
    }
  }
}

// MARK: - ModeratorsViewModelDelegate

extension ModeratorsListViewController: ModeratorsViewModelDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      indicatorView.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      return
    }

    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }
  
  func onFetchFailed(with reason: String) {
    indicatorView.stopAnimating()
    
    let title = "Warning".localizedString
    let action = UIAlertAction(title: "OK".localizedString, style: .default)
    displayAlert(with: title , message: reason, actions: [action])
  }
}

private extension ModeratorsListViewController {
  // 判断当前 cell 索引是否超出了已获得的数据源数量
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  // 计算收到新数据时需要重新加载的 tableView 视图的 cell 单元格
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    // 计算传入的 IndexPaths 与当前页面可见的 IndexPaths 的交集
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
