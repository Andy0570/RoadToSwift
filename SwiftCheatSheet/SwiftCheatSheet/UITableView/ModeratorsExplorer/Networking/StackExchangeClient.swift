//
//  StackExchangeClient.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

// 网络请求客户端
final class StackExchangeClient {
    private lazy var baseURL: URL = {
        guard let url = URL(string: "https://api.stackexchange.com/2.3/") else {
            fatalError("initialize baseURL error.")
        }
        return url
    }()

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchModerators(with request: ModeratorRequest, page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
        // 使用 URLRequest 初始化器构建网络请求路径，baseURL/路径
        // http://api.stackexchange.com/2.3/users/moderators
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        // 创建查询参数，分页查询参数+查询字符串和默认参数
        let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)

        session.dataTask(with: encodedURLRequest) { data, response, _ in
            // 排除网络请求状态码错误
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode, let data = data else {
                completion(Result.failure(DataResponseError.network))
                return
            }

            // 排除网络请求响应数据解码错误
            guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }

            completion(Result.success(decodedResponse))
        }
        .resume()
    }
}
