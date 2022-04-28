//
//  DRHTextFieldViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import UIKit

class DRHTextFieldViewController: UIViewController {
    @IBOutlet weak var textField: DRHTextFieldWithCharacterCount!

    private lazy var hoverTextView: HoverTextView = {
        let hoverTextView = HoverTextView()
        hoverTextView.translatesAutoresizingMaskIntoConstraints = false
        hoverTextView.backgroundColor = .secondarySystemBackground
        return hoverTextView
    }()

    // 单击手势，点击空白区域收起键盘
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(tapRecognizer)

        hoverTextView.hoverDelegate = self
        view.addSubview(hoverTextView)
        NSLayoutConstraint.activate([
            hoverTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hoverTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hoverTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Internal Methods

    @objc func dismissKeyboard() {
        // textField.resignFirstResponder()
        view.endEditing(true)
    }
}

extension DRHTextFieldViewController: HoverTextViewDelegate {
    func hoverTextViewStateChange(isHover: Bool) {
    }
}
