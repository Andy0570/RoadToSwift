//
//  RequestService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation

final class RequestService {

    // todo add model
    func loadData(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }

        var request = RequestFactory.request(method: .GET, url: url)

        if let rechability = Reachability(), !rechability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }

            if let data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}
