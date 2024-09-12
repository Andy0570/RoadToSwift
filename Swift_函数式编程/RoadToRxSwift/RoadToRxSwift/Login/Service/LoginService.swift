//
//  LoginService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import RxSwift

protocol LoginServiceProtocol {
    func signIn(with credentials: Credentials) -> Observable<User>
}

class LoginService: LoginServiceProtocol {
    func signIn(with credentials: Credentials) -> Observable<User> {
        return Observable.create { observer in
            /**
             Networking logic here
             */
            observer.onNext(User()) // 模拟用户认证成功
            return Disposables.create()
        }
    }
}
