//
//  UIColor+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

/**
 通过 Hex 字符串创建颜色

 let strColor = "#ff0000" // Red color
 let color = strColor.toColor()

 var red: CGFloat = 0.0
 var green: CGFloat = 0.0
 var blue: CGFloat = 0.0
 var alpha: CGFloat = 0.0
 color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
 print(red, green, blue, alpha)
 // 1.0 0.0 0.0 1.0
 */

#if os(iOS) || os(tvOS)
import UIKit
typealias UniColor = UIColor
#else
import Cocoa
typealias UniColor = NSColor
#endif

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

extension UniColor {
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }

    private convenience init?(hex3: Int, alpha: Float) {
        self.init(
            red: CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
            green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
            blue: CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    private convenience init?(hex6: Int, alpha: Float) {
        self.init(
            red: CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
            green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
            blue: CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    convenience init?(hexString: String, alpha: Float) {
        var hex = hexString

        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            self.init()
            return nil
        }
    }

    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}

extension String {
    func toColor() -> UniColor? {
        UniColor(hexString: self)
    }
}

extension Int {
    func toColor(alpha: Float = 1.0) -> UniColor? {
        UniColor(hex: self, alpha: alpha)
    }
}

extension UIColor {
    // !!!: 需要在 Asset catalogs 中创建相同名称的颜色
    static var accent: UIColor {
        UIColor(named: "Accent")!
    }

    static var primary: UIColor {
        UIColor(named: "Primary")!
    }

    static var primaryText: UIColor {
        UIColor(named: "PrimaryText")!
    }
}
