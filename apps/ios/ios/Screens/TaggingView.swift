//
//  TaggingView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Tagging surface with rule preview UI (NM-34)

import SwiftUI

struct TaggingView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @Environment(UserPreferences.self) private var preferences
    
    // Mock data for tagging
    #if DEBUG
    private let mockTransactions = MockData.transactions.generate(count: 5)
    #else
    private let mockTransactions: [Transaction] = []
    #endif
    
    private var currentState: ScreenState {
        screenStateManager.state(for: .tagging)
    }
    
    var body: some View {
        Group {
            switch currentState {
            case .default:
                TaggingContentView(transactions: mockTransactions)
            case .empty:
                EmptyStateView(
                    title: "No Transactions to Tag",
                    message: "All transactions have been tagged. New transactions will appear here.",
                    actionTitle: nil,
                    action: nil
                )
            case .loading:
                LoadingStateView()
            case .error:
                ErrorStateView(
                    title: "Unable to Load Transactions",
                    message: "Something went wrong while loading transactions for tagging. Please try again.",
                    retryAction: {
                        screenStateManager.setState(.default, for: .tagging)
                    }
                )
            }
        }
        .navigationTitle("Tagging")
    }
}

private struct TaggingContentView: View {
    let transactions: [Transaction]
    @State private var selectedTransaction: Transaction? = nil
    @State private var selectedIntent: Classification.KakeiboIntent? = nil
    @State private var selectedCategory: String? = nil
    @State private var tags: Set<String> = []
    @State private var rulePreview: RulePreview? = nil
    @Environment(UserPreferences.self) private var preferences
    
    private let categories = ["Groceries", "Dining", "Transport", "Shopping", "Entertainment", "Bills", "Rent"]
    private let availableTags = ["Home", "Work", "Travel", "Tax", "Refund", "Subscription", "Recurring"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingToken.lg) {
                if let transaction = selectedTransaction ?? transactions.first {
                    // Transaction Summary
                    TransactionSummaryCard(transaction: transaction)
                    
                    // Intent Selector
                    IntentSelectorSection(
                        selectedIntent: $selectedIntent,
                        onIntentChange: { intent in
                            selectedIntent = intent
                            updateRulePreview()
                        }
                    )
                    
                    // Category Selector
                    CategorySelectorSection(
                        selectedCategory: $selectedCategory,
                        categories: categories,
                        onCategoryChange: { category in
                            selectedCategory = category
                            updateRulePreview()
                        }
                    )
                    
                    // Tags Editor
                    TagsEditorSection(
                        tags: $tags,
                        availableTags: availableTags,
                        onTagsChange: {
                            updateRulePreview()
                        }
                    )
                    
                    // Rule Preview
                    if let rulePreview = rulePreview {
                        RulePreviewSection(rulePreview: rulePreview)
                    }
                    
                    // Actions
                    ActionsSection(
                        onApply: {
                            applyTagging()
                        },
                        onCreateRule: {
                            createRule()
                        }
                    )
                } else {
                    EmptyStateView(
                        title: "No Transactions",
                        message: "Select a transaction to start tagging.",
                        actionTitle: nil,
                        action: nil
                    )
                }
            }
            .padding(SpacingToken.lg)
        }
        .onAppear {
            if selectedTransaction == nil && !transactions.isEmpty {
                selectedTransaction = transactions.first
                updateRulePreview()
            }
        }
    }
    
    private func updateRulePreview() {
        // Generate mock rule preview based on selections
        var conditions: [String] = []
        
        if let intent = selectedIntent {
            conditions.append("Intent: \(intent.displayName)")
        }
        
        if let category = selectedCategory {
            conditions.append("Category: \(category)")
        }
        
        if !tags.isEmpty {
            conditions.append("Tags: \(tags.joined(separator: ", "))")
        }
        
        if !conditions.isEmpty {
            rulePreview = RulePreview(
                name: "Auto-tag Rule",
                conditions: conditions,
                actions: ["Apply intent", "Set category", "Add tags"]
            )
        } else {
            rulePreview = nil
        }
    }
    
    private func applyTagging() {
        // Stub - would apply tagging to selected transaction
        // In real implementation, this would save the classification
    }
    
    private func createRule() {
        // Stub - would create a rule based on current selections
        // In real implementation, this would save a tagging rule
    }
}

// MARK: - Supporting Views

struct TransactionSummaryCard: View {
    let transaction: Transaction
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                Text(transaction.merchant ?? "Unknown")
                    .font(TypographyToken.title3())
                
                Text(CurrencyFormatter.format(transaction.amount, currencyCode: transaction.currency))
                    .font(TypographyToken.title2(weight: .bold))
                    .font(.system(.title2, design: .default, weight: .bold).monospacedDigit())
                    .foregroundStyle(transaction.amount < 0 ? ColorToken.success : ColorToken.text)
                
