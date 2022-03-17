//
//  NetworkingService.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

class NetworkingService {
    // Reference: <https://xeno-canto.org/article/153>
    let endpoint = "https://www.xeno-canto.org/api/2/recordings"
    var task: URLSessionTask?

    func fetchRecordings(matching query: String?, page: Int, onCompletion: @escaping (RecordingsResult) -> Void) {
        // 触发错误的回调闭包
        func fireErrorCompletion(_ error: Error?) {
            onCompletion(RecordingsResult(recordings: nil, error: error, currentPage: 0, pageCount: 0))
        }

        var queryOrEmpty = "since:1970-01-02"
        if let query = query, !query.isEmpty {
            queryOrEmpty = query
        }

        var components = URLComponents(string: endpoint)
        components?.queryItems = [
            URLQueryItem(name: "query", value: queryOrEmpty),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let url = components?.url else {
            fireErrorCompletion(NetworkError.invalidURL)
            return
        }

        task?.cancel()
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    // 排除例外错误：网络请求主动取消
                    guard (error as NSError).code != NSURLErrorCancelled else {
                        return
                    }
                    fireErrorCompletion(error)
                    return
                }

                guard let data = data else {
                    fireErrorCompletion(error)
                    return
                }

                do {
                    let result = try JSONDecoder().decode(ServiceResponse.self, from: data)

                    // For demo purposes, only return 50 at a time
                    // This makes it easier to reach the bottom of the results
                    let first50 = result.recordings.prefix(50)

                    onCompletion(RecordingsResult(recordings: Array(first50), error: nil, currentPage: result.page, pageCount: result.numPages))
                } catch {
                    fireErrorCompletion(error)
                }
            }
        })
        task?.resume()
    }
}
