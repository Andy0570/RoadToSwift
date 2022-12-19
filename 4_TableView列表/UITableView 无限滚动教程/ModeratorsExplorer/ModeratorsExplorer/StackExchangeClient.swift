/// Copyright (c) 2018 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

final class StackExchangeClient {
  private lazy var baseURL: URL = {
    return URL(string: "http://api.stackexchange.com/2.3/")!
  }()
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func fetchModerators(with request: ModeratorRequest, page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
    // 使用 URLRequest 初始化器构建网络请求路径
    // http://api.stackexchange.com/2.2/users/moderators
    let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
    // 创建查询参数
    let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
    // 对 URL 进行编码
    // <http://api.stackexchange.com/2.2/users/moderators?site=stackoverflow&page=1&filter=!-*jbN0CeyJHb&sort=reputation&order=desc>
    let encodedURLRequest = urlRequest.encode(with: parameters)

    session.dataTask(with: encodedURLRequest) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode, let data = data else {
        completion(Result.failure(DataResponseError.network))
        return
      }

      guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
        completion(Result.failure(DataResponseError.decoding))
        return
      }

      completion(Result.success(decodedResponse))
    }.resume()
  }
}
