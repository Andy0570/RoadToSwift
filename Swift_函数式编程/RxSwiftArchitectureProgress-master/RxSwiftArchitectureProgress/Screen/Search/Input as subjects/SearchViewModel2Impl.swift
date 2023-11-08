//
//  SearchViewModel2Impl.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/15/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxCocoa.Driver
import class RxRelay.BehaviorRelay
import RxSwift
import RxSwiftExt

final class SearchViewModel2Impl {
    private let disposeBag = DisposeBag()
    private let repositories = BehaviorRelay<[Repository]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let githubService: SearchService
    private let searchRequest = BehaviorRelay<Request>(value: Request(query: "", page: .first))

    let search = PublishSubject<String>()
    let selectItem = PublishSubject<SearchTableViewCellItem>()
    let reachedBottom = PublishSubject<Void>()

    init(searchService: SearchService) {
        self.githubService = searchService
        bindInputs()
    }
}

// MARK: - SearchViewModel
extension SearchViewModel2Impl: SearchViewModel2 {
    var dataSource: Driver<[SectionType]> {
        return self.repositories
            .map { $0.compactMap(SearchTableViewCellItem.init) }
            .map { [SectionType(model: "", items: $0)] }
            .asDriver(onErrorJustReturn: [])
    }

    var isLoading: Driver<Bool> {
        return self.isLoadingRelay.asDriver()
    }
}

// MARK: - Private
private extension SearchViewModel2Impl {
    func bindInputs() {
        selectItem.bind { UIApplication.shared.open($0.url) }.disposed(by: disposeBag)
        
        let newSearchRequests = search
            .skip(1)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchRequest) { query, _ in  Request(query: query, page: .first) } // map each new search query to new request with first page
        newSearchRequests.mapTo([]).bind(to: repositories).disposed(by: disposeBag) // clear current dataSource
        let allSearchRequests = Observable.merge(
            newSearchRequests,
            reachedBottom.withLatestFrom(searchRequest) { $1.nextPage }.share() // map reachedBottom events to new request with similar query and next page
        )
        allSearchRequests.bind(to: searchRequest).disposed(by: disposeBag) // save current request
        allSearchRequests.mapTo(true).bind(to: isLoadingRelay).disposed(by: disposeBag) // enable loading indicator before request
        let searchEvents = allSearchRequests.flatMapLatest { [githubService] in
            githubService.search(request: $0).asObservable().materialize()
        }
        .share()
        
        searchEvents.mapTo(false).bind(to: isLoadingRelay).disposed(by: disposeBag) // disabling loading indicator after request
        searchEvents.elements().withLatestFrom(repositories) { $1 + $0 }.bind(to: repositories).disposed(by: disposeBag)
        searchEvents.errors().bind { print($0) }.disposed(by: disposeBag)
    }
}
