//
//  SearchGitHubViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa

/**
 一个搜索 GitHub 存储库的单页面应用

 参考：<http://rx-marin.com/post/dotswift-search-github-json-api/>
 另一个示例：<https://www.hangge.com/blog/cache/detail_2019.html>
 */
class SearchGitHubViewController: UIViewController {
    fileprivate enum Constants {
        static let rowHeight: CGFloat = 55
        static let cellIdentifier = "Cell"
        static let minimumSearchLength = 3
    }

    // MARK: - Controls
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.rowHeight = Constants.rowHeight
        return tableView
    }()

    // MARK: - Private
    private let repos: BehaviorRelay<[Repo]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "GitHub Search"
        view.backgroundColor = UIColor.systemBackground
        setupTableView()
        bindRepoWithTableView()
    }

    private func setupTableView() {
        navigationItem.titleView = searchBar
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            self?.tableView.deselectRow(at: index, animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindRepoWithTableView() {
        searchBar.rx.text
            /**
             rx.text 的问题在于，当 textField 内没有内容时，它将发出值为 nil 的 String? 类型。而 orEmpty 操作符
             可以将可选类型的 nil 解包为非可选的 String 类型，它将 nil 返回为 ""（非可选类型的空字符串）。
             */
            .orEmpty
            /**
             过滤太短的查询，只有当输入超过 3 个字时才开始查询
             如果想要过滤空字符串可以写：.filter { !$0.isEmpty }
             */
            .filter { query in
                return query.count > Constants.minimumSearchLength
            }
            /**
             debounce 去抖动操作符

             默认情况下，用户每输入一个字符都会产生一个 Observable<String> ，随后调用搜索 API，当用户快速输入时，会产生很多不必要的请求。
             为了防止用户输入太快导致的无效查询，正确的方法应该是在用户停止输入时调用搜索 API
             
             在其他示例会用这两个操作符：
             .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
             .distinctUntilChanged()
             */
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { query in
                var apiUrl = URLComponents(string: "https://api.github.com/search/repositories")!
                apiUrl.queryItems = [URLQueryItem(name: "q", value: query)]
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchAndReturn([])
            }
            .map { json -> [Repo] in
                guard let json = json as? [String: Any],
                      let items = json["items"] as? [[String: Any]] else {
                    return []
                }
                return items.compactMap(Repo.init)
            }
            /**
             将 Repo 对象列表绑定到 tableView
             */
            .bind(to: tableView.rx.items) { tableView, row, repo in
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier)!
                cell.textLabel?.text = repo.name
                cell.detailTextLabel?.text = repo.language
                return cell
            }
            .disposed(by: disposeBag)
    }
}
