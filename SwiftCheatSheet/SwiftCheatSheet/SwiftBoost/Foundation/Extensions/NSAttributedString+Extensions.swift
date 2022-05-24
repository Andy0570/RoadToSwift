//
//  NSAttributedString+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import UIKit

extension NSAttributedString {
    /**
     字符串高亮

     label.attributedText = NSAttributedString(string: "Budapest")
     label.attributedText = label.attributedText?.highlighting("Bud", using: .blue)
     */
    func highlighting(_ substring: String, using color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: (self.string as NSString).range(of: substring))
        return attributedString
    }
}

// MARK: - 使用 UIFont 计算字符串的宽度和高度

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
