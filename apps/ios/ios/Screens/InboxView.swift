//
//  InboxView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct InboxView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @Environment(UserPreferences.self) private var preferences
    
    // Using mock data for now
    #if DEBUG
    private let mockTransactions = MockData.transactions.generate(count: 10)
    #else
    private let mockTransactions: [Transaction] = []
    #endif
    
    private var currentState: ScreenState {
        screenStateManager.state(for: .inbox)
    }
    
    var body: some View {
        Group {
            switch currentState {
            case .default:
                InboxContentView(transactions: mockTransactions)
            case .empty:
                EmptyStateView(
                    title: "Inbox is Empty",
                    message: "All transactions have been processed. New transactions will appear here for classification.",
                    actionTitle: nil,
                    action: nil
                )
            case .loading:
                LoadingStateView()
            case .error:
                ErrorStateView(
                    title: "Unable to Load Inbox",
                    message: "Something went wrong while loading your inbox. Please try again.",
                    retryAction: {
                        screenStateManager.setState(.default, for: .inbox)
                    }
                )
            }
        }
        .navigationTitle("Inbox")
        .onAppear {
            logInboxRender()
        }
    }
    
    private func logInboxRender() {
        #if DEBUG
        print("[Inbox] Render - State: \(currentState.rawValue), Transaction count: \(mockTransactions.count)")
        #endif
    }
}

private struct InboxContentView: View {
    let transactions: [Transaction]
    
    var body: some View {
        if transactions.isEmpty {
            EmptyStateView(
                title: "No Transactions",
                message: "There are no transactions in your inbox.",
                actionTitle: nil,
                action: nil
            )
        } else {
            List(transactions) { transaction in
                InboxTransactionRow(transaction: transaction)
            }
        }
    }
}

struct InboxTransactionRow: View {
    let transaction: Transaction
    @State private var currentIntent: Classification.KakeiboIntent? = nil
    @State private var showUndo = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant ?? "Unknown")
                    .font(.headline)
                Text(formatAmount(transaction.amount, currency: transaction.currency))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Button alternatives for swipe actions
            HStack(spacing: SpacingToken.xs) {
                IntentButton(
                    intent: .need,
                    icon: "checkmark.circle.fill",
                    color: .green,
                    action: { setIntent(.need) }
                )
                
                IntentButton(
                    intent: .want,
                    icon: "heart.circle.fill",
                    color: .blue,
                    action: { setIntent(.want) }
                )
                
                IntentButton(
                    intent: .culture,
                    icon: "book.circle.fill",
                    color: .purple,
                    action: { setIntent(.culture) }
                )
                
                IntentButton(
                    intent: .unexpected,
                    icon: "exclamationmark.circle.fill",
                    color: .orange,
                    action: { setIntent(.unexpected) }
                )
            }
        }
        .padding(.vertical, 4)
        .background(intentBackgroundColor)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            SwipeActionButton(intent: .need, color: .green) {
                setIntent(.need)
            }
            SwipeActionButton(intent: .want, color: .blue) {
                setIntent(.want)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            SwipeActionButton(intent: .culture, color: .purple) {
                setIntent(.culture)
            }
            SwipeActionButton(intent: .unexpected, color: .orange) {
                setIntent(.unexpected)
            }
        }
        .overlay(alignment: .bottom) {
            if showUndo {
                UndoBanner(
                    message: "Marked as \(currentIntent?.displayName ?? "")",
                    onUndo: {
                        undoIntent()
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showUndo)
        .animation(.easeInOut(duration: 0.2), value: currentIntent)
    }
    
    private var intentBackgroundColor: Color {
        guard let intent = currentIntent else { return Color.clear }
        switch intent {
        case .need:
            return Color.green.opacity(0.1)
        case .want:
            return Color.blue.opacity(0.1)
        case .culture:
            return Color.purple.opacity(0.1)
        case .unexpected:
            return Color.orange.opacity(0.1)
        }
    }
    
    private func setIntent(_ intent: Classification.KakeiboIntent) {
        let previousIntent = currentIntent
        currentIntent = intent
        showUndo = true
        
        logInboxAction(intent: intent.rawValue, transactionId: transaction.id)
        
        // Auto-hide undo banner after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if currentIntent == intent {
                showUndo = false
            }
        }
    }
    
    private func undoIntent() {
        logInboxUndo(transactionId: transaction.id)
        currentIntent = nil
        showUndo = false
    }
    
    private func formatAmount(_ amount: Decimal, currency: String) -> String {
        CurrencyFormatter.format(amount, currencyCode: currency)
    }
    
    private func logInboxAction(intent: String, transactionId: String) {
        #if DEBUG
        print("[Inbox] Action - Intent: \(intent), Transaction ID: \(transactionId)")
        #endif
    }
    
    private func logInboxUndo(transactionId: String) {
        #if DEBUG
        print("[Inbox] Undo - Transaction ID: \(transactionId)")
        #endif
    }
}

// MARK: - Intent Button

struct IntentButton: View {
    let intent: Classification.KakeiboIntent
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
        }
        .accessibilityLabel("Mark as \(intent.displayName)")
        .accessibilityHint("Sets the transaction intent to \(intent.displayName)")
    }
}

// MARK: - Swipe Action Button

struct SwipeActionButton: View {
    let intent: Classification.KakeiboIntent
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(intent.displayName, systemImage: intent.icon)
        }
        .tint(color)
    }
}

// MARK: - Undo Banner

struct UndoBanner: View {
    let message: String
    let onUndo: () -> Void
    
    var body: some View {
        HStack {
            Text(message)
                .font(TypographyToken.body())
            Spacer()
            Button("Undo", action: onUndo)
                .font(TypographyToken.body(weight: .semibold))
        }
        .padding()
        .background(ColorToken.neutral100)
        .cornerRadius(RadiusToken.card)
        .padding(.horizontal)
        .padding(.bottom, SpacingToken.md)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - KakeiboIntent Extension

extension Classification.KakeiboIntent {
    var displayName: String {
        switch self {
        case .need:
            return "Need"
        case .want:
            return "Want"
        case .culture:
            return "Culture"
        case .unexpected:
            return "Unexpected"
        }
    }
    
    var icon: String {
        switch self {
        case .need:
            return "checkmark.circle.fill"
        case .want:
            return "heart.circle.fill"
        case .culture:
            return "book.circle.fill"
        case .unexpected:
            return "exclamationmark.circle.fill"
        }
    }
}

// MARK: - Logging Stubs

#if DEBUG
func logInboxRender() {
    print("[Inbox] Render - List rendered")
}

func logInboxAction(intent: String, transactionId: String) {
    print("[Inbox] Action - Intent: \(intent), Transaction ID: \(transactionId)")
}

func logInboxUndo(transactionId: String) {
    print("[Inbox] Undo - Transaction ID: \(transactionId)")
}
#endif

#Preview("Default") {
    NavigationStack {
        InboxView()
            .environment(UserPreferences.shared)
    }
}

#Preview("Empty") {
    NavigationStack {
        InboxView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.empty, for: .inbox)
            }
    }
}

#Preview("Loading") {
    NavigationStack {
        InboxView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.loading, for: .inbox)
            }
    }
}

#Preview("Error") {
    NavigationStack {
        InboxView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.error, for: .inbox)
            }
    }
}



