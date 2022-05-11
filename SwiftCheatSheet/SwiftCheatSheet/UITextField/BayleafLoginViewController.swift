//
//  BayleafLoginViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/11.
//

/**
 如何使用 Swift 在你的 iOS 应用程序中添加漂亮的 UITextField 动画
 Reference: <https://blog.devgenius.io/how-to-add-a-nice-uitextfield-animation-to-your-ios-app-using-swift-7aea90d120ad>
 */
import UIKit

class BayleafLoginViewController: UIViewController {
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameLine: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordLine: UIView!
    @IBOutlet private weak var signinButton: UIButton!

    lazy var textFields = [usernameTextField, passwordTextField]
    var placeholders = ["username", "password"]

    override func viewDidLoad() {
        super.viewDidLoad()

        for (index, textField) in textFields.enumerated() {
            textField?.attributedPlaceholder = NSAttributedString(string: placeholders[index],
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            textField?.delegate = self
        }

        signinButton.layer.cornerRadius = signinButton.frame.height / 2
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension BayleafLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField: animate(line: usernameLine)
        case passwordTextField: animate(line: passwordLine)
        default: return
        }
    }

    private func animate(line: UIView) {
        line.alpha = 0.3
        UIView.animate(withDuration: 1) {
            line.alpha = 1.0
        }
    }
}
