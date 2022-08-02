/// Copyright (c) 2019 Razeware LLC
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

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!

    var candies: [Candy] = []
    var filteredCandies: [Candy] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        // return searchController.isActive && !isSearchBarEmpty
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        candies = Candy.candies()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        // 将 searchBar 添加到 navigationItem
        navigationItem.searchController = searchController
        // 确保当 UISearchController 处于 active 状态时，用户导航到另一个视图控制器时，搜索栏不会保留在屏幕上。
        definesPresentationContext = true

        searchController.searchBar.scopeButtonTitles = Candy.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { notification in
            self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            self.handleKeyboard(notification: notification)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 取消选中 cell
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else {
            return
        }

        let candy: Candy
        if isFiltering {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }

        detailViewController.candy = candy
    }

    private func filterContentForSearchText(_ searchText: String, category: Candy.Category? = nil) {
//        filteredCandies = candies.filter { (candy: Candy) -> Bool in
//            return candy.name.lowercased().contains(searchText.lowercased())
//        }

        filteredCandies = candies.filter { (candy: Candy) -> Bool in
            let doesCategoryMatch = category == .all || candy.category == category

            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        }

        tableView.reloadData()
    }

    private func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.searchFooterBottomConstraint.constant = keyboardHeight
          self.view.layoutIfNeeded()
        })
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        } else {
            searchFooter.setNotFiltering()
            return candies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let candy: Candy
        if isFiltering {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }

        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category.rawValue
        return cell
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}
