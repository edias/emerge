//
//  Copyright © 2025 Emerge. All rights reserved.
//

import SwiftUI

struct TransactionsView: View {

    @StateObject private var viewModel: TransactionsViewModel

    init(viewModel: TransactionsViewModel = TransactionsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Transactions")
                    .font(.largeTitle)
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
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
            await viewModel.loadTransactions()
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
                    formattedDate: transaction.formattedDate,
                    formattedAmount: transaction.formattedAmount,
                    action: { viewModel.approveTransaction($0) }
                )
                .onTapGesture {
                    viewModel.selectedTransaction = transaction
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
}
