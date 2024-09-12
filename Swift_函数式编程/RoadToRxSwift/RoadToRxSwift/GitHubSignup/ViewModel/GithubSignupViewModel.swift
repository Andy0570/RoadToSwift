//
//  GithubSignupViewModel.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/25.
//

import RxSwift
import RxCocoa

class GithubSignupViewModel {

    // MARK: - Output
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>

    // 注册按钮是否可用
    let signupEnabled: Driver<Bool>

    // 注册结果
    let signedIn: Driver<Bool>

    // 注册正在进行中
    let signingIn: Driver<Bool>

    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        loginTaps: Signal<()>
    ), dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: Wireframe
    )) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe

        /**
         请注意，我们并没有创建任何订阅。一切都只是定义。
         输入序列到输出序列的纯粹转换。

         当使用 `Driver` 时，底层的可观察序列是共享的，因为
         Driver 会自动在引擎盖下添加 "shareReplay(1)"。

         .observe(on:MainScheduler.instance)
         .catchAndReturn(.Failed(message: "Error contacting server"))

         ......被压缩成单一的 `.asDriver(onErrorJustReturn: .Failed(message: "服务器发生错误"))`。
         */

        // 用户名验证
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .failed(message: "服务器发生错误"))
            }

        // 密码验证
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }

        // 重复输入验证
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)

        // 用于检测是否正在请求数据
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()

        // 获取最新的用户名和密码，合并为元组类型
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (username: $0, password: $1) }

        // 注册按钮点击结果
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                    .trackActivity(signingIn) // 把当前序列放入 signing 序列中进行检测
                    .asDriver(onErrorJustReturn: false)
            }
            .flatMapLatest { loggedIn -> Driver<Bool> in
                let message = loggedIn ? "模拟: GitHub 账号注册成功" : "模拟: GitHub 账号注册失败"
                return wireframe.promptFor(message, cancelAction: "好的", actions: [])
                    .map { _ in
                        loggedIn
                    }
                    .asDriver(onErrorJustReturn: false)
            }

        // 注册按钮是否可用
        signupEnabled = Driver.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated, signingIn
        ) { username, password, repeatedPassword, signingIn in
            username.isValid &&
            password.isValid &&
            repeatedPassword.isValid &&
            !signingIn
        }.distinctUntilChanged()
    }
}
