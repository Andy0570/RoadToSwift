import Foundation
import Alamofire

// 使用 Alamofire 从 GitHub 获取存储库和 Commit 信息
final class GitAPIManager {
    static let shared = GitAPIManager()
    private init() {} // 这样可以防止其他对象使用这个类的默认 '()' 初始化器。

    let sessingManager: Session = {
        // 自定义 Session 配置
        let configuration = URLSessionConfiguration.af.default
        // configuration.timeoutIntervalForRequest = 30 // 默认请求超时时间为 60s
        // configuration.waitsForConnectivity = true // 等待网络连接

        // 自定义缓存策略
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify({ _, response in
            let userInfo = ["date": Date()] // 将响应日期缓存到 userInfo 字典中
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        }))

        // 添加自定义网络请求拦截器，在请求中添加 Authorization 授权头信息，在响应失败时自动重试
        let interceptor = GitRequestInterceptor()
        // 添加自定义网络事件监视器，记录请求和响应日志
        let networkLogger = GitNetworkLogger()

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
     "access_token" = "";
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
