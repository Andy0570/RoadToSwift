//
//  SearchViewController4Test.swift
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

final class SearchViewController4Test: QuickSpec {
    override func spec() {
        super.spec()

        describe("searchViewController4 memory leaks test") {
            it("should release RxSwift.Resources after deinit") {
                let expectedTotal = Resources.total
                autoreleasepool {
                    let sut = SearchViewController4.instantiate().then {
                        let searchService = SearchServiceImpl(jsonDecoder: JSONDecoder(), backgroundScheduler: MainScheduler.instance)
                        $0.reactor = SearchViewModel4(searchService: searchService)
                    }
                    _ = sut.view
                }
                expect(Resources.total).toEventually(equal(expectedTotal))
            }
        }
    }
}
