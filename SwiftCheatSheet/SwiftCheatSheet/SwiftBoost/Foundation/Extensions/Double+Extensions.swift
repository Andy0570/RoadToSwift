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

    // Double -> String，保留2位小数
    func toString() -> String {
        String(format: "%.02f", self)
    }

    /**
     转换为价格字符串

     let dPrice = 16.50
     let strPrice = dPrice.toPrice(currency: "€")
     */
    func toPrice(currency: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return (numberFormatter.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}
