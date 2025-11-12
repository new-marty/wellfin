//
//  ThemingSampleView.swift
//  wellfin
//
//  Sample view demonstrating native theming (light/dark, Dynamic Type, SF Symbols)
//

import SwiftUI

struct ThemingSampleView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingToken.xl) {
                // Color Scheme Indicator
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        HStack {
                            Image(systemName: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                                .font(.system(.title2))
                                .foregroundColor(ColorToken.primary)
                            
                            Text("Current Mode: \(colorScheme == .dark ? "Dark" : "Light")")
                                .font(TypographyToken.headline())
                        }
                        
                        Text("This view adapts to system appearance settings.")
                            .font(TypographyToken.body())
                            .foregroundColor(ColorToken.textSecondary)
                    }
                }
                
                // System Colors Demo
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("System Colors")
                            .font(TypographyToken.headline())
                        
                        VStack(alignment: .leading, spacing: SpacingToken.sm) {
                            ColorRow(label: "Background", color: ColorToken.background)
                            ColorRow(label: "Surface", color: ColorToken.surface)
                            ColorRow(label: "Text", color: ColorToken.text)
                            ColorRow(label: "Text Secondary", color: ColorToken.textSecondary)
                            ColorRow(label: "Border", color: ColorToken.border)
                            ColorRow(label: "Primary (Accent)", color: ColorToken.primary)
                        }
                    }
                }
                
                // Dynamic Type Demo
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Dynamic Type")
                            .font(TypographyToken.headline())
                        
                        VStack(alignment: .leading, spacing: SpacingToken.sm) {
                            Text("Large Title")
                                .font(TypographyToken.largeTitle())
                            
                            Text("Title")
                                .font(TypographyToken.title())
                            
                            Text("Headline")
                                .font(TypographyToken.headline())
                            
                            Text("Body")
                                .font(TypographyToken.body())
                            
                            Text("Caption")
                                .font(TypographyToken.caption())
                        }
                    }
                }
                
                // SF Symbols Demo
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("SF Symbols (Scalable)")
                            .font(TypographyToken.headline())
                        
                        HStack(spacing: SpacingToken.lg) {
                            VStack(spacing: SpacingToken.xs) {
                                Image(systemName: "house.fill")
                                    .font(.system(.largeTitle))
                                Text("Large Title")
                                    .font(TypographyToken.caption2())
                            }
                            
                            VStack(spacing: SpacingToken.xs) {
                                Image(systemName: "heart.fill")
                                    .font(.system(.title))
                                Text("Title")
                                    .font(TypographyToken.caption2())
                            }
                            
                            VStack(spacing: SpacingToken.xs) {
                                Image(systemName: "star.fill")
                                    .font(.system(.body))
                                Text("Body")
                                    .font(TypographyToken.caption2())
                            }
                            
                            VStack(spacing: SpacingToken.xs) {
                                Image(systemName: "bell.fill")
                                    .font(.system(.caption))
                                Text("Caption")
                                    .font(TypographyToken.caption2())
                            }
                        }
                        .foregroundColor(ColorToken.primary)
                        
                        Text("All symbols scale with Dynamic Type")
                            .font(TypographyToken.footnote())
                            .foregroundColor(ColorToken.textSecondary)
                    }
                }
                
                // Component Examples
                WellfinCard {
                    VStack(alignment: .leading, spacing: SpacingToken.md) {
                        Text("Components")
                            .font(TypographyToken.headline())
                        
                        VStack(spacing: SpacingToken.sm) {
                            WellfinButton(title: "Primary Button", variant: .primary, size: .medium) {}
                            WellfinButton(title: "Secondary Button", variant: .secondary, size: .medium) {}
                            
                            HStack(spacing: SpacingToken.sm) {
                                WellfinBadge("Primary")
                                WellfinBadge("Success", variant: .success)
                                WellfinBadge("Warning", variant: .warning)
                            }
                        }
                    }
                }
            }
            .padding(SpacingToken.lg)
        }
        .background(ColorToken.background)
    }
}

struct ColorRow: View {
    let label: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(TypographyToken.body())
            
            Spacer()
            
            RoundedRectangle(cornerRadius: RadiusToken.chip)
                .fill(color)
                .frame(width: 60, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusToken.chip)
                        .stroke(ColorToken.border, lineWidth: 1)
                )
        }
    }
}

#Preview("Light Mode") {
    ThemingSampleView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ThemingSampleView()
        .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    ThemingSampleView()
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}



