//
//  SuggestionsListView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Suggestions list/cards component with impact badges and timers

import SwiftUI

struct SuggestionsListView: View {
    let suggestions: [Suggestion]
    @Environment(UserPreferences.self) private var preferences
    @State private var selectedSuggestion: Suggestion? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingToken.md) {
            Text("Suggestions")
                .font(TypographyToken.headline())
                .padding(.horizontal, SpacingToken.lg)
            
            if suggestions.isEmpty {
                EmptyStateView(
                    title: "No Suggestions",
                    message: "We'll suggest actions to help you manage your finances better.",
                    actionTitle: nil,
                    action: nil
                )
                .frame(height: 200)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SpacingToken.md) {
                        ForEach(suggestions.prefix(3)) { suggestion in
                            SuggestionCard(suggestion: suggestion) {
                                selectedSuggestion = suggestion
                            }
                        }
                    }
                    .padding(.horizontal, SpacingToken.lg)
                }
            }
        }
        .sheet(item: $selectedSuggestion) { suggestion in
            SuggestionDetailSheet(suggestion: suggestion)
        }
    }
}

struct SuggestionCard: View {
    let suggestion: Suggestion
    let onTap: () -> Void
    @Environment(UserPreferences.self) private var preferences
    @State private var timeRemaining: TimeInterval? = nil
    
    var body: some View {
        WellfinCard {
            VStack(alignment: .leading, spacing: SpacingToken.md) {
                // Title
                Text(suggestionTitle)
                    .font(TypographyToken.headline())
                    .lineLimit(2)
                
                // Impact badge
                HStack {
                    WellfinBadge(
                        text: suggestion.expectedImpact,
                        variant: .info
                    )
                }
                
                // Timer/expiry indicator
                if let expiresAt = suggestion.expiresAt {
                    HStack(spacing: SpacingToken.xs) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(timeRemainingText(expiresAt))
                            .font(TypographyToken.caption())
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(width: 280)
            .padding(SpacingToken.lg)
        }
        .onTapGesture(perform: onTap)
        .onAppear {
            updateTimer()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateTimer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(suggestionTitle). Impact: \(suggestion.expectedImpact)")
        .accessibilityHint("Double tap to view details")
    }
    
    private var suggestionTitle: String {
        switch suggestion.type {
        case .moveToSavings:
            return "Move to Savings"
        case .adjustBudget:
            return "Adjust Budget"
        case .reviewSubscription:
            return "Review Subscription"
        case .categorizeTransaction:
            return "Categorize Transaction"
        case .createRule:
            return "Create Rule"
        case .other:
            return suggestion.inputs["message"] ?? "Suggestion"
        }
    }
    
    private func timeRemainingText(_ expiresAt: Date) -> String {
        let remaining = expiresAt.timeIntervalSinceNow
        if remaining <= 0 {
            return "Expired"
        }
        
        let hours = Int(remaining) / 3600
        let days = hours / 24
        
        if days > 0 {
            return "\(days)d remaining"
        } else if hours > 0 {
            return "\(hours)h remaining"
        } else {
            let minutes = Int(remaining) / 60
            return "\(minutes)m remaining"
        }
    }
    
    private func updateTimer() {
        // Update timer discretely (no animation when Reduce Motion is enabled)
        if preferences.reduceMotion {
            // Skip timer updates to avoid animation
            return
        }
    }
}

struct SuggestionDetailSheet: View {
    let suggestion: Suggestion
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SpacingToken.lg) {
                    Text(suggestionTitle)
                        .font(TypographyToken.title())
                    
                    WellfinBadge(
                        text: suggestion.expectedImpact,
                        variant: .info
                    )
                    
                    Text("Details")
                        .font(TypographyToken.headline())
                    
                    ForEach(Array(suggestion.inputs.keys.sorted()), id: \.self) { key in
                        VStack(alignment: .leading, spacing: SpacingToken.xs) {
                            Text(key.capitalized)
                                .font(TypographyToken.caption())
                                .foregroundStyle(.secondary)
                            Text(suggestion.inputs[key] ?? "")
                                .font(TypographyToken.body())
                        }
                    }
                    
                    WellfinButton(
                        title: "Apply Suggestion",
                        variant: .primary,
                        size: .medium,
                        action: {
                            // Stub - no engine wiring
                            dismiss()
                        }
                    )
                }
                .padding(SpacingToken.lg)
            }
            .navigationTitle("Suggestion Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var suggestionTitle: String {
        switch suggestion.type {
        case .moveToSavings:
            return "Move to Savings"
        case .adjustBudget:
            return "Adjust Budget"
        case .reviewSubscription:
            return "Review Subscription"
        case .categorizeTransaction:
            return "Categorize Transaction"
        case .createRule:
            return "Create Rule"
        case .other:
            return suggestion.inputs["message"] ?? "Suggestion"
        }
    }
}

#Preview("Suggestions List") {
    SuggestionsListView(suggestions: MockData.suggestions.generatePending(count: 3))
        .environment(UserPreferences.shared)
}

