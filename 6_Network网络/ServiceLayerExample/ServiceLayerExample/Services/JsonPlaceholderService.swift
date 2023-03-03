//
//  JsonPlaceholderService.swift
//  ServiceLayerExample
//
//  Created by Josh Rondestvedt on 12/1/21.
//

import Foundation

// 1 - This will be the type that is passed into the `UserViewControllerViewModel`.
// This will also be used to "mock" the service.
protocol JsonPlaceholderServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

// 2 - A concrete implementation of the JsonPlaceholder service.
final class JsonPlaceholderService: JsonPlaceholderServiceProtocol {

    // MARK: Types

    enum Endpoint: String {
        case users = "/users"
    }

    // MARK: Properties

    private let baseUrlString = "https://jsonplaceholder.typicode.com"

    private let urlSession: URLSession

    // MARK: Initialization

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: Methods

    // 3 - this method will retrieve the user objects from the /users endpoint.
    // This method will be mocked.
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: baseUrlString + Endpoint.users.rawValue) else { return }

        urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            do {
                let users = try JSONDecoder.userDecoder().decode([User].self, from: data!)
                completion(.success(users))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
}

extension JSONDecoder {
    static func userDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}
