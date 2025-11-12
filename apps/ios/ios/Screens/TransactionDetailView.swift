//
//  TransactionDetailView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Transaction detail view with summary, editable fields, splits, and history

import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @State private var selectedIntent: Classification.KakeiboIntent? = nil
    @State private var selectedCategory: String? = nil
    @State private var tags: Set<String> = []
    @State private var notes: String = ""
    @State private var splits: [TransactionSplit] = []
    @State private var history: [TransactionHistoryEvent] = []
    @State private var showUndo = false
    @State private var lastAction: String? = nil
    @Environment(UserPreferences.self) private var preferences
    #if DEBUG
    @State private var undoManager = UndoManager.shared
    #endif
    
    // Store previous values for undo
    private var previousIntent: Classification.KakeiboIntent? = nil
    private var previousCategory: String? = nil
    private var previousTags: Set<String> = []
    private var previousNotes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingToken.xl) {
                // Summary Header
                TransactionSummaryHeader(transaction: transaction)
                
                // Editable Fields
                TransactionEditableFields(
                    selectedIntent: $selectedIntent,
                    selectedCategory: $selectedCategory,
                    tags: $tags,
                    notes: $notes,
                    onIntentChange: { newIntent in
                        let oldIntent = selectedIntent
                        selectedIntent = newIntent
                        saveChange("Intent changed to \(newIntent.displayName)") {
                            selectedIntent = oldIntent
                        }
                    },
                    onCategoryChange: { newCategory in
                        let oldCategory = selectedCategory
                        selectedCategory = newCategory
                        saveChange("Category changed to \(newCategory ?? "None")") {
                            selectedCategory = oldCategory
                        }
                    },
                    onTagsChange: {
                        let oldTags = tags
                        saveChange("Tags updated") {
                            tags = oldTags
                        }
                    },
                    onNotesChange: {
                        let oldNotes = notes
                        saveChange("Notes updated") {
                            notes = oldNotes
                        }
                    }
                )
                
                // Splits
                TransactionSplitsSection(
                    splits: $splits,
                    totalAmount: transaction.amount,
                    onSplitChange: { saveChange("Split updated") }
                )
                
                // History
                TransactionHistorySection(history: history)
            }
            .padding(SpacingToken.lg)
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            if showUndo {
                UndoBanner(
                    message: lastAction ?? "Change made",
                    onUndo: {
                        undoLastChange()
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(preferences.reduceMotion ? nil : .easeInOut(duration: 0.2), value: showUndo)
        .onAppear {
            loadTransactionData()
        }
    }
    
    private func loadTransactionData() {
        // Load mock data
        tags = ["Home", "Recurring"]
        notes = ""
        splits = []
        history = [
            TransactionHistoryEvent(
                action: "Created",
                timestamp: transaction.postedAt,
                details: "Transaction imported"
            )
        ]
    }
    
    private func saveChange(_ action: String, undoAction: @escaping () -> Void) {
        lastAction = action
        showUndo = true
        
        #if DEBUG
        // Register undo action
        undoManager.register(UndoableAction(description: action) {
            undoAction()
            self.showUndo = false
            if !self.history.isEmpty {
                self.history.removeFirst()
            }
        })
        #endif
        
        // Add to history
        history.insert(
            TransactionHistoryEvent(
                action: action,
                timestamp: Date(),
                details: action
            ),
            at: 0
        )
        
        // Auto-hide undo banner (respect Reduce Motion)
        let animationDuration = preferences.reduceMotion ? 0 : 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                showUndo = false
            }
        }
    }
    
    private func undoLastChange() {
        #if DEBUG
        if undoManager.undo() {
            showUndo = false
        }
        #else
        showUndo = false
        if !history.isEmpty {
            history.removeFirst()
        }
        #endif
    }
}

struct TransactionSummaryHeader: View {
    let transaction: Transaction
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                Text(transaction.merchant ?? "Unknown")
                    .font(TypographyToken.title())
                
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Transaction: \(transaction.merchant ?? "Unknown"), \(CurrencyFormatter.format(transaction.amount, currencyCode: transaction.currency))")
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

struct TransactionEditableFields: View {
    @Binding var selectedIntent: Classification.KakeiboIntent?
    @Binding var selectedCategory: String?
    @Binding var tags: Set<String>
    @Binding var notes: String
    let onIntentChange: (Classification.KakeiboIntent) -> Void
    let onCategoryChange: (String?) -> Void
    let onTagsChange: () -> Void
    let onNotesChange: () -> Void
    
