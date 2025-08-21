//
//  Copyright © 2025 Emerge. All rights reserved.
//

import Foundation

final class TransactionsViewModel: ObservableObject {

    @Published var transactions: [TransactionData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedTransaction: TransactionData? = nil

    var error: TransactionsViewModelError? {
        didSet {
            errorMessage = error?.localizedDescription
        }
    }

    private let repository: TransactionRepositoryProtocol

    init(repository: TransactionRepositoryProtocol = TransactionRepository()) {
        self.repository = repository
    }

    @MainActor
    func loadTransactions(suppressLoading: Bool = false) async {

        if !suppressLoading {
            isLoading = true
            error = nil
        }

        defer { if !suppressLoading { isLoading = false } }

        do {
            self.transactions = try await repository.getEnrichedTransactions()
        } catch {
            self.error = .transactionsLoadError
        }
    }

    @MainActor
    func approveTransaction(_ transaction: TransactionData) {

        isLoading = true
        error = nil

        Task {

            defer { isLoading = false }

            do {
                try await repository.approveTransaction(transaction: transaction)
                await loadTransactions()
            } catch {
                self.error = .transactionApprovalError

            }
        }
    }
}

enum TransactionsViewModelError: LocalizedError {

    case transactionsLoadError
    case transactionApprovalError

    var errorDescription: String? {
        switch self {
        case .transactionsLoadError:
            return "Transactions were not able to load"
        case .transactionApprovalError:
            return "Transaction approval failed"
        }
    }
}
