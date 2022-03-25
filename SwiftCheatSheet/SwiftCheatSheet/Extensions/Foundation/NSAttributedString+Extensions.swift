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
