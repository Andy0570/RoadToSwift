/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Combine

/// Defines the Network service errors.
enum NetworkError: Error {
  case invalidRequest
  case invalidResponse
  case dataLoadingError(statusCode: Int, data: Data)
  case jsonDecodingError(error: Error)
  case clientError(statusCode: Int, data: Data)
  case serverError(statusCode: Int, data: Data)
}


struct NetworkService {
  func request<InputType: Decodable>(input: InputType.Type, url: URL) -> AnyPublisher<InputType, NetworkError> {
    var request = URLRequest(url: url, timeoutInterval: 60)
    request.allHTTPHeaderFields = [
      "Content-Type": "application/json",
      "cache-control": "no-cache"
    ]
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    return URLSession(configuration: config)
      .dataTaskPublisher(for: request)
      .receive(on: DispatchQueue.main)
      .tryMap { response in
        guard let statusCode = (response.response as? HTTPURLResponse)?.statusCode else {
          throw NetworkError.invalidResponse
        }
        switch statusCode {
        case 200...300:
          return response.data
        case 400...499:
          throw NetworkError.clientError(statusCode: statusCode, data: response.data)
        case 500...600:
          throw NetworkError.serverError(statusCode: statusCode, data: response.data)
        default:
          throw NetworkError.invalidRequest
        }
      }
      .decode(type: InputType.self, decoder: JSONDecoder())
      .mapError { error -> NetworkError in
        guard let result = (error as? NetworkError)  else {
          return NetworkError.jsonDecodingError(error: error)
        }
        return result
      }
      .eraseToAnyPublisher()
  }
}
