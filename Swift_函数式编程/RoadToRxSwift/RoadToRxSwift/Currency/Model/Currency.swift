//
//  Currency.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation

/// 货币类型
enum Currency: String {
    case EUR
    case GBP
    case USD
}

/// 货币区域
enum CurrencyLocale: String {
    case EUR = "fr-FR"
    case GBP = "en_UK"
}

/// 货币汇率
struct CurrencyRate {
    let currencyIso: String
    let rate: Double
}
