//
//  Copyright © 2025 SquareOne. All rights reserved.
//  

protocol TransactionAPI {
    func fetchTransactions() async throws -> [TransactionData]
    func approveTransaction(transactionId: String) async throws
    func fetchCategories() async throws -> [CategoryData]
}
