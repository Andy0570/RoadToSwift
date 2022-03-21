//
//  URLRequest.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

// 网络请求URL查询参数
typealias Parameters = [String: String]

extension URLRequest {
    // 将查询参数编码到URL中
    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }

        var encodedURLRequest = self

        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            var newURLComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newURLComponents.queryItems = queryItems
            encodedURLRequest.url = newURLComponents.url
            return encodedURLRequest
        } else {
            return self
        }
    }
}
