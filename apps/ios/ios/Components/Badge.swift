//
//  Badge.swift
//  wellfin
//
//  Badge component for labels and indicators
//

import SwiftUI

enum BadgeVariant {
    case primary
    case success
    case warning
    case danger
    case neutral
}

enum BadgeSize {
    case small
    case medium
    
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: 2, leading: SpacingToken.xs, bottom: 2, trailing: SpacingToken.xs)
        case .medium:
            return EdgeInsets(top: SpacingToken.xs / 2, leading: SpacingToken.sm, bottom: SpacingToken.xs / 2, trailing: SpacingToken.sm)
        }
    }
    
    var font: Font {
        switch self {
        case .small:
            return TypographyToken.caption2(weight: .semibold)
        case .medium:
            return TypographyToken.caption(weight: .semibold)
        }
    }
}

struct WellfinBadge: View {
    let text: String
    let variant: BadgeVariant
    let size: BadgeSize
    
    init(_ text: String, variant: BadgeVariant = .primary, size: BadgeSize = .medium) {
        self.text = text
        self.variant = variant
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(size.font)
            .padding(size.padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(RadiusToken.chip)
            .accessibilityLabel("Badge: \(text)")
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return ColorToken.primary.opacity(0.1)
        case .success:
            return ColorToken.success.opacity(0.1)
        case .warning:
            return ColorToken.warning.opacity(0.1)
        case .danger:
            return ColorToken.danger.opacity(0.1)
        case .neutral:
            return ColorToken.neutral200
        }
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return ColorToken.primary
        case .success:
            return ColorToken.success
        case .warning:
            return ColorToken.warning
        case .danger:
            return ColorToken.danger
        case .neutral:
            return ColorToken.text
        }
    }
}

#Preview("Badge Variants") {
    VStack(spacing: SpacingToken.md) {
        HStack(spacing: SpacingToken.sm) {
            WellfinBadge("Primary")
            WellfinBadge("Success", variant: .success)
            WellfinBadge("Warning", variant: .warning)
            WellfinBadge("Danger", variant: .danger)
            WellfinBadge("Neutral", variant: .neutral)
        }
    }
    .padding()
}

#Preview("Badge Sizes") {
    VStack(spacing: SpacingToken.md) {
        WellfinBadge("Small", size: .small)
        WellfinBadge("Medium", size: .medium)
    }
    .padding()
}


