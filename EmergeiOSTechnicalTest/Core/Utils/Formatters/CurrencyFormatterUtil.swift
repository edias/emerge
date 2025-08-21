//
//  CurrencyFormatterUtil.swift
//  EmergeiOSTechnicalTest
//
//  Created by Eduardo Dias on 21/08/2025.
//

import Foundation

enum CurrencyFormatterUtil {
    
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()

    static func format(_ amount: Double, locale: Locale? = nil) -> String {
        currencyFormatter.string(from: NSNumber(value: amount)) ?? fallbackFormat(amount)
    }

    private static func fallbackFormat(_ amount: Double) -> String {
        let sign = amount < 0 ? "-" : ""
        let absoluteAmount = abs(amount)
        return "\(sign)$\(String(format: "%.2f", absoluteAmount))"
    }
}
