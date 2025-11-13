//
//  AppearanceTestView.swift
//  wellfin
//
//  Test view to verify light/dark mode switching and Dynamic Type
//  This view demonstrates that global appearance configuration works correctly
//

import SwiftUI

struct AppearanceTestView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingToken.lg) {
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
                            
                            Text("Toggle in iOS Settings > Display & Brightness to verify appearance updates")
                                .font(TypographyToken.body())
                                .foregroundColor(ColorToken.textSecondary)
                        }
                    }
                    
                    // System Colors Test
                    WellfinCard {
                        VStack(alignment: .leading, spacing: SpacingToken.md) {
                            Text("System Colors")
                                .font(TypographyToken.headline())
                            
                            VStack(alignment: .leading, spacing: SpacingToken.sm) {
                                ColorTestRow(label: "Background", color: ColorToken.background)
                                ColorTestRow(label: "Text", color: ColorToken.text)
                                ColorTestRow(label: "Text Secondary", color: ColorToken.textSecondary)
                                ColorTestRow(label: "Primary (Accent)", color: ColorToken.primary)
                                ColorTestRow(label: "Border", color: ColorToken.border)
                            }
                        }
                    }
                    
                    // Dynamic Type Test
                    WellfinCard {
                        VStack(alignment: .leading, spacing: SpacingToken.md) {
                            Text("Dynamic Type")
                                .font(TypographyToken.headline())
                            
                            Text("This text scales with your text size preference")
                                .font(TypographyToken.body())
                            
                            Text("Large Title")
                                .font(TypographyToken.largeTitle())
                            
                            Text("Title")
                                .font(TypographyToken.title())
                            
                            Text("Body")
                                .font(TypographyToken.body())
                            
                            Text("Caption")
                                .font(TypographyToken.caption())
                        }
                    }
                    
                    // SF Symbols Test
                    WellfinCard {
                        VStack(alignment: .leading, spacing: SpacingToken.md) {
                            Text("SF Symbols")
                                .font(TypographyToken.headline())
                            
                            HStack(spacing: SpacingToken.lg) {
                                Image(systemName: "house.fill")
                                    .font(.system(.largeTitle))
                                
                                Image(systemName: "heart.fill")
                                    .font(.system(.title))
                                
                                Image(systemName: "star.fill")
                                    .font(.system(.body))
                            }
                            .foregroundColor(ColorToken.primary)
                            
                            Text("Symbols scale with Dynamic Type")
                                .font(TypographyToken.footnote())
                                .foregroundColor(ColorToken.textSecondary)
                        }
                    }
                }
                .padding(SpacingToken.lg)
            }
            .background(ColorToken.background)
            .navigationTitle("Appearance Test")
        }
    }
}

struct ColorTestRow: View {
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
    AppearanceTestView()
        .previewAppearance(colorScheme: .light)
}

#Preview("Dark Mode") {
    AppearanceTestView()
        .previewAppearance(colorScheme: .dark)
}

#Preview("Large Text") {
    AppearanceTestView()
        .previewAppearance(sizeCategory: .accessibilityExtraExtraExtraLarge)
}




