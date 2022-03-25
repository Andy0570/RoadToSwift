//
//  ColorPalette.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit

struct ColorPalette {
    static let RWGreen = UIColor(red: CGFloat(0), green: CGFloat(104/255.0), blue: CGFloat(55/255.0), alpha: CGFloat(1.0))

    @available(swift, deprecated: 5.0, message: "请使用 SwifterSwift/ColorExtensions.swift 中的 'random' 属性")
    static var randomColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
}
