//
//  UIColor+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

import UIKit

extension UIColor {
    // !!!: 需要在 Asset catalogs 中创建相同名称的颜色
    static var rwGreen: UIColor {
        guard let color = UIColor(named: "rw-green") else {
            fatalError("Initialize color failured, Please check Assets.xcassets!")
        }
        return color
    }

    static var rwDark: UIColor {
        guard let color = UIColor(named: "rw-dark") else {
            fatalError("Initialize color failured, Please check Assets.xcassets!")
        }
        return color
    }

    static var rwLight: UIColor {
        guard let color = UIColor(named: "rw-light") else {
            fatalError("Initialize color failured, Please check Assets.xcassets!")
        }
        return color
    }
}