    private let categories = ["Groceries", "Dining", "Transport", "Shopping", "Entertainment", "Bills", "Rent"]
    private let availableTags = ["Home", "Work", "Travel", "Tax", "Refund", "Subscription", "Recurring"]
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.lg) {
                // Intent Selector
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
                    .accessibilityHint("Selects the kakeibo intent category for this transaction")
                    .accessibilityIdentifier("transaction_intent_picker")
                }
                
                // Category Selector
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
                    .accessibilityHint("Selects the spending category for this transaction")
                    .accessibilityIdentifier("transaction_category_picker")
                }
                
                // Tags Editor
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
                    .accessibilityIdentifier("transaction_tags_editor")
                }
                
                // Notes Editor
                VStack(alignment: .leading, spacing: SpacingToken.sm) {
                    Text("Notes")
                        .font(TypographyToken.headline())
                    
                    TextField("Add notes...", text: $notes, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding(SpacingToken.sm)
                        .background(ColorToken.neutral100)
                        .cornerRadius(RadiusToken.card)
                        .onChange(of: notes) { _, _ in
                            onNotesChange()
                        }
                        .accessibilityLabel("Transaction notes")
                        .accessibilityHint("Add notes or comments about this transaction")
                        .accessibilityIdentifier("transaction_notes_field")
                }
            }
        }
    }
}

struct TransactionSplitsSection: View {
    @Binding var splits: [TransactionSplit]
    let totalAmount: Decimal
    let onSplitChange: () -> Void
    
    @State private var showAddSplit = false
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                HStack {
                    Text("Splits")
                        .font(TypographyToken.headline())
                    Spacer()
                    Button(action: { showAddSplit = true }) {
                        Label("Add Split", systemImage: "plus")
                    }
                }
                
                if splits.isEmpty {
                    Text("No splits")
                        .font(TypographyToken.body())
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(splits.enumerated()), id: \.offset) { index, split in
                        HStack {
                            Text(split.displayText)
                                .font(TypographyToken.body())
                            Spacer()
                            Text(CurrencyFormatter.format(split.amount, currencyCode: "JPY"))
                                .font(TypographyToken.body())
                                .font(.body.monospacedDigit())
                            
                            Button(action: {
                                splits.remove(at: index)
                                onSplitChange()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(TypographyToken.headline())
                        Spacer()
                        Text(CurrencyFormatter.format(splitsTotal, currencyCode: "JPY"))
                            .font(TypographyToken.headline())
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(splitsTotal == totalAmount ? .primary : .red)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSplit) {
            AddSplitSheet(
                totalAmount: totalAmount,
                existingSplits: splits,
                onAdd: { split in
                    splits.append(split)
                    onSplitChange()
                }
            )
        }
    }
    
    private var splitsTotal: Decimal {
        splits.reduce(0) { $0 + $1.amount }
    }
}

struct TransactionHistorySection: View {
    let history: [TransactionHistoryEvent]
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                Text("History")
                    .font(TypographyToken.headline())
                
                if history.isEmpty {
                    Text("No history")
                        .font(TypographyToken.body())
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(history) { event in
                        VStack(alignment: .leading, spacing: SpacingToken.xs) {
                            Text(event.action)
                                .font(TypographyToken.body())
                            Text(WellfinDateFormatter.format(event.timestamp))
                                .font(TypographyToken.caption())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct TransactionSplit: Identifiable {
    let id = UUID()
    let description: String
    let amount: Decimal
    
    var displayText: String {
        "\(description): \(CurrencyFormatter.format(amount, currencyCode: "JPY"))"
    }
}

struct TransactionHistoryEvent: Identifiable {
    let id = UUID()
    let action: String
    let timestamp: Date
    let details: String
}

struct AddSplitSheet: View {
    let totalAmount: Decimal
    let existingSplits: [TransactionSplit]
    @Environment(\.dismiss) private var dismiss
    
    @State private var description = ""
    @State private var amount: Decimal = 0
    
    var remainingAmount: Decimal {
        let existingTotal = existingSplits.reduce(0) { $0 + $1.amount }
        return totalAmount - existingTotal
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Description", text: $description)
                TextField("Amount", value: $amount, format: .number)
                
                Text("Remaining: \(CurrencyFormatter.format(remainingAmount, currencyCode: "JPY"))")
                    .font(TypographyToken.caption())
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Add Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        // Validation stub
                        dismiss()
                    }
                    .disabled(description.isEmpty || amount <= 0)
                }
            }
        }
    }
}

// MARK: - Flow Layout Helper

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview("Transaction Detail") {
    NavigationStack {
        TransactionDetailView(transaction: MockData.transactions.generate())
            .environment(UserPreferences.shared)
    }
}

