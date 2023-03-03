//
//  MockJsonPlaceholderService.swift
//  ServiceLayerExampleTests
//
//  Created by Josh Rondestvedt on 12/2/21.
//

import Foundation

@testable import ServiceLayerExample

final class MockJsonPlaceholderService: JsonPlaceholderServiceProtocol {

    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        // 1 - retrieves a path to the users.json file in the Fixtures folder.
        let pathString = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        // 2 - decodes the fixtures into `User` objects.
        let users = try! JSONDecoder.userDecoder().decode([User].self, from: jsonData)
        completion(.success(users))
    }
}
