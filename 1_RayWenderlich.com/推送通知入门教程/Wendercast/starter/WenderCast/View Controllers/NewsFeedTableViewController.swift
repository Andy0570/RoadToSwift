/// Copyright (c) 2020 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SafariServices

class NewsFeedTableViewController: UITableViewController {
  static let refreshNewsFeedNotification = Notification.Name(rawValue: "RefreshNewsFeedNotification")
  let newsStore = NewsStore.shared

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 75

    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(NewsFeedTableViewController.receivedRefreshNewsFeedNotification(_:)),
      name: NewsFeedTableViewController.refreshNewsFeedNotification,
      object: nil)
  }

  @objc func receivedRefreshNewsFeedNotification(_ notification: Notification) {
    DispatchQueue.main.async {
      self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsFeedTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsStore.items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath)
    if let newsCell = cell as?  NewsItemCell {
      newsCell.updateWithNewsItem(newsStore.items[indexPath.row])
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let item = newsStore.items[indexPath.row]
    if let url = URL(string: item.link), url.scheme == "https" {
      return true
    }
    return false
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = newsStore.items[indexPath.row]

    guard let url = URL(string: item.link) else {
      return
    }
    let safari = WenderSafariViewController(url: url)
    present(safari, animated: true, completion: nil)
  }
}
