/// Copyright (c) 2020 Razeware LLC
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

import UIKit
import Alamofire

/// 路由设计模式，将网络请求 baseURL、path、method、parameters 等请求参数封装在这里！
enum GitRouter {
  case fetchUserRepositories
  case searchRepositories(String)
  case fetchCommits(String)
  case fetchAccessToken(String)

  var baseURL: String {
    switch self {
    case .fetchUserRepositories, .searchRepositories, .fetchCommits:
      return "https://api.github.com"
    case .fetchAccessToken:
      return "https://github.com"
    }
  }

  var path: String {
    switch self {
    case .fetchUserRepositories:
      return "/user/repos"
    case .searchRepositories:
      return "/search/repositories"
    case .fetchCommits(let repository):
      return "/repos/\(repository)/commits"
    case .fetchAccessToken:
      return "/login/oauth/access_token"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .fetchUserRepositories:
      return .get
    case .searchRepositories:
      return .get
    case .fetchCommits:
      return .get
    case .fetchAccessToken:
      return .post
    }
  }

  var parameters: [String: String]? {
    switch self {
    case .fetchUserRepositories:
      return ["per_page": "100"] // 分页查询参数
    case .searchRepositories(let query):
      return ["sort": "stars", "order": "desc", "page": "1", "q": query]
    case .fetchCommits:
      return nil
    case .fetchAccessToken(let accessCode):
      return [
        "client_id": GitHubConstants.clientID,
        "client_secret": GitHubConstants.clientSecret,
        "code": accessCode
      ]
    }
  }
}

extension GitRouter: URLRequestConvertible {
  // 遵守 URLRequestConvertible 协议需要实现 asURLRequest() 方法
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = try URLRequest(url: url, method: method)

    // 根据 HTTP 方法对参数进行编码
    if method == .get {
      request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
    } else if method == .post {
      request = try JSONParameterEncoder().encode(parameters, into: request)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    return request
  }
}
