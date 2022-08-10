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
