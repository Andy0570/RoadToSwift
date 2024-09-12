//
//  UITextField+Factory.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import UIKit

extension UITextField {
    static func makeTextField(titleFont: UIFont) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.font = titleFont
        return textField
    }
}
