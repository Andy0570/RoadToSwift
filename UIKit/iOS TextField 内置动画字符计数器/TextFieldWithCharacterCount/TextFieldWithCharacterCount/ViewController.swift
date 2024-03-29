//
//  ViewController.swift
//  TextFieldWithCharacterCount
//
//  Created by Qilin Hu on 2022/1/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: DRHTextFieldWithCharacterCount!

    // 单击手势，点击空白区域收起键盘
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Internal Methods

    @objc func dismissKeyboard() {
        textField.resignFirstResponder()
    }
}

