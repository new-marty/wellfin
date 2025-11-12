//
//  TransactionsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct TransactionsView: View {
    // Using mock data for now - will be replaced with real data provider later
    #if DEBUG
    private let mockTransactions = MockData.transactions.generate(count: 20)
    #else
    private let mockTransactions: [Transaction] = []
    #endif
    
    var body: some View {
        List(mockTransactions) { transaction in
            TransactionRow(transaction: transaction)
        }
        .navigationTitle("Transactions")
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant ?? "Unknown")
                    .font(.headline)
                Text(formatChannel(transaction.channel))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(formatAmount(transaction.amount, currency: transaction.currency))
                .font(.body.monospacedDigit())
                .foregroundStyle(transaction.amount < 0 ? .red : .primary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatAmount(_ amount: Decimal, currency: String) -> String {
        CurrencyFormatter.format(amount, currencyCode: currency)
    }
    
    private func formatChannel(_ channel: Transaction.TransactionChannel) -> String {
        switch channel {
        case .card:
            return "Card"
        case .cash:
            return "Cash"
        case .bankTransfer:
            return "Bank Transfer"
        case .digitalWallet:
            return "Digital Wallet"
        case .other:
            return "Other"
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsView()
    }
}

