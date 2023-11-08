//
//  SearchViewModelImpl.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxCocoa.Driver
import class RxRelay.BehaviorRelay
import class RxSwift.DisposeBag
import RxSwiftExt

final class SearchViewModelImpl {
    private let disposeBag = DisposeBag()
    private let repositories = BehaviorRelay<[Repository]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let githubService: SearchService
    private var searchRequest = Request(query: "", page: .first)

    init(searchService: SearchService) {
        self.githubService = searchService
    }
}

// MARK: - SearchViewModel
extension SearchViewModelImpl: SearchViewModel {
    var dataSource: Driver<[SectionType]> {
        return self.repositories
            .map { $0.compactMap(SearchTableViewCellItem.init) }
            .map { [SectionType(model: "", items: $0)] }
            .asDriver(onErrorJustReturn: [])
    }

    var isLoading: Driver<Bool> {
        return self.isLoadingRelay.asDriver()
    }

    func search(query: String) {
        repositories.accept([])
        searchRequest = Request(query: query, page: .first)
        search(request: searchRequest)
    }

    func reachedBottom() {
        guard !isLoadingRelay.value else { return }
        searchRequest = searchRequest.nextPage
        search(request: searchRequest)
    }

    func selectItem(_ item: SearchTableViewCellItem) {
        UIApplication.shared.open(item.url)
    }
}

// MARK: - Private
private extension SearchViewModelImpl {
    func search(request: Request) {
        isLoadingRelay.accept(true)
        let searchEvents = githubService
            .search(request: request)
            .asObservable()
            .materialize()
            .doNext { [unowned self] _ in self.isLoadingRelay.accept(false) }
            .share()
        searchEvents.elements().withLatestFrom(repositories) { $1 + $0 }.bind(to: repositories).disposed(by: disposeBag)
        searchEvents.errors().bind { print($0) }.disposed(by: disposeBag)
    }
}
