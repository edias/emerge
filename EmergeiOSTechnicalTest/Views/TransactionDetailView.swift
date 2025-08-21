//
//  Copyright © 2025 Emerge. All rights reserved.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @ObservedObject var viewModel: TransactionsViewModel
    
    let transaction: TransactionData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Transaction Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("Amount:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(transaction.formattedAmount)
                            .fontWeight(.semibold)
                            .foregroundColor(transaction.amount < 0 ? .red : .primary)
                    }
                    
                    HStack {
                        Text("Description:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(transaction.description)
                    }
                    
                    HStack {
                        Text("Category:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(transaction.categoryName ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Date:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(transaction.formattedDate)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Status:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(transaction.approved ? "Approved" : "Pending")
                            .foregroundColor(transaction.approved ? .green : .orange)
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                if !transaction.approved && !viewModel.isLoading {
                    HStack(spacing: 16) {
                        Button("Approve") {
                            viewModel.approveTransaction(transaction)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TransactionDetailView(
            viewModel: TransactionsViewModel(),
            transaction: TransactionData(
                id: "1",
                amount: 25.99,
                description: "Coffee Shop",
                categoryId: "CAT001",
                date: Date().timeIntervalSince1970,
                approved: false,
                categoryName: "Food & Drink"
            )
        )
    }
}
