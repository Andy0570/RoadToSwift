//
//  GitHubSignupViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

/**
 MVVM 实现的 GitHub 注册页面

 参考：
 * <https://www.hangge.com/blog/cache/detail_2029.html>
 * <https://www.hangge.com/blog/cache/detail_2030.html>
 */
class GitHubSignupViewController: UIViewController {

    // MARK: - Controls
    private var usernameTextField: UITextField!
    private var usernameValidationLabel: UILabel!

    private var passwordTextField: UITextField!
    private var passwordValidationLabel: UILabel!

    private var repeatedPasswordTextField: UITextField!
    private var repeatedPasswordValidationLabel: UILabel!

    private var signupButton: UIButton!
    private var signingUpIndicator: UIActivityIndicatorView!

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bindViewModel()
    }

    private func bindViewModel() {
        
        // 初始化 ViewModel
        let viewModel = GithubSignupViewModel(
            input: (
                username: usernameTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver(),
                loginTaps: signupButton.rx.tap.asSignal()
            ),
            dependency: (
                API: GitHubDefaultAPI.sharedService,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            ))

        // 用户名验证结果绑定
        viewModel.validatedUsername
            .drive(usernameValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)

        // 密码验证结果绑定
        viewModel.validatedPassword
            .drive(passwordValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)

        // 再次输入密码验证结果绑定
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)

        // 注册按钮是否可用
        viewModel.signupEnabled
            .drive(signupButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // 创建一个活动指示器
        let hud = MBProgressHUD.showAdded(to: view, animated: true)

        // 是否正在注册中
        viewModel.signingIn
            .drive(
                signingUpIndicator.rx.isAnimating,
                UIApplication.shared.rx.isNetworkActivityIndicatorVisible,
                hud.rx.isHidden
            )
            .disposed(by: disposeBag)

        // 注册结果绑定
        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("用户注册：\(signedIn)")
            })
            .disposed(by: disposeBag)

        // 点击空白区域，收起键盘
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
}

extension GitHubSignupViewController {
    private func makeUI() {
        view.backgroundColor = .white

        // usernameTextField
        usernameTextField = UITextField.makeTextField(titleFont: .systemFont(ofSize: 14))
        usernameTextField.placeholder = "用户名"
        view.addSubview(usernameTextField)

        // usernameLabel
        usernameValidationLabel = UILabel(frame: .zero)
        usernameValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameValidationLabel)

        // passwordTextField
        passwordTextField = UITextField.makeTextField(titleFont: .systemFont(ofSize: 14))
        passwordTextField.placeholder = "密码"
        passwordTextField.textType = .password
        view.addSubview(passwordTextField)

        // passwordLabel
        passwordValidationLabel = UILabel(frame: .zero)
        passwordValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordValidationLabel)

        // repeatedPasswordTextField
        repeatedPasswordTextField = UITextField.makeTextField(titleFont: .systemFont(ofSize: 14))
        repeatedPasswordTextField.placeholder = "再次输入密码"
        repeatedPasswordTextField.textType = .password
        view.addSubview(repeatedPasswordTextField)

        // repeatedPassworLabel
        repeatedPasswordValidationLabel = UILabel(frame: .zero)
        repeatedPasswordValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repeatedPasswordValidationLabel)

        // signupButton
        signupButton = UIButton.makeSubmitButton(title: "注册")
        view.addSubview(signupButton)

        // signingUpIndicator
        signingUpIndicator = UIActivityIndicatorView(frame: .zero)
        signingUpIndicator.translatesAutoresizingMaskIntoConstraints = false
        signingUpIndicator.style = .medium
        signingUpIndicator.hidesWhenStopped = true
        view.addSubview(signingUpIndicator)

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            usernameTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            usernameValidationLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 5),
            usernameValidationLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            usernameValidationLabel.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            passwordTextField.topAnchor.constraint(equalTo: usernameValidationLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordValidationLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            passwordValidationLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordValidationLabel.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            repeatedPasswordTextField.topAnchor.constraint(equalTo: passwordValidationLabel.bottomAnchor, constant: 8),
            repeatedPasswordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            repeatedPasswordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            repeatedPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
            repeatedPasswordValidationLabel.topAnchor.constraint(equalTo: repeatedPasswordTextField.bottomAnchor, constant: 5),
            repeatedPasswordValidationLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            repeatedPasswordValidationLabel.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            signupButton.topAnchor.constraint(equalTo: repeatedPasswordValidationLabel.bottomAnchor, constant: 34),
            signupButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 44),

            signingUpIndicator.leadingAnchor.constraint(equalTo: signupButton.leadingAnchor, constant: 32),
            signingUpIndicator.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor)
        ])
    }
}
