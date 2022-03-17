//
//  ChirperViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import UIKit

// 包含关联值的枚举类型，用于描述当前列表的不同状态，同时传递 Recording 数据
enum State {
    case loading
    case populated([Recording])
    case paging([Recording], next: Int)
    case empty
    case error(Error)

    // 计算属性，返回当前状态下的 Recording 数据
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

class ChirperViewController: UIViewController {
    weak var tableView: UITableView!

    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 128)
        loadingView.activityIndicator.color = darkGreen
        return loadingView
    }()

    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.frame = view.bounds
        return emptyView
    }()

    private lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.frame = view.bounds
        return errorView
    }()

    let searchController = UISearchController(searchResultsController: nil)
    let networkingService = NetworkingService()
    let darkGreen = UIColor(red: 11/255, green: 86/255, blue: 14/255, alpha: 1)

    var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }

    override func loadView() {
        super.loadView()

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
        title = "Chirper"

        view.backgroundColor = UIColor.systemBackground
        prepareNavigationBar()
        prepareSearchBar()
        prepareTableView()
        loadRecordings()
    }

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
            errorView.errorDescription = error.localizedDescription
            tableView.tableFooterView = errorView
        case .paging:
            tableView.tableFooterView = loadingView
        }
    }

    // MARK: - View Configuration

    func prepareSearchBar() {
        // 在搜索过程中基础内容是否隐藏
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no

        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white

        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        textFieldInSearchBar.defaultTextAttributes = whiteTitleAttributes

        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }

    func prepareNavigationBar() {
        navigationController?.navigationBar.barTintColor = darkGreen

        let whiteTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = whiteTitleAttributes
    }

    func prepareTableView() {
        // 自适应 Cell 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.register(BirdSoundTableViewCell.nib, forCellReuseIdentifier: BirdSoundTableViewCell.identifier)
    }
}

// MARK: - UISearchBarDelegate

extension ChirperViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadRecordings), object: nil)
        perform(#selector(loadRecordings), with: nil, afterDelay: 0.5)
    }
}

// MARK: - UITableViewDataSource

extension ChirperViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.currentRecordings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BirdSoundTableViewCell.identifier, for: indexPath) as? BirdSoundTableViewCell else {
            fatalError("Could not dequeue cell: BirdSoundTableViewCell")
        }

        cell.configure(recording: state.currentRecordings[indexPath.row])

        // 加载更多数据
        if case .paging(_, let nextPage) = state,
            indexPath.row == state.currentRecordings.count - 1 {
            loadPage(nextPage)
        }
        return cell
    }
}
