//
//  Int+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

import Foundation

extension Int {
    // Int -> String
    func toString() -> String {
        "\(self)"
    }

    // 美分转换为美元
    // let cents = 12350
    // let dollars = cents.centsToDollars()
    func centsToDollars() -> Double {
        Double(self) / 100
    }
}
