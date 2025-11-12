//
//  DesignTokensSampleView.swift
//  wellfin
//
//  Sample screen demonstrating design tokens in use
//

import SwiftUI

struct DesignTokensSampleView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingToken.lg) {
                // Typography examples
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Typography")
                        .font(TypographyToken.headline())
                        .foregroundColor(ColorToken.text)
                    
                    Text("Large Title")
                        .font(TypographyToken.largeTitle())
                    Text("Title")
                        .font(TypographyToken.title())
                    Text("Headline")
                        .font(TypographyToken.headline())
                    Text("Body")
                        .font(TypographyToken.body())
                    Text("Footnote")
                        .font(TypographyToken.footnote())
                    Text("Caption")
                        .font(TypographyToken.caption())
                    
                    // Tabular numbers example
                    Text("$1,234.56")
                        .font(TypographyToken.tabularNumbers(TypographyToken.body(weight: .semibold)))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpacingToken.lg)
                .background(ColorToken.surface)
                .cardRadius()
                .elevation(.raised)
                
                // Color examples
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Colors")
                        .font(TypographyToken.headline())
                    
                    HStack(spacing: SpacingToken.md) {
                        ColorSwatch(color: ColorToken.primary, name: "Primary")
                        ColorSwatch(color: ColorToken.success, name: "Success")
                        ColorSwatch(color: ColorToken.warning, name: "Warning")
                        ColorSwatch(color: ColorToken.danger, name: "Danger")
                    }
                    
                    HStack(spacing: SpacingToken.md) {
                        ColorSwatch(color: ColorToken.text, name: "Text")
                        ColorSwatch(color: ColorToken.textSecondary, name: "Secondary")
                        ColorSwatch(color: ColorToken.textSubtle, name: "Subtle")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpacingToken.lg)
                .background(ColorToken.surface)
                .cardRadius()
                .elevation(.raised)
                
                // Spacing examples
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Spacing")
                        .font(TypographyToken.headline())
                    
                    SpacingExample(size: SpacingToken.xs, name: "XS (4)")
                    SpacingExample(size: SpacingToken.sm, name: "SM (8)")
                    SpacingExample(size: SpacingToken.md, name: "MD (12)")
                    SpacingExample(size: SpacingToken.lg, name: "LG (16)")
                    SpacingExample(size: SpacingToken.xl, name: "XL (20)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpacingToken.lg)
                .background(ColorToken.surface)
                .cardRadius()
                .elevation(.raised)
                
                // Radius examples
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Radius")
                        .font(TypographyToken.headline())
                    
                    HStack(spacing: SpacingToken.lg) {
                        RadiusExample(radius: RadiusToken.chip, name: "Chip")
                        RadiusExample(radius: RadiusToken.card, name: "Card")
                        RadiusExample(radius: RadiusToken.modal, name: "Modal")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpacingToken.lg)
                .background(ColorToken.surface)
                .cardRadius()
                .elevation(.raised)
                
                // Elevation examples
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Elevation")
                        .font(TypographyToken.headline())
                    
                    ElevationExample(level: .none, name: "None")
                    ElevationExample(level: .raised, name: "Raised")
                    ElevationExample(level: .overlay, name: "Overlay")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpacingToken.lg)
            }
            .padding(SpacingToken.lg)
        }
        .background(ColorToken.background)
    }
}

struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingToken.xs) {
            RoundedRectangle(cornerRadius: RadiusToken.card)
                .fill(color)
                .frame(width: 60, height: 60)
            Text(name)
                .font(TypographyToken.caption())
                .foregroundStyle(ColorToken.textSecondary)
        }
    }
}

struct SpacingExample: View {
    let size: CGFloat
    let name: String
    
    var body: some View {
        HStack(spacing: SpacingToken.sm) {
            Text(name)
                .font(TypographyToken.caption())
                .frame(width: 80, alignment: .leading)
            Rectangle()
                .fill(ColorToken.primary)
                .frame(width: size, height: 20)
        }
    }
}

struct RadiusExample: View {
    let radius: CGFloat
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingToken.xs) {
            RoundedRectangle(cornerRadius: radius)
                .fill(ColorToken.primary.opacity(0.3))
                .frame(width: 60, height: 60)
            Text(name)
                .font(TypographyToken.caption())
                .foregroundStyle(ColorToken.text)
        }
    }
}

struct ElevationExample: View {
    let level: ElevationToken
    let name: String
    
    var body: some View {
        HStack(spacing: SpacingToken.sm) {
            Text(name)
                .font(TypographyToken.caption())
                .frame(width: 80, alignment: .leading)
            RoundedRectangle(cornerRadius: RadiusToken.card)
                .fill(ColorToken.surface)
                .frame(height: 40)
                .elevation(level)
        }
    }
}

#Preview {
    DesignTokensSampleView()
}

