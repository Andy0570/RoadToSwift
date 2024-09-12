//
//  UIButton+Factory.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import UIKit
import SwifterSwift

extension UIButton {
    static func makeSubmitButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.setBackgroundColor(color: .systemBlue, forState: .normal)
        button.setBackgroundColor(color: .lightGray, forState: .disabled)
        button.setBackgroundColor(color: .systemBlue.darken(by: 0.1), forState: .highlighted)
        button.layer.cornerRadius = 22.0
        return button
    }
}
