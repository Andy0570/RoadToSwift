//
//  Int+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

extension Int {
    // MARK: Int -> String
    func toString() -> String {
        "\(self)"
    }
    
    // MARK: Int -> Double
    func toDouble() -> Double {
        Double(self)
    }
    
    // MARK: 美分 -> 美元
    func centsToDollars() -> Double {
        Double(self) / 100
    }
}
