//
//  Int+DecimalCurrency.swift
//  ReactiveCells
//
//  Created by Greg Price on 15/03/2021.
//

import Foundation

extension Int {
    var decimalCurrency: Double {
        return Double(self) / 100.0
    }
    
    var decimalCurrencyString: String {
        let locale = Locale.current
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = locale.currencyCode
        numberFormatter.locale = locale
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        guard let value = numberFormatter.string(from: NSNumber(value: decimalCurrency)) else { fatalError("Could not format decimal currency: \( decimalCurrency)") }
        guard let symbol = locale.currencySymbol else { fatalError("Could not find currency symbol for locale: \(locale)") }
        return "\(symbol)\(value)"
    }
}
