//
//  SearchViewController3.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/15/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

/**
 本文参考：<https://scal.io/blog/simplifying-rxswift-code>
 */
import class RxDataSources.RxTableViewSectionedReloadDataSource
import protocol Reusable.StoryboardBased
import RxSwift
import UIKit

final class SearchViewController3: UIViewController, StoryboardBased {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: SearchViewModel3!
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.dimsBackgroundDuringPresentation = false
    }
    private let footerActivityIndicator = UIActivityIndicatorView(style: .gray).then {
        $0.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
    }
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
        bindInput()
        bindOutput()
    }
}

// MARK: - Bind
private extension SearchViewController3 {
    func bindInput() {
        // swiftlint:disable:next trailing_closure
        let dataSource = RxTableViewSectionedReloadDataSource<SearchViewModel.SectionType>(
            configureCell: { _, tableView, indexPath, item in
                tableView.dequeueReusableCell(for: indexPath, cellType: SearchTableViewCell.self).then {
                    $0.configure(item: item)
                }
            }
        )
        viewModel.dataSource.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.isLoading.drive(footerActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
    }

    func bindOutput() {
        searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.search).disposed(by: disposeBag)
        tableView.rx.reachedBottom(offset: 100.0).bind(to: viewModel.reachedBottom).disposed(by: disposeBag)
        tableView.rx.modelSelected(SearchTableViewCellItem.self).bind(to: viewModel.selectItem).disposed(by: disposeBag)
    }
}
