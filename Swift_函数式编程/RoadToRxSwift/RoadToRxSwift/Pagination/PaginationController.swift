//
//  PaginationController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/1.
//

import RxSwift
import RxCocoa

/**
 在 TableView 中实现下拉刷新、上滑加载更多

 参考：[如何在 RxSwift 中使用分页](https://medium.com/@ferhanakkan/how-to-use-pagination-in-rxswift-5aaf0283792e)
 */
final class PaginationController: UIViewController {

    // MARK: - Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        return tableView
    }()

    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    // MARK: - Private
    private let viewModel = PaginationViewModel()
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        buildSubviews()
        buildLogic()

        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }

    private func buildSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func buildLogic() {
        viewModel.items.bind(to: tableView.rx.items) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
            cell?.textLabel?.text = item
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }.disposed(by: disposeBag)

        // 上滑加载更多
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height

            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)

        // 是否允许继续分页加载
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvailable in
            guard let isAvailable = isAvailable.element, let self = self else {
                return
            }

            self.tableView.tableFooterView = isAvailable ? self.viewSpinner : UIView(frame: .zero)
        }.disposed(by: disposeBag)

        // 下拉刷新完成后，结束加载
        viewModel.refreshControlCompeleted.subscribe { [weak self] _ in
            guard let self else { return }
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
    }

    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
}

extension PaginationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
