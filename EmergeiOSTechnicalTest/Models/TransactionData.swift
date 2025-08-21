//
//  Copyright © 2025 Emerge. All rights reserved.
//

import Foundation

struct TransactionData: Identifiable, Codable, Hashable {
    let id: String
    let amount: Double
    let description: String
    let categoryId: String
    let date: TimeInterval
    let approved: Bool
    var categoryName: String? = nil
}

extension TransactionData {
    var formattedDate:  String { DateFormatterUtil.formatMediumDateTime(from: date) }
    var formattedAmount: String { CurrencyFormatterUtil.format(amount) }
}
