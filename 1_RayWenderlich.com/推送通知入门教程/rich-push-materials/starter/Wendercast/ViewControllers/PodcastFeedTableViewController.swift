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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class PodcastFeedTableViewController: UITableViewController {
  let podcastStore = PodcastStore.sharedStore
  
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
    
    podcastStore.refreshItems { didLoadNewItems in
      if didLoadNewItems {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
    
    NotificationCenter.default.addObserver(
      forName: Notification.Name.appEnteringForeground,
      object: nil,
      queue: nil
    ) { _ in
      self.podcastStore.reloadCachedData()
      self.tableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    PodcastStore.sharedStore.reloadCachedData()
    tableView.reloadData()
  }
  
  @IBSegueAction
  func createPodcastItemViewController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> PodcastItemViewController? {
    guard let indexPath = tableView.indexPathsForSelectedRows?.first else {
      return nil
    }
    
    let podcastItem = podcast(for: indexPath)
    return PodcastItemViewController(coder: coder, podcastItem: podcastItem)
  }
  
  private func podcast(for indexPath: IndexPath) -> PodcastItem {
    return podcastStore.items[indexPath.row]
  }
  
  func loadPodcastDetail(for podcast: PodcastItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailVC = storyboard.instantiateViewController(identifier: "PodcastItemViewController") { coder in
      return PodcastItemViewController(coder: coder, podcastItem: podcast)
    }
    
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PodcastFeedTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcastStore.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastItemCell", for: indexPath)
    
    if let podcastCell = cell as? PodcastItemCell {
      let podcastItem = podcast(for: indexPath)
      podcastCell.update(with: podcastItem)
    }
    
    return cell
  }
}
