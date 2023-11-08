//
//  DRHTextFieldViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import UIKit
import SwifterSwift

class DRHTextFieldViewController: UIViewController {
    @IBOutlet weak var textField: DRHTextFieldWithCharacterCount!

    private lazy var hoverTextView: HoverTextView = {
        let hoverTextView = HoverTextView()
        hoverTextView.translatesAutoresizingMaskIntoConstraints = false
        hoverTextView.backgroundColor = .secondarySystemBackground
        return hoverTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        hoverTextView.hoverDelegate = self
        view.addSubview(hoverTextView)
        NSLayoutConstraint.activate([
            hoverTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hoverTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hoverTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // dismissKeyboardWhenTappedAround()
    }
}

extension DRHTextFieldViewController: HoverTextViewDelegate {
    func hoverTextViewStateChange(isHover: Bool) {
    }
}
