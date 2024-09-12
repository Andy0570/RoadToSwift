//
//  LoginViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa

/**
 ⭐️⭐️⭐️
 MVVM 实现的登录页面

 参考 <https://medium.com/@caesarus1993/login-screen-implementation-using-mvvm-rxswift-efe832c687fa>
 */
class LoginViewController: UIViewController, ControllerType {
    typealias ViewModelType = LoginControllerViewModel

    // MARK: - Controls
    // 使用 private 类型的 IBOutlet 以优化并减少 Xcode 编译时间
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!

    // MARK: - Properties
    var viewModel: ViewModelType!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(with: viewModel)
    }

    // MARK: - Functions
    func configure(with viewModel: ViewModelType) {
        emailTextfield.rx.text.orEmpty
            .filter { !$0.isEmpty } // 过滤空值
            .asObservable()
            .subscribe(viewModel.input.email)
            .disposed(by: disposeBag)

        passwordTextfield.rx.text.orEmpty
            .filter { !$0.isEmpty } // 过滤空值
            .asObservable()
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)

        signInButton.rx.tap.asObservable()
            .subscribe(viewModel.input.signInDidTap)
            .disposed(by: disposeBag)

        viewModel.output.errorsObservable
            .subscribe(onNext: { [unowned self] error in
                alert(title: "Error", message: error.localizedDescription).subscribe().disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        viewModel.output.loginResultObservable
            .subscribe(onNext: { [unowned self] user in
                alert(title: "Success", message: "user").subscribe().disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    static func create(with viewModel: ViewModelType) -> UIViewController {
        let controller = LoginViewController()
        controller.viewModel = viewModel
        return controller
    }
}
