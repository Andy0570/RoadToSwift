//
//  Double+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

extension Double {
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    }()

    var formatted: String {
        return Double.formatter.string(for: self) ?? String(self)
    }
}
