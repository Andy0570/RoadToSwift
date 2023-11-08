//
//  SearchViewController3Test.swift
//  RxSwiftArchitectureProgressTests
//
//  Created by Anton Nazarov on 8/16/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import Nimble
import Quick
import RxSwift
@testable import RxSwiftArchitectureProgress
import RxTest

final class SearchViewController3Test: QuickSpec {
    override func spec() {
        super.spec()

        describe("searchViewController3 memory leaks test") {
            it("should release RxSwift.Resources after deinit") {
                let expectedTotal = Resources.total
                autoreleasepool {
                    let sut = SearchViewController3.instantiate().then {
                        let searchService = SearchServiceImpl(jsonDecoder: JSONDecoder(), backgroundScheduler: MainScheduler.instance)
                        $0.viewModel = SearchViewModel3Impl(searchService: searchService)
                    }
                    _ = sut.view
                }
                expect(Resources.total).toEventually(equal(expectedTotal))
            }
        }
    }
}
