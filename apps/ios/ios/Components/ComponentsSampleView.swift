//
//  ComponentsSampleView.swift
//  wellfin
//
//  Sample view demonstrating all UI primitives
//

import SwiftUI

struct ComponentsSampleView: View {
    @State private var selectedChip = "Option 1"
    @State private var filterChips: Set<String> = ["Food"]
    @State private var progress: Double = 0.6
    
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingToken.xl) {
                // Buttons Section
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Buttons")
                            .font(TypographyToken.headline())
                        
                        VStack(spacing: SpacingToken.sm) {
                            WellfinButton(title: "Primary Button", variant: .primary, size: .medium) {}
                            WellfinButton(title: "Secondary Button", variant: .secondary, size: .medium) {}
                            WellfinButton(title: "Ghost Button", variant: .ghost, size: .medium) {}
                        }
                        
                        VStack(spacing: SpacingToken.sm) {
                            WellfinButton(title: "Loading", variant: .primary, size: .medium, isLoading: true) {}
                            WellfinButton(title: "Disabled", variant: .primary, size: .medium, isDisabled: true) {}
                        }
                    }
                }
                
                // Chips Section
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Chips")
                            .font(TypographyToken.headline())
                        
                        VStack(alignment: .leading, spacing: SpacingToken.sm) {
                            Text("Selectable")
                                .font(TypographyToken.footnote())
                                .foregroundColor(ColorToken.textSecondary)
                            HStack(spacing: SpacingToken.sm) {
                                WellfinChip(
                                    title: "Option 1",
                                    style: .selectable,
                                    isSelected: Binding(
                                        get: { selectedChip == "Option 1" },
                                        set: { if $0 { selectedChip = "Option 1" } }
                                    )
                                ) {}
                                WellfinChip(
                                    title: "Option 2",
                                    style: .selectable,
                                    isSelected: Binding(
                                        get: { selectedChip == "Option 2" },
                                        set: { if $0 { selectedChip = "Option 2" } }
                                    )
                                ) {}
                                WellfinChip(
                                    title: "Option 3",
                                    style: .selectable,
                                    isSelected: Binding(
                                        get: { selectedChip == "Option 3" },
                                        set: { if $0 { selectedChip = "Option 3" } }
                                    )
                                ) {}
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: SpacingToken.sm) {
                            Text("Filter")
                                .font(TypographyToken.footnote())
                                .foregroundColor(ColorToken.textSecondary)
                            HStack(spacing: SpacingToken.sm) {
                                WellfinChip(
                                    title: "Food",
                                    style: .filter,
                                    isSelected: Binding(
                                        get: { filterChips.contains("Food") },
                                        set: { if $0 { filterChips.insert("Food") } else { filterChips.remove("Food") } }
                                    )
                                ) {}
                                WellfinChip(
                                    title: "Transport",
                                    style: .filter,
                                    isSelected: Binding(
                                        get: { filterChips.contains("Transport") },
                                        set: { if $0 { filterChips.insert("Transport") } else { filterChips.remove("Transport") } }
                                    )
                                ) {}
                                WellfinChip(
                                    title: "Shopping",
                                    style: .filter,
                                    isSelected: Binding(
                                        get: { filterChips.contains("Shopping") },
                                        set: { if $0 { filterChips.insert("Shopping") } else { filterChips.remove("Shopping") } }
                                    )
                                ) {}
                            }
                        }
                    }
                }
                
                // Badges Section
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Badges")
                            .font(TypographyToken.headline())
                        
                        HStack(spacing: SpacingToken.sm) {
                            WellfinBadge("Primary")
                            WellfinBadge("Success", variant: .success)
                            WellfinBadge("Warning", variant: .warning)
                            WellfinBadge("Danger", variant: .danger)
                            WellfinBadge("Neutral", variant: .neutral)
                        }
                        
                        HStack(spacing: SpacingToken.sm) {
                            WellfinBadge("Small", size: .small)
                            WellfinBadge("Medium", size: .medium)
                        }
                    }
                }
                
                // Progress Rings Section
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Progress Rings")
                            .font(TypographyToken.headline())
                        
                        HStack(spacing: SpacingToken.lg) {
                            WellfinProgressRing(progress: 0.25, showPercentage: true)
                                .frame(width: 80, height: 80)
                            
                            WellfinProgressRing(progress: 0.5, color: ColorToken.success, showPercentage: true)
                                .frame(width: 80, height: 80)
                            
                            WellfinProgressRing(progress: 0.75, color: ColorToken.warning, showPercentage: true)
                                .frame(width: 80, height: 80)
                        }
                    }
                }
                
                // List Rows Section
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("List Rows")
                            .font(TypographyToken.headline())
                        
                        VStack(spacing: 0) {
                            WellfinListRow(title: "Simple Row") {}
                            
                            Divider()
                                .padding(.leading, SpacingToken.lg)
                            
                            WellfinListRow(title: "Row with Trailing") {
                                Image(systemName: "chevron.right")
                                    .font(.system(.footnote))
                                    .foregroundColor(ColorToken.textSubtle)
                            } action: {}
                            
                            Divider()
                                .padding(.leading, SpacingToken.lg)
                            
                            WellfinListRow {
                                VStack(alignment: .leading, spacing: SpacingToken.xs) {
                                    Text("Transaction")
                                        .font(TypographyToken.body(weight: .semibold))
                                    Text("Coffee Shop")
                                        .font(TypographyToken.footnote())
                                        .foregroundColor(ColorToken.textSecondary)
                                }
                            } trailing: {
                                VStack(alignment: .trailing, spacing: SpacingToken.xs) {
                                    Text("$12.50")
                                        .font(TypographyToken.body(weight: .semibold))
                                    WellfinBadge("Need", variant: .primary, size: .small)
                                }
                            } action: {}
                        }
                    }
                }
            }
            .padding(SpacingToken.lg)
        }
        .background(ColorToken.background)
    }
}

#Preview {
    ComponentsSampleView()
}