                HStack {
                    Label(
                        WellfinDateFormatter.format(transaction.postedAt),
                        systemImage: "calendar"
                    )
                    .font(TypographyToken.body())
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Label(
                        formatChannel(transaction.channel),
                        systemImage: "creditcard"
                    )
                    .font(TypographyToken.body())
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private func formatChannel(_ channel: Transaction.TransactionChannel) -> String {
        switch channel {
        case .card: return "Card"
        case .cash: return "Cash"
        case .bankTransfer: return "Bank Transfer"
        case .digitalWallet: return "Digital Wallet"
        case .other: return "Other"
        }
    }
}

struct IntentSelectorSection: View {
    @Binding var selectedIntent: Classification.KakeiboIntent?
    let onIntentChange: (Classification.KakeiboIntent) -> Void
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.sm) {
                Text("Intent")
                    .font(TypographyToken.headline())
                
                Picker("Intent", selection: $selectedIntent) {
                    Text("None").tag(nil as Classification.KakeiboIntent?)
                    ForEach([Classification.KakeiboIntent.need, .want, .culture, .unexpected], id: \.self) { intent in
                        Text(intent.displayName).tag(intent as Classification.KakeiboIntent?)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedIntent) { _, newValue in
                    if let intent = newValue {
                        onIntentChange(intent)
                    }
                }
                .accessibilityLabel("Transaction intent")
                .accessibilityHint("Selects the kakeibo intent category")
                .accessibilityIdentifier("tagging_intent_picker")
            }
        }
    }
}

struct CategorySelectorSection: View {
    @Binding var selectedCategory: String?
    let categories: [String]
    let onCategoryChange: (String?) -> Void
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.sm) {
                Text("Category")
                    .font(TypographyToken.headline())
                
                Picker("Category", selection: $selectedCategory) {
                    Text("None").tag(nil as String?)
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category as String?)
                    }
                }
                .onChange(of: selectedCategory) { _, _ in
                    onCategoryChange(selectedCategory)
                }
                .accessibilityLabel("Transaction category")
                .accessibilityHint("Selects the spending category")
                .accessibilityIdentifier("tagging_category_picker")
            }
        }
    }
}

struct TagsEditorSection: View {
    @Binding var tags: Set<String>
    let availableTags: [String]
    let onTagsChange: () -> Void
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.sm) {
                Text("Tags")
                    .font(TypographyToken.headline())
                
                FlowLayout(spacing: SpacingToken.sm) {
                    ForEach(availableTags, id: \.self) { tag in
                        WellfinChip(
                            title: tag,
                            style: .selectable,
                            isSelected: Binding(
                                get: { tags.contains(tag) },
                                set: { isSelected in
                                    if isSelected {
                                        tags.insert(tag)
                                    } else {
                                        tags.remove(tag)
                                    }
                                    onTagsChange()
                                }
                            )
                        )
                    }
                }
                .accessibilityLabel("Transaction tags")
                .accessibilityHint("Add or remove tags to categorize this transaction")
                .accessibilityIdentifier("tagging_tags_editor")
            }
        }
    }
}

struct RulePreviewSection: View {
    let rulePreview: RulePreview
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                HStack {
                    Text("Rule Preview")
                        .font(TypographyToken.headline())
                    
                    Spacer()
                    
                    Image(systemName: "sparkles")
                        .foregroundStyle(ColorToken.primary)
                }
                
                VStack(alignment: .leading, spacing: SpacingToken.sm) {
                    Text(rulePreview.name)
                        .font(TypographyToken.body(weight: .semibold))
                    
                    Text("When:")
                        .font(TypographyToken.caption())
                        .foregroundStyle(.secondary)
                    
                    ForEach(rulePreview.conditions, id: \.self) { condition in
                        HStack(spacing: SpacingToken.xs) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(ColorToken.success)
                            Text(condition)
                                .font(TypographyToken.body())
                        }
                    }
                    
                    Text("Then:")
                        .font(TypographyToken.caption())
                        .foregroundStyle(.secondary)
                        .padding(.top, SpacingToken.xs)
                    
                    ForEach(rulePreview.actions, id: \.self) { action in
                        HStack(spacing: SpacingToken.xs) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.caption)
                                .foregroundStyle(ColorToken.primary)
                            Text(action)
                                .font(TypographyToken.body())
                        }
                    }
                }
            }
        }
        .accessibilityLabel("Rule preview: \(rulePreview.name)")
        .accessibilityHint("Shows how the current selections would create a tagging rule")
    }
}

struct ActionsSection: View {
    let onApply: () -> Void
    let onCreateRule: () -> Void
    
    var body: some View {
        VStack(spacing: SpacingToken.md) {
            WellfinButton(
                title: "Apply Tagging",
                variant: .primary,
                size: .large,
                action: onApply
            )
            .accessibilityIdentifier("tagging_apply_button")
            
            WellfinButton(
                title: "Create Rule",
                variant: .secondary,
                size: .large,
                action: onCreateRule
            )
            .accessibilityIdentifier("tagging_create_rule_button")
        }
    }
}

// MARK: - Supporting Types

struct RulePreview {
    let name: String
    let conditions: [String]
    let actions: [String]
}


#Preview("Tagging View") {
    NavigationStack {
        TaggingView()
            .environment(UserPreferences.shared)
    }
}

#Preview("Tagging Content") {
    NavigationStack {
        TaggingContentView(transactions: MockData.transactions.generate(count: 5))
            .environment(UserPreferences.shared)
    }
}

