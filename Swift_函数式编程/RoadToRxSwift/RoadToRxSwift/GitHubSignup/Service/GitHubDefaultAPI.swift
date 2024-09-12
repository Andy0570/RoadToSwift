//
//  GitHubDefaultAPI.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import RxSwift

/// Service 层，GitHub 网络服务
protocol GitHubAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String, password: String) -> Observable<Bool>
}

class GitHubDefaultAPI: GitHubAPI {
    let URLSession: Foundation.URLSession

    static let sharedService = GitHubDefaultAPI(URLSession: Foundation.URLSession.shared)

    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }

    // 验证用户名是否存在
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        // 通过检查这个用户的 GitHub 主页是否存在来判断用户是否存在
        let url = URL(string: "https://github.com/\(username.urlEncoded)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request)
            .map { pair in
                // 如果不存在该用户主页，则说明这个用户名可用
                return pair.response.statusCode == 404
            }
            .catchAndReturn(false)
    }

    // 注册用户
    func signup(_ username: String, password: String) -> Observable<Bool> {
        // 这里我们没有真正去发起请求，而是模拟这个操作（平均每3次有1次失败）
        let signupResult = arc4random() % 3 == 0 ? false : true
        return Observable.just(signupResult)
            .delay(.milliseconds(1500), scheduler: MainScheduler.instance) // 结果延迟 1.5 秒返回
    }
}
