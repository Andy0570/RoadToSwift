//
//  AttributedString.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

extension NSMutableAttributedString {
    // 将 String 更改为 NSMutableAttributedString 类型
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }

    // 将属性应用于子字符串
    func apply(attribute: [NSAttributedString.Key: Any], subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }

    // 将属性应用于字符串范围
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }

    /************************ Color Attribute ************************/
    // Apply color on substring
    func apply(color: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(color: color, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply color on given range
    func apply(color: UIColor, onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
    }

    /************************ Font Attribute ************************/
    // Apply font on substring
    func apply(font: UIFont, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(font: font, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply font on given range
    func apply(font: UIFont, onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.font: font], range: range)
    }

    /************************ Background Color Attribute ************************/
    // Apply background color on substring
    func apply(backgroundColor: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(backgroundColor: backgroundColor, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply background color on given range
    func apply(backgroundColor: UIColor, onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.backgroundColor: backgroundColor], range: range)
    }

    /************************ Underline Attribute ************************/
    // Underline string
    func underLine(subString: String) {
        if let range = self.string.range(of: subString) {
            self.underLine(onRange: NSRange(range, in: self.string))
        }
    }

    // Underline string on given range
    func underLine(onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
    }

    /************************ Strikethrough Attribute ************************/
    // Apply Strikethrough on substring
    func strikeThrough(thickness: Int, subString: String) {
        if let range = self.string.range(of: subString) {
            self.strikeThrough(thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply Strikethrough on given range
    func strikeThrough(thickness: Int, onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue], range: range)
    }

    /************************ Stroke Attribute ************************/
    // Apply stroke on substring
    func applyStroke(color: UIColor, thickness: Int, subString: String) {
        if let range = self.string.range(of: subString) {
            self.applyStroke(color: color, thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply stroke on give range
    func applyStroke(color: UIColor, thickness: Int, onRange range: NSRange) {
        self.addAttributes([NSAttributedString.Key.strokeColor: color], range: range)
        self.addAttributes([NSAttributedString.Key.strokeWidth: thickness], range: range)
    }

    /************************ Shadow Color Attribute ************************/
    // Apply shadow color on substring
    func applyShadow(
        shadowColor: UIColor,
        shadowWidth: CGFloat,
        shadowHeigt: CGFloat,
        shadowRadius: CGFloat,
        subString: String
    ) {
        if let range = self.string.range(of: subString) {
            self.applyShadow(
                shadowColor: shadowColor,
                shadowWidth: shadowWidth,
                shadowHeigt: shadowHeigt,
                shadowRadius: shadowRadius,
                onRange: NSRange(range, in: self.string)
            )
        }
    }

    // Apply shadow color on given range
    func applyShadow(
        shadowColor: UIColor,
        shadowWidth: CGFloat,
        shadowHeigt: CGFloat,
        shadowRadius: CGFloat,
        onRange range: NSRange
    ) {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: shadowWidth, height: shadowHeigt)
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        self.addAttributes([NSAttributedString.Key.shadow: shadow], range: range)
    }

    /************************ Paragraph Style  Attribute ************************/
    // Apply paragraph style on substring
    func alignment(alignment: NSTextAlignment, subString: String) {
        if let range = self.string.range(of: subString) {
            self.alignment(alignment: alignment, onRange: NSRange(range, in: self.string))
        }
    }

    // Apply paragraph style on give range
    func alignment(alignment: NSTextAlignment, onRange range: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
    }
}
