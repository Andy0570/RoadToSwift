//
//  APIService.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ success: Bool, _ photos: [Photo], _ error: APIError? ) -> Void)
}

class APIService: APIServiceProtocol {
    // 模拟耗时操作
    func fetchPopularPhoto(complete: @escaping (Bool, [Photo], APIError?) -> Void) {
        DispatchQueue.global().async {
            sleep(3)
            // 加载Bundle包中的 content.json 文件，并使用 Codable 解析为模型
            guard let url = Bundle.main.url(forResource: "Content", withExtension: "json") else {
                complete(false, [], nil)
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let photos = try decoder.decode(Photos.self, from: data)
                complete(true, photos.photos, nil)
            } catch {
                fatalError("Error occured during parsing, \(error)")
            }
        }
    }
}
