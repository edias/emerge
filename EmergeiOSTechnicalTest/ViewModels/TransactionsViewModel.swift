//
//  Copyright © 2025 Emerge. All rights reserved.
//

import SwiftUI

class TransactionsViewModel: ObservableObject {
    
    @Published var transactions: [TransactionData] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var selectedTransaction: TransactionData? = nil
    
    private let repository: TransactionRepository = TransactionRepository(transactionAPI: MockTransactionAPI())
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
    
    func loadTransactions() {
        Task {
            await MainActor.run {
                isLoading = true
            }
            var transactions = try! await repository.getTransactions()
            let categories = try! await repository.getCategories()
            
            for i in 0..<transactions.count {
                transactions[i].categoryName = categories.first { $0.id == transactions[i].categoryId }?.name
            }
            
            await MainActor.run {
                self.transactions = transactions
                isLoading = false
            }
        }
    }
    
    func approveTransaction(_ transaction: TransactionData) {
        Task {
            await MainActor.run {
                isLoading = true
            }
            try! await repository.approveTransaction(transaction: transaction)
            
            var transactions = try! await repository.getTransactions()
            let categories = try! await repository.getCategories()
            
            for i in 0..<transactions.count {
                transactions[i].categoryName = categories.first { $0.id == transactions[i].categoryId }?.name
            }
            
            await MainActor.run {
                self.transactions = transactions
                isLoading = false
            }
        }
    }
    
    func formatCurrency(_ amount: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    func selectTransaction(_ transaction: TransactionData) {
        selectedTransaction = transaction
    }
}
