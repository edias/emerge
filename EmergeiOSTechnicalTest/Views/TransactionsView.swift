//
//  Copyright © 2025 Emerge. All rights reserved.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var viewModel = TransactionsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Transactions")
                    .font(.largeTitle)
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TransactionList(transactions: viewModel.transactions, viewModel: viewModel)
                }
            }
            .navigationDestination(item: $viewModel.selectedTransaction) { transaction in
                TransactionDetailView(viewModel: viewModel, transaction: transaction)
            }
        }
        .task {
            viewModel.loadTransactions()
        }
    }
}

struct TransactionList: View {
    let transactions: [TransactionData]
    let viewModel: TransactionsViewModel
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                TransactionRowView(
                    transaction: transaction,
                    formattedDate: formatDate(transaction.date),
                    formattedAmount: viewModel.formatCurrency(transaction.amount),
                    action: { viewModel.approveTransaction($0) }
                )
                .onTapGesture {
                    viewModel.selectTransaction(transaction)
                }
            }
        }
    }
    
    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TransactionsView(viewModel: TransactionsViewModel())
}
