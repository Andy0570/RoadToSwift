//
//  UserViewControllerViewModelTests.swift
//  ServiceLayerExampleTests
//
//  Created by Josh Rondestvedt on 12/2/21.
//

import Foundation
import XCTest

@testable import ServiceLayerExample

class UserViewControllerViewModelTests: XCTestCase {

    var mockJsonPlaceholderServiceProtocol: JsonPlaceholderServiceProtocol!
    var subject: UserViewControllerViewModel!

    override func setUp() {
        super.setUp()

        mockJsonPlaceholderServiceProtocol = MockJsonPlaceholderService()
        subject = UserViewControllerViewModel(service: mockJsonPlaceholderServiceProtocol)
    }

    // 1 - ensures the `fetchUsers` method of the JsonPlaceholderServiceProtocol properly decodes the JSON into `User` objects.
    func testFetchUsers() {
        //method `retrieveUsers` call in the UserViewControllerViewModel's init.  This occurs in the setUp method above.
        XCTAssertEqual(subject.users.count, 10)

        //`users` array is sorted A-Z
        let firstUser = subject.users.first!
        XCTAssertEqual(firstUser.id, 5)
        XCTAssertEqual(firstUser.name, "Chelsey Dietrich")
    }
}
