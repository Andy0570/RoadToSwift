//
//  Double+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

extension Double {
    // MARK: Double -> String
    func toString() -> String {
        String(format: "%.02f", self)
    }
    
    // MARK: Double -> Int
    func toInt() -> Int {
        Int(self)
    }
    
    /**
     转换为价格字符串
     
     let dPrice = 16.50
     let strPrice = dPrice.toPrice(currency: "€")
     */
    func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}
