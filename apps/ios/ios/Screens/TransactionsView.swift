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
    
    /// Preview state for testing different UI states
    private let previewState: PreviewState?
    
    /// Initializer for normal use
    init() {
        self.previewState = nil
    }
    
    /// Initializer for previews with specific state
    init(previewState: PreviewState) {
        self.previewState = previewState
    }
    
    private var transactions: [Transaction] {
        guard let previewState = previewState else {
            return mockTransactions
        }
        
        switch previewState {
        case .default:
            return mockTransactions
        case .empty:
            return []
        case .loading, .error:
            return mockTransactions // For now, loading/error handled at view level
        }
    }
    
    private var isLoading: Bool {
        previewState == .loading
    }
    
    private var hasError: Bool {
        previewState == .error
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if hasError {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Failed to load transactions")
                        .font(.headline)
                    Text("Please try again")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if transactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No transactions yet")
                        .font(.headline)
                    Text("Your transactions will appear here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.currencySymbol = currency == "JPY" ? "¥" : nil
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
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

// MARK: - Previews

#Preview("Default") {
    NavigationStack {
        TransactionsView(previewState: .default)
    }
}

#Preview("Empty") {
    NavigationStack {
        TransactionsView(previewState: .empty)
    }
}

#Preview("Loading") {
    NavigationStack {
        TransactionsView(previewState: .loading)
    }
}

#Preview("Error") {
    NavigationStack {
        TransactionsView(previewState: .error)
    }
}

#Preview("Light Mode") {
    NavigationStack {
        TransactionsView(previewState: .default)
            .previewAppearance(colorScheme: .light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        TransactionsView(previewState: .default)
            .previewAppearance(colorScheme: .dark)
    }
}

