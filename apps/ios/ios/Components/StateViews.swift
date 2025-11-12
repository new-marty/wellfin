//
//  StateViews.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Reusable state views for empty, loading, and error states

import SwiftUI

/// Empty state view with optional CTA
struct EmptyStateView: View {
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: SpacingToken.lg) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            VStack(spacing: SpacingToken.sm) {
                Text(title)
                    .font(TypographyToken.headline())
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(TypographyToken.body())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                WellfinButton(
                    title: actionTitle,
                    variant: .primary,
                    size: .medium,
                    action: action
                )
                .padding(.horizontal, SpacingToken.lg)
            }
        }
        .padding(SpacingToken.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}

/// Loading state view with skeleton or spinner
struct LoadingStateView: View {
    @Environment(UserPreferences.self) private var preferences
    
    var body: some View {
        VStack(spacing: SpacingToken.lg) {
            if preferences.reduceMotion {
                // Show skeleton instead of spinner when Reduce Motion is enabled
                VStack(spacing: SpacingToken.md) {
                    ForEach(0..<3) { _ in
                        HStack {
                            RoundedRectangle(cornerRadius: RadiusToken.card)
                                .fill(ColorToken.neutral200)
                                .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading, spacing: SpacingToken.xs) {
                                RoundedRectangle(cornerRadius: RadiusToken.chip)
                                    .fill(ColorToken.neutral200)
                                    .frame(height: 16)
                                RoundedRectangle(cornerRadius: RadiusToken.chip)
                                    .fill(ColorToken.neutral200)
                                    .frame(width: 120, height: 12)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, SpacingToken.sm)
                    }
                }
            } else {
                ProgressView()
                    .scaleEffect(1.2)
            }
            
            Text("Loading...")
                .font(TypographyToken.body())
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Loading")
    }
}

/// Error state view with retry action
struct ErrorStateView: View {
    let title: String
    let message: String
    var retryTitle: String = "Retry"
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: SpacingToken.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            
            VStack(spacing: SpacingToken.sm) {
                Text(title)
                    .font(TypographyToken.headline())
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(TypographyToken.body())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction = retryAction {
                WellfinButton(
                    title: retryTitle,
                    variant: .primary,
                    size: .medium,
                    action: retryAction
                )
                .padding(.horizontal, SpacingToken.lg)
            }
        }
        .padding(SpacingToken.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}

#Preview("Empty State") {
    EmptyStateView(
        title: "No Transactions",
        message: "You haven't made any transactions yet. Start by adding your first transaction.",
        actionTitle: "Add Transaction",
        action: {}
    )
}

#Preview("Loading State") {
    LoadingStateView()
        .environment(UserPreferences.shared)
}

#Preview("Error State") {
    ErrorStateView(
        title: "Unable to Load",
        message: "Something went wrong while loading your transactions. Please try again.",
        retryAction: {}
    )
}

