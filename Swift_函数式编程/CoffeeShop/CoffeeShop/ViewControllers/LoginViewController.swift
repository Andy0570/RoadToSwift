//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var logInButton: UIButton!

    private let disposeBag = DisposeBag()
    private let throttleInterval = 0.1 // 节流时间间隔，0.1 秒

    override func viewDidLoad() {
        super.viewDidLoad()

        let emailValid = emailTextfield.rx.text.orEmpty
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map { self.validateEmail(with: $0) }
            .debug("emailValid", trimOutput: true)
            .share(replay: 1)

        let passwordValid = passwordTextfield.rx.text.orEmpty
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map { $0.count >= 6 }
            .debug("passwordValid", trimOutput: true)
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .debug("everythingValid", trimOutput: true)
            .share(replay: 1)

        everythingValid.bind(to: logInButton.rx.isEnabled).disposed(by: disposeBag)
    }

    private func validateEmail(with email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)

        return predicate.evaluate(with: email)
    }

    @IBAction private func logInButtonPressed() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateInitialViewController()!

        UIApplication.changeRoot(with: initialViewController)
    }
}
