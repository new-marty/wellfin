//
//  MoneyRingsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Money Rings component for spending composition visualization

import SwiftUI

struct MoneyRingsView: View {
    let data: [(category: String, amount: Decimal, color: Color)]
    @Environment(UserPreferences.self) private var preferences
    @State private var showTable = false
    
    private var totalAmount: Decimal {
        data.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        WellfinCard {
            VStack(spacing: SpacingToken.lg) {
                HStack {
                    Text("Spending by Category")
                        .font(TypographyToken.headline())
                    Spacer()
                    Button(action: { showTable.toggle() }) {
                        Image(systemName: showTable ? "chart.pie.fill" : "tablecells")
                            .foregroundStyle(ColorToken.primary)
                    }
                    .accessibilityLabel(showTable ? "Show chart view" : "Show table view")
                }
                
                if showTable {
                    // Table alternative for accessibility (NM-24)
                    MoneyRingsTableView(data: data, totalAmount: totalAmount)
                } else {
                    // Ring visualization
                    MoneyRingsChartView(data: data, totalAmount: totalAmount)
                }
            }
            .padding(SpacingToken.lg)
        }
    }
}

struct MoneyRingsChartView: View {
    let data: [(category: String, amount: Decimal, color: Color)]
    let totalAmount: Decimal
    @Environment(UserPreferences.self) private var preferences
    
    var body: some View {
        VStack(spacing: SpacingToken.lg) {
            ZStack {
                // Draw rings
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    let previousProgress = data.prefix(index).reduce(0.0) { $0 + Double(truncating: ($1.amount / totalAmount) as NSDecimalNumber) }
                    let currentProgress = Double(truncating: (item.amount / totalAmount) as NSDecimalNumber)
                    
                    WellfinProgressRing(
                        progress: previousProgress + currentProgress,
                        lineWidth: 20,
                        color: item.color
                    )
                    .frame(width: 200, height: 200)
                }
            }
            
            // Legend
            VStack(alignment: .leading, spacing: SpacingToken.sm) {
                ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)
                        Text(item.category)
                            .font(TypographyToken.body())
                        Spacer()
                        Text(CurrencyFormatter.format(item.amount, currencyCode: "JPY"))
                            .font(TypographyToken.body())
                            .font(.body.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Spending breakdown: \(data.map { "\($0.category): \(CurrencyFormatter.format($0.amount, currencyCode: "JPY"))" }.joined(separator: ", "))")
    }
}

struct MoneyRingsTableView: View {
    let data: [(category: String, amount: Decimal, color: Color)]
    let totalAmount: Decimal
    
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingToken.md) {
            ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                VStack(alignment: .leading, spacing: SpacingToken.xs) {
                    HStack {
                        Text(item.category)
                            .font(TypographyToken.headline())
                        Spacer()
                        Text(CurrencyFormatter.format(item.amount, currencyCode: "JPY"))
                            .font(TypographyToken.body())
                            .font(.body.monospacedDigit())
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(ColorToken.neutral200)
                                .frame(height: 8)
                            
                            Rectangle()
                                .fill(item.color)
                                .frame(
                                    width: geometry.size.width * CGFloat(truncating: (item.amount / totalAmount) as NSDecimalNumber),
                                    height: 8
                                )
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Money Rings") {
    MoneyRingsView(data: [
        ("Groceries", 45000, .green),
        ("Dining", 32000, .blue),
        ("Transport", 28000, .purple),
        ("Shopping", 20000, .orange)
    ])
    .environment(UserPreferences.shared)
    .padding()
}

