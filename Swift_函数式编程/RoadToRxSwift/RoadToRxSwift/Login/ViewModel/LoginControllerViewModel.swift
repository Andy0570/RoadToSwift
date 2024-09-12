//
//  LoginControllerViewModel.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import RxSwift

class LoginControllerViewModel: ViewModelProtocol {
    struct Input {
        let email: AnyObserver<String> // 电子邮箱
        let password: AnyObserver<String> // 密码
        let signInDidTap: AnyObserver<Void> // 登录按钮点击
    }
    struct Output {
        // !!!: 优化点，输出类型设置为 Driver 特征序列更好（不会产生 error、主线程监听、共享可观察序列）
        let loginResultObservable: Observable<User> // 登录结果（User 实例类型）
        let errorsObservable: Observable<Error> // 可能的错误
    }

    // MARK: - Public
    let input: Input
    let output: Output

    // MARK: - Private
    private let emailSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    private let signInDidTapSubject = PublishSubject<Void>()
    
    private let loginResultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()

    private var credentialsObservable: Observable<Credentials> {
        return Observable.combineLatest(emailSubject.asObservable(), passwordSubject.asObservable()) { (email, password) in
            return Credentials(email: email, password: password)
        }
    }

    // MARK: - Init and deinit
    init(_ loginService: LoginServiceProtocol) {
        
        input = Input(email: emailSubject.asObserver(),
                      password: passwordSubject.asObserver(),
                      signInDidTap: signInDidTapSubject.asObserver())

        output = Output(loginResultObservable: loginResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())

        signInDidTapSubject
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                return loginService.signIn(with: credentials)
            }
            .subscribe { [unowned self] user in
                self.loginResultSubject.onNext(user)
            } onError: { [unowned self] error in
                self.errorsSubject.onNext(error)
            }
            .disposed(by: disposeBag)
    }

    deinit {
        print("\(self) dealloc")
    }
}
