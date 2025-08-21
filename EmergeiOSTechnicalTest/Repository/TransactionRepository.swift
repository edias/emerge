//
//  Copyright © 2025 Emerge. All rights reserved.
//

import Foundation

class TransactionRepository {
    private let transactionAPI: TransactionAPI
    
    init(transactionAPI: TransactionAPI) {
        self.transactionAPI = transactionAPI
    }
    
    func getTransactions() async throws -> [TransactionData] {
        return try await transactionAPI.fetchTransactions()
    }
    
    func approveTransaction(transaction: TransactionData) async throws {
        try await transactionAPI.approveTransaction(transactionId: transaction.id)
    }
    
    func getCategories() async throws -> [CategoryData] {
        return try await transactionAPI.fetchCategories()
    }
}
