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

import Foundation
import Alamofire

// 使用 Alamofire 从 GitHub 获取存储库和 Commit 信息
class GitAPIManager {
  static let shared = GitAPIManager()

  let sessingManager: Session = {
    // 自定义 Session 配置
    let configuration = URLSessionConfiguration.af.default
    // configuration.timeoutIntervalForRequest = 30 // 默认请求超时时间为 60s
    // configuration.waitsForConnectivity = true // 等待网络连接
    // 缓存策略
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    let responseCacher = ResponseCacher(behavior: .modify({ _, response in
      let userInfo = ["date": Date()] // 将响应日期缓存到 userInfo 字典中
      return CachedURLResponse(
        response: response.response,
        data: response.data,
        userInfo: userInfo,
        storagePolicy: .allowed)
    }))

    // 添加自定义网络事件监视器，记录请求和响应日志
    let networkLogger = GitNetworkLogger()
    // 添加自定义网络请求拦截器，在请求中添加 Authorization 授权头信息
    let interceptor = GitRequestInterceptor()

    return Session(
      configuration: configuration,
      interceptor: interceptor,
      cachedResponseHandler: responseCacher,
      eventMonitors: [networkLogger]
    )
  }()

  // 搜索 GitHub 存储库，指定 Swift 语言
  func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
    searchRepositories(query: "language:Swift", completion: completion)
  }

  // 获取指定存储库的 commit 提交信息
  func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
    sessingManager.request(GitRouter.fetchCommits(repository))
      .responseDecodable(of: [Commit].self) { response in
        guard let commits = response.value else {
          return
        }
        completion(commits)
      }
  }

  // 搜索 GitHub 存储库
  func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
    sessingManager.request(GitRouter.searchRepositories(query))
      .responseDecodable(of: Repositories.self) { response in
        guard let items = response.value else {
          return completion([])
        }
        completion(items.items)
      }
  }

  /**
   获取 GitHub AccessToken

   POST https://github.com/login/oauth/access_token (200)
   {
       "access_token" = "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";
       scope = "repo,user";
       "token_type" = bearer;
   }
   */
  func fetchAccessToken(accessCode: String, completion: @escaping (Bool) -> Void) {
    sessingManager.request(GitRouter.fetchAccessToken(accessCode))
      .responseDecodable(of: GitHubAccessToken.self) { response in
        guard let cred = response.value else {
          return completion(false)
        }
        TokenManager.shared.saveAccessToken(gitToken: cred)
        completion(true)
    }
  }

  // 获取用户存储库
  func fetchUserRepositories(completion: @escaping ([Repository]) -> Void) {
    sessingManager.request(GitRouter.fetchUserRepositories).responseDecodable(of: [Repository].self) { response in
      guard let items = response.value else {
        return completion([])
      }
      completion(items)
    }
  }

}
