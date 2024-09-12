//
//  SpotifySearchViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/23.
//

import UIKit

import SwiftyJSON
import RxSwift
import RxCocoa

/**
 Spotify 曲目搜索示例

 参考：<https://juejin.cn/post/7346417351456489499>
 */
final class SpotifySearchViewController: UIViewController {
    fileprivate enum Constants {
        static let rowHeight: CGFloat = 55
        static let minimumSearchLength = 3
    }

    private let spotifyClient = SpotifyClient()
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Controls
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.rowHeight = Constants.rowHeight
        return tableView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify 曲目搜索"
        view.backgroundColor = UIColor.systemBackground
        setupTableView()
        setupCancelSearchButton()
        bindTracksWithTableView()
    }

    // MARK: - Private

    private func setupTableView() {
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.identifier)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            self?.tableView.deselectRow(at: index, animated: true)
        }).disposed(by: disposeBag)
    }

    private func setupCancelSearchButton() {
        let shouldShowCancelButton = Observable.of(
            searchBar.rx.textDidBeginEditing.map { return true },
            searchBar.rx.textDidEndEditing.map { return false })
            .merge()

        shouldShowCancelButton.subscribe(onNext: { [weak self] shouldShow in
            self?.searchBar.showsCancelButton = shouldShow
        }).disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
    }

    private func bindTracksWithTableView() {
        tracks.bind(to: tableView.rx.items(cellIdentifier: TrackCell.identifier, cellType: TrackCell.self)) { index, track, cell in
            cell.render(trackRenderable: track)
        }.disposed(by: disposeBag)
    }

    // 查询至少包含3个字母才能进行搜索
    private func filterQuery(containsLessCharactersThan minimumCharacters: Int) -> (String) -> Bool {
        return { query in
            return query.count >= minimumCharacters
        }
    }

    private lazy var isRefreshing: Observable<Bool> = {
        return refreshControl.rx.controlEvent(.valueChanged).map { [weak self] in
            return self?.refreshControl.isRefreshing ?? false
        }
    }()

    private lazy var searchText: Observable<String> = {
        return self.searchBar.rx.text.orEmpty.asObservable()
            .skip(1) // 忽略第一个默认发送的空字符串
    }()

    // 当用户更改查询时，清除之前的搜索结果
    private var clearPreviousTracksOnTextChanged: Observable<[TrackRenderable]> {
        return self.searchText.filter(self.filterQuery(containsLessCharactersThan: Constants.minimumSearchLength)).map { _ in
            return [TrackRenderable]()
        }
    }

    private lazy var query: Observable<String> = {
        // debounce() 操作符
        // 如果 textField 的内容在 0.3 秒内发生变化，则这些信号不会到达订阅者，因此不会调用搜索方法。
        // 只有当用户在 0.3 秒后停止输入，订阅者才会收到信号并调用搜索方法。
        return self.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .filter(self.filterQuery(containsLessCharactersThan: Constants.minimumSearchLength))
    }()

    private var tracksFromSpotify: Observable<[TrackRenderable]> {
        // 下拉刷新：当用户滑动 tableView 时，从 searchBar 中获取当前文本并执行搜索
        let refreshLastQueryOnPullToRefresh = isRefreshing.filter {  $0 == true }
            .withLatestFrom(query)

        return Observable.of(query, refreshLastQueryOnPullToRefresh).merge()
            .startWith("Let it go - frozen") // 在开始时预载 "Let it go - frozen" 作为特色查询
            .flatMapLatest { [spotifyClient] query in // 当新的网络请求开始时，取消之前的任何网络请求
                return spotifyClient.rx.search(query: query)
                    .map { return $0.map(TrackRenderable.init) }
            }
    }

    var tracks: Observable<[TrackRenderable]> {
        return Observable.of(tracksFromSpotify.do(onNext: { [refreshControl] _ in refreshControl.endRefreshing() }),
                             clearPreviousTracksOnTextChanged).merge()
    }
}
