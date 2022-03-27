//
//  UITextField+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit

extension UITextField {
    // 设置底部的下划线边框
    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.rwGreen.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}
