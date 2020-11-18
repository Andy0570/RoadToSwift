//
//  NSAttributedString+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

/**
 字符串高亮
 
 Usage:
 label.attributedText = NSAttributedString(string: "Budapest")
 label.attributedText = label.attributedText?.highlighting("Bud", using: .blue)
 */
extension NSAttributedString {
    func highlighting(_ substring: String, using color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: (self.string as NSString).range(of: substring))
        return attributedString
    }
}
