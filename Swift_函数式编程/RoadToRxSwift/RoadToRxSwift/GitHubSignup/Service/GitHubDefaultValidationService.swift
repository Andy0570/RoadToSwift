//
//  GitHubDefaultValidationService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/25.
//

import RxSwift

/// Service 层，GitHub 输入验证服务
protocol GitHubValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

class GitHubDefaultValidationService: GitHubValidationService {
    let API: GitHubDefaultAPI

    static let sharedValidationService = GitHubDefaultValidationService(API: GitHubDefaultAPI.sharedService)

    init(API: GitHubDefaultAPI) {
        self.API = API
    }

    // 密码最少位数
    let minPasswordCount = 5

    // 验证用户名
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        // 判断用户名是否为空
        if username.isEmpty {
            return .just(.empty)
        }

        // 判断用户名是否只有数字和字母
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }

        let loadingValue = ValidationResult.validating

        // 发起网络请求，检查用户名是否已存在
        return API
            .usernameAvailable(username)
            .map { available in
                // 根据查询情况返回不同的验证结果
                if available {
                    return .ok(message: "用户名可用")
                } else {
                    return .failed(message: "用户名已存在")
                }
            }
            .startWith(loadingValue) // 在发起网络请求前，先返回一个“正在检查”的验证结果
    }

    // 验证密码
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count

        // 判断密码是否为空
        if numberOfCharacters == 0 {
            return .empty
        }

        // 判断密码位数
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要 \(minPasswordCount) 个字符")
        }

        // 返回验证成功的结果
        return .ok(message: "密码有效")
    }
    
    // 验证二次输入的密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        // 判断密码是否为空
        if repeatedPassword.count == 0 {
            return .empty
        }

        // 判断两次输入的密码是否一致
        if repeatedPassword == password {
            return .ok(message: "密码有效")
        }
        else {
            return .failed(message: "两次输入的密码不一致")
        }
    }
}
