//
//  DateFormatterUtilTests.swift
//  EmergeiOSTechnicalTestTests
//
//  Created by Eduardo Dias on 21/08/2025.
//

import Testing

import Foundation

@testable import EmergeiOSTechnicalTest

// MARK: - Additional Test Coverage is required

struct DateFormatterUtilTests {

    @Test
    func equivalentInputsProduceSameOutput() {

        let timestamp: TimeInterval = 1710511800
        let date = Date(timeIntervalSince1970: timestamp)

        let resultFromDate = DateFormatterUtil.formatMediumDateTime(date)
        let resultFromTimestamp = DateFormatterUtil.formatMediumDateTime(from: timestamp)

        #expect(resultFromDate == resultFromTimestamp)
    }

    @Test
    func formatCurrentDate() {

        let currentDate = Date()

        let result = DateFormatterUtil.formatMediumDateTime(currentDate)

        #expect(!result.isEmpty)

        let components = result.components(separatedBy: " ")
        #expect(components.count >= 3)
    }

    @Test
    func formatNegativeTimestamp() {

        let negativeTimestamp: TimeInterval = -86400

        let result = DateFormatterUtil.formatMediumDateTime(from: negativeTimestamp)

        #expect(!result.isEmpty)
        #expect(result.contains("1969"))
        #expect(result.contains("Dec"))
        #expect(result.contains("31"))
    }
}
