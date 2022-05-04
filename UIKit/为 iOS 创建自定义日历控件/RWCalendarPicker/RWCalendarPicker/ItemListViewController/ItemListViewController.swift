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

class ItemListViewController: UITableViewController {
    // MARK: Diffable Data Source Setup

    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ChecklistItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChecklistItem>

    // MARK: Properties

    private lazy var dataSource = makeDataSource()
    private lazy var items = ChecklistItem.exampleItems

    private var searchQuery: String? = nil {
        didSet {
            applySnapshot()
        }
    }

    // MARK: Controller Setup

    private lazy var searchController = makeSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Checkmate"

        navigationItem.searchController = searchController
        definesPresentationContext = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .done,
            target: self,
            action: #selector(didTapNewItemButton)
        )
        navigationItem.rightBarButtonItem?.accessibilityLabel = "New Item"

        tableView.register(
            ChecklistItemTableViewCell.self,
            forCellReuseIdentifier: ChecklistItemTableViewCell.reuseIdentifier)

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applySnapshot(animatingDifferences: false)
    }

    @objc func didTapNewItemButton() {
        let newItemAlert = UIAlertController(
            title: "New Item",
            message: "What would you like to do today?",
            preferredStyle: .alert)
        newItemAlert.addTextField { textField in
            textField.placeholder = "Item Text"
        }
        newItemAlert.addAction(UIAlertAction(title: "Create Item", style: .default) { [weak self] _ in
            guard let self = self else { return }

            guard
                let title = newItemAlert.textFields?[0].text,
                !title.isEmpty
            else {
                let errorAlert = UIAlertController(
                    title: "Error",
                    message: "You can't leave the title empty.",
                    preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }

            self.items.append(
                ChecklistItem(title: title, date: Date())
            )

            self.applySnapshot()
        })
        newItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(newItemAlert, animated: true, completion: nil)
    }
}

// MARK: Table View Methods

extension ItemListViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var items: [ChecklistItem] = self.items

        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            items = items.filter { item in
                return item.title.lowercased().contains(searchQuery.lowercased())
            }
        }

        items = items.sorted { one, two in
            return one.date < two.date
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChecklistItemTableViewCell.reuseIdentifier,
                for: indexPath) as? ChecklistItemTableViewCell
            cell?.item = item
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ItemDetailViewController(item: items[indexPath.row]), animated: true)
    }

    // MARK: Contexual Menus

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard
                let self = self,
                let item = self.dataSource.itemIdentifier(for: indexPath)
            else {
                return nil
            }

            let deleteAction = UIAction(
                title: "Delete Item",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                    self.items.removeAll { existingItem in
                        return existingItem == item
                    }

                    self.applySnapshot()
                }

            return UIMenu(title: item.title.truncatedPrefix(12), image: nil, children: [deleteAction])
        }

        return configuration
    }
}

// MARK: Search Controller Setup

extension ItemListViewController: UISearchResultsUpdating {
    func makeSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Items"
        return controller
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text
    }
}
