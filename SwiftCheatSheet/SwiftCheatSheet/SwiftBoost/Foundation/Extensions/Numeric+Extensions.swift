//
//  Numeric+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? String(describing: self)
    }
}
