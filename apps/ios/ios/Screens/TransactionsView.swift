//
//  TransactionsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct TransactionsView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @Environment(UserPreferences.self) private var preferences
    @State private var searchText = ""
    @State private var selectedTimeRange: TimeRangeFilter = .all
    @State private var selectedCategory: String? = nil
    @State private var selectedIntent: String? = nil
    
    // Using mock data for now - will be replaced with real data provider later
    #if DEBUG
    private let mockTransactions = MockData.transactions.generate(count: 20)
    #else
    private let mockTransactions: [Transaction] = []
    #endif
    
    private var currentState: ScreenState {
        screenStateManager.state(for: .transactions)
    }
    
    private var filteredTransactions: [Transaction] {
        var filtered = mockTransactions
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.merchant?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        // Filter by time range (stub - would need actual date filtering)
        // Filter by category (stub - would need classification data)
        // Filter by intent (stub - would need classification data)
        
        return filtered
    }
    
    var body: some View {
        Group {
            switch currentState {
            case .default:
                TransactionsContentView(
                    transactions: filteredTransactions,
                    searchText: $searchText,
                    selectedTimeRange: $selectedTimeRange,
                    selectedCategory: $selectedCategory,
                    selectedIntent: $selectedIntent
                )
            case .empty:
                EmptyStateView(
                    title: "No Transactions",
                    message: "You haven't made any transactions yet. Start by adding your first transaction.",
                    actionTitle: "Add Transaction",
                    action: {}
                )
            case .loading:
                LoadingStateView()
            case .error:
                ErrorStateView(
                    title: "Unable to Load Transactions",
                    message: "Something went wrong while loading your transactions. Please try again.",
                    retryAction: {
                        screenStateManager.setState(.default, for: .transactions)
                    }
                )
            }
        }
        .navigationTitle("Transactions")
    }
}

private struct TransactionsContentView: View {
    let transactions: [Transaction]
    @Binding var searchText: String
    @Binding var selectedTimeRange: TimeRangeFilter
    @Binding var selectedCategory: String?
    @Binding var selectedIntent: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter bar (stub)
            FilterBarView(
                selectedTimeRange: $selectedTimeRange,
                selectedCategory: $selectedCategory,
                selectedIntent: $selectedIntent
            )
            
            if transactions.isEmpty {
                EmptyStateView(
                    title: "No Transactions Found",
                    message: "Try adjusting your filters or search terms.",
                    actionTitle: nil,
                    action: nil
                )
            } else {
                List(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .searchable(text: $searchText, prompt: "Search transactions")
            }
        }
    }
}

// MARK: - Filter Bar

enum TimeRangeFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
}

struct FilterBarView: View {
    @Binding var selectedTimeRange: TimeRangeFilter
    @Binding var selectedCategory: String?
    @Binding var selectedIntent: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingToken.sm) {
                // Time range filter
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRangeFilter.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.menu)
                
                // Category filter (stub)
                Button(action: {}) {
                    HStack {
                        Text("Category")
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, SpacingToken.md)
                    .padding(.vertical, SpacingToken.sm)
                    .background(ColorToken.neutral200)
                    .cornerRadius(RadiusToken.chip)
                }
                
                // Intent filter (stub)
                Button(action: {}) {
                    HStack {
                        Text("Intent")
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, SpacingToken.md)
                    .padding(.vertical, SpacingToken.sm)
                    .background(ColorToken.neutral200)
                    .cornerRadius(RadiusToken.chip)
                }
            }
            .padding(.horizontal, SpacingToken.md)
            .padding(.vertical, SpacingToken.sm)
        }
        .background(ColorToken.neutral100)
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

