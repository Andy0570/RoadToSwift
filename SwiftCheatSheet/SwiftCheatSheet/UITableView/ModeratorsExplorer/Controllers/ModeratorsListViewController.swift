//
//  ModeratorsListViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit

class ModeratorsListViewController: UIViewController {
    weak var tableView: UITableView!
    weak var indicatorView: UIActivityIndicatorView!

    var site: String!
    private var viewModel: ModeratorsViewModel!
    private var shouldShowLoadingCell = false

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground

        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = UIActivityIndicatorView.Style.medium
        indicatorView.color = UIColor.rwGreen
        view.addSubview(indicatorView)
        self.indicatorView = indicatorView
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        self.tableView = tableView
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = site

        indicatorView.startAnimating()

        tableView.isHidden = true
        tableView.separatorColor = UIColor.rwGreen
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(ModeratorTableViewCell.nib, forCellReuseIdentifier: ModeratorTableViewCell.identifier)

        let request = ModeratorRequest.from(site: site)
        viewModel = ModeratorsViewModel(request: request, delegate: self)
        viewModel.fetchModerators()
    }
}

// MARK: - UITableViewDataSource

extension ModeratorsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // !!!: 返回所有数据源的数量
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ModeratorTableViewCell.identifier, for: indexPath) as? ModeratorTableViewCell else {
            fatalError("Could not dequeue cell: ModeratorTableViewCell")
        }

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.moderator(at: indexPath.row))
        }
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

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

        let indexPathsToReload = visbleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()

        // SwifterSwift/UIViewControllerExtensions.swift
        showToast(message: "Warning", font: UIFont.systemFont(ofSize: 13), toastColor: UIColor.black, toastBackground: UIColor(white: 1.0, alpha: 0.8))
    }
}

private extension ModeratorsListViewController {
    // 判断当前 cell 索引是否超出了已获得的数据源数量
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    // 计算收到新数据时需要重新加载的 tableView 视图的 cell 单元格
    func visbleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        // 计算传入的 IndexPaths 与当前页面可见的 IndexPaths 的交集
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
