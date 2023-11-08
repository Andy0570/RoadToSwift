//
//  SearchViewController2Test.swift
//  RxSwiftArchitectureProgressTests
//
//  Created by Anton Nazarov on 8/15/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import Nimble
import Quick
import RxSwift
@testable import RxSwiftArchitectureProgress
import RxTest

final class SearchViewController2Test: QuickSpec {
    override func spec() {
        super.spec()

        describe("searchViewController2 memory leaks test") {
            it("should release RxSwift.Resources after deinit") {
                let expectedTotal = Resources.total
                autoreleasepool {
                    let sut = SearchViewController2.instantiate().then {
                        let searchService = SearchServiceImpl(jsonDecoder: JSONDecoder(), backgroundScheduler: MainScheduler.instance)
                        $0.viewModel = SearchViewModel2Impl(searchService: searchService)
                    }
                    _ = sut.view
                }
                expect(Resources.total).toEventually(equal(expectedTotal))
            }
        }
    }
}
