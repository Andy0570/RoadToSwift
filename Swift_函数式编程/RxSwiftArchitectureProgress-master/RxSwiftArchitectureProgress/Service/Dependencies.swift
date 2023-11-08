//
//  Dependencies.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import class Foundation.JSONDecoder
import class RxSwift.SerialDispatchQueueScheduler

/// There is no place for production-like DI in this example, sorry
enum Dependencies {
    static let jsonDecoder = JSONDecoder().then {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    static let backgroundScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    static let githubService = SearchServiceImpl(jsonDecoder: jsonDecoder, backgroundScheduler: Dependencies.backgroundScheduler)
    static let searchViewModel = SearchViewModelImpl(searchService: githubService)
    static let searchViewModel2 = SearchViewModel2Impl(searchService: githubService)
    static let searchViewModel3 = SearchViewModel3Impl(searchService: githubService)
    static let searchViewModel4 = SearchViewModel4(searchService: githubService)
}
