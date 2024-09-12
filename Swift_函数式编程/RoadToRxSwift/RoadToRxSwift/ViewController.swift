//
//  ViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/15.
//

import UIKit
import RxSwift
import RxCocoa

struct DataModel {
    let className: UIViewController.Type?
    let name: String?
}

struct DataListModel {
    let data = Observable.just([
        DataModel(className: ObservableViewController.self, name: "Observable"),
        DataModel(className: TraitsViewController.self, name: "RxSwift Traits"),
        DataModel(className: SubjectViewController.self, name: "Subject"),
        DataModel(className: FilterViewController.self, name: "Filter"),
        DataModel(className: LabelViewController.self, name: "UILabel"),
        DataModel(className: CombinestagramViewController.self, name: "Combinestagram"),
        DataModel(className: AttentionViewController.self, name: "MVVM 示例:关注/取消"),
        DataModel(className: SearchGitHubViewController.self, name: "Search GitHub"),
        DataModel(className: SpotifySearchViewController.self, name: "Spotify 曲目搜索"),
        DataModel(className: ChocolatesOfTheWorldViewController.self, name: "Chocotastic🍫"),
        DataModel(className: LoginViewController.self, name: "MVVM 实现的登录页面"),
        DataModel(className: GitHubSignupViewController.self, name: "MVVM 实现的 GitHub 注册页面"),
        DataModel(className: CurrencyViewController.self, name: "货币转换"),
        DataModel(className: PaginationController.self, name: "分页加载")
    ])
}

final class ViewController: UIViewController {
    private enum Constants {
        static let rowHeight: CGFloat = 55
        static let cellIdentifier = "Cell"
    }

    // MARK: - Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Constants.rowHeight
        return tableView
    }()

    // MARK: - Private
    private let dataList = DataListModel()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        buildViewModel()
    }

    private func makeUI() {
        title = "Home"
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func buildViewModel() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)

        // 将数据源绑定到 tableView 上
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: Constants.cellIdentifier)) { _, model, cell in
            cell.textLabel?.text = model.name
        }.disposed(by: disposeBag)

        // tableView 点击响应
        tableView.rx.modelSelected(DataModel.self).subscribe(onNext: { [weak self] element in
            if element.className == LoginViewController.self {
                // 遵守 MVVM 架构的登录页面，通过依赖注入的方式创建 ViewModel
                let loginService = LoginService()
                let loginControllerViewModel = LoginControllerViewModel(loginService)
                let loginVC = LoginViewController.create(with: loginControllerViewModel)
                self?.navigationController?.pushViewController(loginVC, animated: true)
            } else if let className = element.className {
                let vc = className.init()
                self?.navigationController?.pushViewController(vc, animated: true)
            }

            // 取消 cell 选中状态
            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

