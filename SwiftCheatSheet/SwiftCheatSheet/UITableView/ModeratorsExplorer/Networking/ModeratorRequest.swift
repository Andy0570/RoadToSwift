//
//  ModeratorRequest.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

/// 获取在网站上具有审核权限的用户
struct ModeratorRequest {
    // 网络请求路径
    var path: String {
        return "users/moderators"
    }

    // 网络请求参数
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ModeratorRequest {
    // 查询字符串和默认参数
    static func from(site: String) -> ModeratorRequest {
        let defaultParameters = ["order": "desc", "sort": "reputation", "filter": "!-*jbN0CeyJHb"]
        let parameters = ["site": "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
        return ModeratorRequest(parameters: parameters)
    }
}
