//
//  SearchViewModel4.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/16/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct Differentiator.SectionModel
import ReactorKit
import RxSwift

final class SearchViewModel4: Reactor {
    typealias SectionType = SectionModel<String, SearchTableViewCellItem>

    enum Action: Equatable {
        case search(String)
        case selecteItem(SearchTableViewCellItem)
        case reachedBottom
    }

    enum Mutation {
        case itemsLoaded([Repository])
        case itemsAppended([Repository])
        case toggleLoading(Bool)
        case errorOccurred(String)
        case requestUpdated(Request)
    }

    struct State {
        var searchRequest = Request(query: "", page: .first)
        var isLoading = false
        var repositories = [Repository]()
    }

    var initialState = State()
    private let searchService: SearchService

    init(searchService: SearchService) {
        self.searchService = searchService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selecteItem(item):
            UIApplication.shared.open(item.url)
            return .empty()
        case .reachedBottom:
            let newRequest = currentState.searchRequest.nextPage
            let searchEvents = searchService.search(request: newRequest).asObservable().materialize().share()
            let searchMutations = Observable.merge(
                .concat(searchEvents.elements().map(Mutation.itemsAppended), .just(.requestUpdated(newRequest))),
                searchEvents.errors().map { $0.localizedDescription }.map(Mutation.errorOccurred)
            )
            return .concat(
                .just(.toggleLoading(true)),
                searchMutations,
                .just(.toggleLoading(false))
            )
        case let .search(query):
            let newRequest = Request(query: query, page: .first)
            let searchEvents = searchService.search(request: newRequest).asObservable().materialize().share()
            let searchMutations = Observable.merge(
                .concat(searchEvents.elements().map(Mutation.itemsLoaded), .just(.requestUpdated(newRequest))),
                searchEvents.errors().map { $0.localizedDescription }.map(Mutation.errorOccurred)
            )
            return .concat(
                .just(.itemsLoaded([])),
                .just(.toggleLoading(true)),
                searchMutations,
                .just(.toggleLoading(false))
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .errorOccurred(message):
            print(message)
        case let .itemsAppended(newItems):
            newState.repositories += newItems
        case let .itemsLoaded(items):
            newState.repositories = items
        case let .toggleLoading(isLoading):
            newState.isLoading = isLoading
        case let .requestUpdated(request):
            newState.searchRequest = request
        }
        return newState
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let searchActions = action.partition {
            if case .search = $0 {
                return true
            }
            return false
        }
        let filteredSearchActions = searchActions.matches
            .skip(1)
            .filter {
                guard case let .search(query) = $0 else {
                    return false
                }
                return !query.isEmpty
            }
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
        return Observable.merge(searchActions.nonMatches, filteredSearchActions).debug("PENIS")
    }
}

// MARK: - State
extension SearchViewModel4.State {
    var dataSource: [SearchViewModel4.SectionType] {
        return [SearchViewModel4.SectionType(model: "", items: repositories.compactMap(SearchTableViewCellItem.init))]
    }
}
