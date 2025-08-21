//
//  Copyright © 2025 Emerge. All rights reserved.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: TransactionData
    let formattedDate: String
    let formattedAmount: String
    let action: (TransactionData) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.headline)
                
                Text(transaction.categoryName ?? "Unknown Category")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(formattedAmount)
                    .font(.headline)
                    .foregroundColor(transaction.amount < 0 ? .red : .primary)
                
                if transaction.approved {
                    Text("Approved")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                } else {
                    Button("Approve") {
                        action(transaction)
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionRowView(
        transaction: TransactionData(
            id: "1",
            amount: 25.99,
            description: "Coffee Shop",
            categoryId: "CAT001",
            date: Date().timeIntervalSince1970,
            approved: false,
            categoryName: "Food & Drink"
        ),
        formattedDate: "Jan 1, 2024 at 2:30 PM",
        formattedAmount: "$25.99",
        action: { _ in }
    )
    .padding()
}
