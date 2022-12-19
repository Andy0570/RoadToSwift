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

// 包含关联值的枚举类型，描述视图控制器的不同状态
enum State {
  case loading
  case populated([Recording])
  case empty
  case error(Error)
  case paging([Recording], next: Int)

  // 计算属性，返回当前数据
  var currentRecordings: [Recording] {
    switch self {
    case .populated(let recordings):
      return recordings
    case .paging(let recordings, _):
      return recordings
    default:
      return []
    }
  }
}

class MainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var errorView: UIView!
  
  let searchController = UISearchController(searchResultsController: nil)
  let networkingService = NetworkingService()
  let darkGreen = UIColor(red: 11/255, green: 86/255, blue: 14/255, alpha: 1)

  var state = State.loading {
    didSet {
      setFooterView()
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Chirper"
    activityIndicator.color = darkGreen
    prepareNavigationBar()
    prepareSearchBar()
    prepareTableView()
    loadRecordings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.searchBar.becomeFirstResponder()
  }
  
  // MARK: - Loading recordings
  
  @objc func loadRecordings() {
    state = .loading
    loadPage(1)
  }

  func loadPage(_ page: Int) {
    let query = searchController.searchBar.text
    networkingService.fetchRecordings(matching: query, page: page) { [weak self] response in
      self?.searchController.searchBar.endEditing(true)
      self?.update(response: response)
    }
  }

  func update(response: RecordingsResult) {
    if let error = response.error {
      state = .error(error)
      return
    }

    guard let newRecordings = response.recordings, !newRecordings.isEmpty else {
      state = .empty
      return
    }

    // print(newRecordings)

    // 增量添加数据，将新数据附加到旧有数据末尾
    var allRecordings = state.currentRecordings
    allRecordings.append(contentsOf: newRecordings)

    if response.hasMorePages {
      state = .paging(allRecordings, next: response.nextPage)
    } else {
      state = .populated(allRecordings)
    }
  }

  func setFooterView() {
    switch state {
    case .loading:
      tableView.tableFooterView = loadingView
    case .populated:
      tableView.tableFooterView = nil
    case .empty:
      tableView.tableFooterView = emptyView
    case .error(let error):
      errorLabel.text = error.localizedDescription
      tableView.tableFooterView = errorView
    case .paging:
      tableView.tableFooterView = loadingView
    }
  }
  
  // MARK: - View Configuration
  
  func prepareSearchBar() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.autocorrectionType = .no
    
    searchController.searchBar.tintColor = .white
    searchController.searchBar.barTintColor = .white
    
    let whiteTitleAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
    let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
    textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes
    
    navigationItem.searchController = searchController
    searchController.searchBar.becomeFirstResponder()
  }
  
  func prepareNavigationBar() {
    navigationController?.navigationBar.barTintColor = darkGreen
    
    let whiteTitleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = whiteTitleAttributes
  }
  
  func prepareTableView() {
    tableView.dataSource = self
    
    let nib = UINib(nibName: BirdSoundTableViewCell.NibName, bundle: .main)
    tableView.register(nib, forCellReuseIdentifier: BirdSoundTableViewCell.ReuseIdentifier)
  }
  
}

// MARK: -

extension MainViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar,
                 selectedScopeButtonIndexDidChange selectedScope: Int) {
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    NSObject.cancelPreviousPerformRequests(withTarget: self,
                                           selector: #selector(loadRecordings),
                                           object: nil)
    
    perform(#selector(loadRecordings), with: nil, afterDelay: 0.5)
  }
  
}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return state.currentRecordings.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: BirdSoundTableViewCell.ReuseIdentifier)
      as? BirdSoundTableViewCell else {
        return UITableViewCell()
    }

    cell.load(recording: state.currentRecordings[indexPath.row])

    if case .paging(_, let nextPage) = state,
      indexPath.row == state.currentRecordings.count - 1 {
      loadPage(nextPage)
    }
    
    return cell
  }
}

