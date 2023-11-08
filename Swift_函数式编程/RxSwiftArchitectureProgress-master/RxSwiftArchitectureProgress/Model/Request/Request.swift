//
//  Request.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import Foundation

struct Request {
    let query: String
    let page: Page

    private let defaultParameters: [URLQueryItem] = [
        .init(name: "sort", value: "forks"),
        .init(name: "order", value: "desc")
    ]
}

extension Request {
    var url: URL {
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
        urlComponents?.queryItems = defaultParameters + [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page", value: "\(page.page)")]
        guard let url = urlComponents?.url else { fatalError("Invalid URL init") }
        return url
    }

    var nextPage: Request {
        return Request(query: query, page: page.next)
    }
}
