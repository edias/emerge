//
//  Copyright © 2025 Emerge. All rights reserved.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func getTransactions() async throws -> [TransactionData]
    func approveTransaction(transaction: TransactionData) async throws
    func getCategories() async throws -> [CategoryData]
    func getEnrichedTransactions() async throws -> [TransactionData]
}

class TransactionRepository: TransactionRepositoryProtocol {
    
    private let transactionAPI: TransactionAPI
    
    init(transactionAPI: TransactionAPI = MockTransactionAPI()) {
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

    // MARK: - Performance Consideration
    // Currently merging transaction and category data on the client side using nested operations.
    // This strategy becomes inefficient with large datasets.
    //
    // Recommended improvements: API should return transactions with pre-populated category names
    func getEnrichedTransactions() async throws -> [TransactionData] {

        async let transactionsTask = transactionAPI.fetchTransactions()
        async let categoriesTask = transactionAPI.fetchCategories()

        let (transactions, categories) = try await (transactionsTask, categoriesTask)
        return transactions.enriched(with: categories)
    }
}

private extension Array where Element == TransactionData {

    func enriched(with categories: [CategoryData]) -> [TransactionData] {

        let categoryMap = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0.name) })

        return map { transaction in
            var transaction = transaction
            transaction.categoryName = categoryMap[transaction.categoryId]
            return transaction
        }
    }
}
