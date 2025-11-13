//
//  STSHeaderView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Safe-to-Spend header component with breakdown sheet

import SwiftUI

struct STSHeaderView: View {
    let value: Decimal
    let onTap: () -> Void
    @Environment(UserPreferences.self) private var preferences
    
    var body: some View {
        WellfinCard {
            VStack(spacing: SpacingToken.md) {
                Text("Safe-to-Spend")
                    .font(TypographyToken.headline())
                    .foregroundStyle(.secondary)
                
                Button(action: onTap) {
                    Text(CurrencyFormatter.format(value, currencyCode: "JPY"))
                        .font(TypographyToken.largeTitle(weight: .bold))
                        .font(.system(.largeTitle, design: .default, weight: .bold).monospacedDigit())
                        .foregroundStyle(ColorToken.primary)
                }
                .accessibilityLabel("Safe-to-Spend: \(CurrencyFormatter.format(value, currencyCode: "JPY"))")
                .accessibilityHint("Tap to view breakdown")
                
                Text("Tap to view breakdown")
                    .font(TypographyToken.caption())
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(SpacingToken.lg)
        }
    }
}

struct STSBreakdownSheet: View {
    let stsValue: Decimal
    @Environment(\.dismiss) private var dismiss
    @Environment(UserPreferences.self) private var preferences
    
    // Mock assumptions - placeholders
    @State private var monthlyIncome: Decimal = 500000
    @State private var monthlyExpenses: Decimal = 375000
    @State private var savingsGoal: Decimal = 100000
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Current Value") {
                    HStack {
                        Text("Safe-to-Spend")
                        Spacer()
                        Text(CurrencyFormatter.format(stsValue, currencyCode: "JPY"))
                            .font(.body.monospacedDigit())
                            .foregroundStyle(ColorToken.primary)
                    }
                }
                
                Section("Assumptions") {
                    VStack(alignment: .leading, spacing: SpacingToken.sm) {
                        Text("Monthly Income")
                            .font(TypographyToken.caption())
                            .foregroundStyle(.secondary)
                        Text(CurrencyFormatter.format(monthlyIncome, currencyCode: "JPY"))
                            .font(TypographyToken.body())
                            .font(.body.monospacedDigit())
                    }
                    
                    VStack(alignment: .leading, spacing: SpacingToken.sm) {
                        Text("Monthly Expenses")
                            .font(TypographyToken.caption())
                            .foregroundStyle(.secondary)
                        Text(CurrencyFormatter.format(monthlyExpenses, currencyCode: "JPY"))
                            .font(TypographyToken.body())
                            .font(.body.monospacedDigit())
                    }
                    
                    VStack(alignment: .leading, spacing: SpacingToken.sm) {
                        Text("Savings Goal")
                            .font(TypographyToken.caption())
                            .foregroundStyle(.secondary)
                        Text(CurrencyFormatter.format(savingsGoal, currencyCode: "JPY"))
                            .font(TypographyToken.body())
                            .font(.body.monospacedDigit())
                    }
                }
                
                Section {
                    Text("Adjust assumptions (placeholder)")
                        .font(TypographyToken.caption())
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("STS Breakdown")
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
}

#Preview("STS Header") {
    VStack {
        STSHeaderView(value: 125000, onTap: {})
            .environment(UserPreferences.shared)
    }
    .padding()
}

#Preview("STS Breakdown Sheet") {
    STSBreakdownSheet(stsValue: 125000)
        .environment(UserPreferences.shared)
}


