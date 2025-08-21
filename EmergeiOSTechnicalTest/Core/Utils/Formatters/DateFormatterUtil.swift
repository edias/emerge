//
//  DateFormatterUtil.swift
//  EmergeiOSTechnicalTest
//
//  Created by Eduardo Dias on 21/08/2025.
//

import Foundation

enum DateFormatterUtil {

    private static let mediumDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    static func formatMediumDateTime(_ date: Date) -> String {
        return mediumDateTimeFormatter.string(from: date)
    }

    static func formatMediumDateTime(from timestamp: TimeInterval) -> String {
        return formatMediumDateTime(Date(timeIntervalSince1970: timestamp))
    }
}
