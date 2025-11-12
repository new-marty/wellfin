//
//  Button.swift
//  wellfin
//
//  Button primitive with primary/secondary/ghost variants
//

import SwiftUI

enum ButtonVariant {
    case primary
    case secondary
    case ghost
}

enum ButtonSize {
    case small
    case medium
    case large
    
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: SpacingToken.xs, leading: SpacingToken.sm, bottom: SpacingToken.xs, trailing: SpacingToken.sm)
        case .medium:
            return EdgeInsets(top: SpacingToken.sm, leading: SpacingToken.md, bottom: SpacingToken.sm, trailing: SpacingToken.md)
        case .large:
            return EdgeInsets(top: SpacingToken.md, leading: SpacingToken.lg, bottom: SpacingToken.md, trailing: SpacingToken.lg)
        }
    }
    
    var font: Font {
        switch self {
        case .small:
            return TypographyToken.footnote(weight: .semibold)
        case .medium:
            return TypographyToken.body(weight: .semibold)
        case .large:
            return TypographyToken.headline()
        }
    }
}

struct WellfinButton: View {
    let title: String
    let variant: ButtonVariant
    let size: ButtonSize
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: SpacingToken.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(size.font)
            }
            .frame(maxWidth: .infinity)
            .padding(size.padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: RadiusToken.card)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(RadiusToken.card)
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
        .accessibilityLabel(title)
        .accessibilityHint(isDisabled ? "Button disabled" : isLoading ? "Loading" : "")
        .accessibilityAddTraits(.isButton)
    }
    
    private var backgroundColor: Color {
        if isDisabled || isLoading {
            switch variant {
            case .primary:
                return ColorToken.neutral300
            case .secondary, .ghost:
                return Color.clear
            }
        }
        
        switch variant {
        case .primary:
            return ColorToken.primary
        case .secondary:
            return ColorToken.surface
        case .ghost:
            return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        if isDisabled || isLoading {
            return ColorToken.textSubtle
        }
        
        switch variant {
        case .primary:
            return .white
        case .secondary, .ghost:
            return ColorToken.primary
        }
    }
    
    private var borderColor: Color {
        if isDisabled || isLoading {
            return ColorToken.border
        }
        
        switch variant {
        case .primary:
            return Color.clear
        case .secondary:
            return ColorToken.border
        case .ghost:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch variant {
        case .primary, .ghost:
            return 0
        case .secondary:
            return 1
        }
    }
}

#Preview("Button Variants") {
    VStack(spacing: SpacingToken.lg) {
        WellfinButton(title: "Primary", variant: .primary, size: .medium) {}
        WellfinButton(title: "Secondary", variant: .secondary, size: .medium) {}
        WellfinButton(title: "Ghost", variant: .ghost, size: .medium) {}
    }
    .padding()
}

#Preview("Button Sizes") {
    VStack(spacing: SpacingToken.md) {
        WellfinButton(title: "Small", variant: .primary, size: .small) {}
        WellfinButton(title: "Medium", variant: .primary, size: .medium) {}
        WellfinButton(title: "Large", variant: .primary, size: .large) {}
    }
    .padding()
}

#Preview("Button States") {
    VStack(spacing: SpacingToken.md) {
        WellfinButton(title: "Default", variant: .primary, size: .medium) {}
        WellfinButton(title: "Loading", variant: .primary, size: .medium, isLoading: true) {}
        WellfinButton(title: "Disabled", variant: .primary, size: .medium, isDisabled: true) {}
    }
    .padding()
}

#Preview("Light Mode") {
    VStack(spacing: SpacingToken.lg) {
        WellfinButton(title: "Primary", variant: .primary, size: .medium) {}
        WellfinButton(title: "Secondary", variant: .secondary, size: .medium) {}
        WellfinButton(title: "Ghost", variant: .ghost, size: .medium) {}
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    VStack(spacing: SpacingToken.lg) {
        WellfinButton(title: "Primary", variant: .primary, size: .medium) {}
        WellfinButton(title: "Secondary", variant: .secondary, size: .medium) {}
        WellfinButton(title: "Ghost", variant: .ghost, size: .medium) {}
    }
    .padding()
    .preferredColorScheme(.dark)
}

