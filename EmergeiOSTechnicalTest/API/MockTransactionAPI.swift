//
//  Copyright © 2025 Emerge. All rights reserved.
//

import Foundation

class MockTransactionAPI: TransactionAPI {
    
    private let simulatedNetworkDelay: TimeInterval = 1.0
    
    private var dummyTransactions: [TransactionData] = DummyData.transactions
    private let categoryData: [CategoryData] = DummyData.categories
    
    func fetchTransactions() async throws -> [TransactionData] {
        try await Task.sleep(for: .seconds(simulatedNetworkDelay))
        return dummyTransactions
    }
    
    func approveTransaction(transactionId: String) async throws {
        try await Task.sleep(for: .seconds(simulatedNetworkDelay))
        
        guard let index = dummyTransactions.firstIndex(where: { $0.id == transactionId }) else {
            throw APIError.transactionNotFound
        }
        
        let transaction = dummyTransactions[index]
        if transaction.approved {
            throw APIError.transactionAlreadyApproved
        }
        
        dummyTransactions[index] = TransactionData(
            id: transaction.id,
            amount: transaction.amount,
            description: transaction.description,
            categoryId: transaction.categoryId,
            date: transaction.date,
            approved: true,
            categoryName: transaction.categoryName
        )
    }
    
    func fetchCategories() async throws -> [CategoryData] {
        try await Task.sleep(for: .seconds(simulatedNetworkDelay))
        return categoryData
    }
}
