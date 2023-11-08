//
//  SearchViewController4.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/16/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import ReactorKit
import Reusable
import RxDataSources
import RxSwift
import UIKit

final class SearchViewController4: UIViewController, StoryboardView, StoryboardBased {
    private typealias Action = SearchViewModel4.Action
    var disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.dimsBackgroundDuringPresentation = false
    }
    private let footerActivityIndicator = UIActivityIndicatorView(style: .gray).then {
        $0.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
    }
    // swiftlint:disable:next trailing_closure
    private let dataSource = RxTableViewSectionedReloadDataSource<SearchViewModel.SectionType>(
        configureCell: { _, tableView, indexPath, item in
            tableView.dequeueReusableCell(for: indexPath, cellType: SearchTableViewCell.self).then {
                $0.configure(item: item)
            }
        }
    )
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.do {
            $0.register(cellType: SearchTableViewCell.self)
            $0.tableFooterView = footerActivityIndicator
        }
        definesPresentationContext = true
        navigationItem.do {
            $0.searchController = searchController
            $0.hidesSearchBarWhenScrolling = false
        }
    }

    func bind(reactor: SearchViewModel4) {
        let state = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
        state.map { $0.dataSource }.distinctUntilChanged().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        state.map { $0.isLoading }.drive(footerActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
        searchController.searchBar.rx.text.orEmpty.map(Action.search).bind(to: reactor.action).disposed(by: disposeBag)
        tableView.rx.reachedBottom(offset: 100.0).mapTo(Action.reachedBottom).bind(to: reactor.action).disposed(by: disposeBag)
        tableView.rx.modelSelected(SearchTableViewCellItem.self).map(Action.selecteItem).bind(to: reactor.action).disposed(by: disposeBag)
    }
}
