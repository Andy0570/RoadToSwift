//
//  AuthPlugin.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/10/18.
//

/// JWT 授权插件
/// 参考：<https://github.com/Moya/Moya/blob/master/docs_CN/Examples/AuthPlugin.md>
//import Moya
//
//public struct AuthPlugin: PluginType {
//    private var token: String {
//        // 从偏好设置中获取令牌
//        if let token = UserDefaults.standard.string(forKey: "Access_Token") {
//            return token
//        } else {
//            // 否则返回默认值
//            let defaultToken = SeaTaoKeys().seaTaoAccessToken
//            return defaultToken
//        }
//    }
//
//    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        var request = request
//        request.addValue(token, forHTTPHeaderField: "Authorization")
//        return request
//    }
//}
