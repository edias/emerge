//
//  CurrencyFormatterUtilTests.swift
//  EmergeiOSTechnicalTestTests
//
//  Created by Eduardo Dias on 21/08/2025.
//

import Testing
@testable import EmergeiOSTechnicalTest
import Foundation

struct CurrencyFormatterUtilTests {

    @Test
    func formatPositiveAmount() {

        let amount = 123.45
        let result = CurrencyFormatterUtil.format(amount)

        #expect(result.contains("123.45") || result.contains("123,45"))
    }

    @Test
    func formatNegativeAmount() {

        let amount = -123.45
        let result = CurrencyFormatterUtil.format(amount)

        #expect(result.contains("-") || result.contains("−") || result.contains("123.45"))
    }

    @Test
    func formatZero() {

        let amount = 0.0
        let result = CurrencyFormatterUtil.format(amount)

        #expect(result.contains("0.00") || result.contains("0,00"))
    }

    @Test
    func formatLargeAmount() {

        let amount = 1234567.89
        let result = CurrencyFormatterUtil.format(amount)

        #expect(result.contains("1234567.89") || result.contains("1,234,567.89"))
    }

    @Test
    func fallbackFormatPositive() {

        let amount = 123.45
        let result = CurrencyFormatterUtil.format(amount, locale: Locale(identifier: "invalid_locale"))

        #expect(result == "$123.45")
    }

    @Test
    func fallbackFormatNegative() {

        let amount = -123.45
        let result = CurrencyFormatterUtil.format(amount, locale: Locale(identifier: "invalid_locale"))

        #expect(result == "-$123.45")
    }

    @Test
    func fallbackFormatZero() {
        
        let amount = 0.0
        let result = CurrencyFormatterUtil.format(amount, locale: Locale(identifier: "invalid_locale"))

        #expect(result == "$0.00")
    }
}
