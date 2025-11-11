//
//  DesignTokens.swift
//  wellfin
//
//  Design tokens following Apple HIG, mapping to system values by default
//

import SwiftUI

// MARK: - Color Tokens

/// Color tokens mapping to system colors with semantic roles
enum ColorToken {
    // Primary colors
    static var primary: Color { .accentColor }
    
    // Semantic colors
    static var success: Color { .green }
    static var warning: Color { .orange }
    static var danger: Color { .red }
    
    // Neutral palette (0-900 scale, mapped to system grays)
    static var neutral0: Color { .white }
    static var neutral100: Color { Color(white: 0.95) }
    static var neutral200: Color { Color(white: 0.9) }
    static var neutral300: Color { Color(white: 0.8) }
    static var neutral400: Color { Color(white: 0.7) }
    static var neutral500: Color { .gray }
    static var neutral600: Color { Color(white: 0.4) }
    static var neutral700: Color { Color(white: 0.3) }
    static var neutral800: Color { Color(white: 0.2) }
    static var neutral900: Color { .black }
    
    // Role-based colors
    static var background: Color { .background }
    static var surface: Color { Color(.systemBackground) }
    static var text: Color { .primary }
    static var textSecondary: Color { .secondary }
    static var textSubtle: Color { .tertiary }
    static var focus: Color { .accentColor }
    static var border: Color { Color(.separator) }
}

// MARK: - Typography Tokens

/// Typography tokens mapping to system font styles
enum TypographyToken {
    // Font styles (mapped to system text styles)
    static func largeTitle(weight: Font.Weight = .regular) -> Font {
        .system(.largeTitle, design: .default, weight: weight)
    }
    
    static func title(weight: Font.Weight = .regular) -> Font {
        .system(.title, design: .default, weight: weight)
    }
    
    static func title2(weight: Font.Weight = .regular) -> Font {
        .system(.title2, design: .default, weight: weight)
    }
    
    static func title3(weight: Font.Weight = .regular) -> Font {
        .system(.title3, design: .default, weight: weight)
    }
    
    static func headline(weight: Font.Weight = .semibold) -> Font {
        .system(.headline, design: .default, weight: weight)
    }
    
    static func body(weight: Font.Weight = .regular) -> Font {
        .system(.body, design: .default, weight: weight)
    }
    
    static func callout(weight: Font.Weight = .regular) -> Font {
        .system(.callout, design: .default, weight: weight)
    }
    
    static func footnote(weight: Font.Weight = .regular) -> Font {
        .system(.footnote, design: .default, weight: weight)
    }
    
    static func caption(weight: Font.Weight = .regular) -> Font {
        .system(.caption, design: .default, weight: weight)
    }
    
    static func caption2(weight: Font.Weight = .regular) -> Font {
        .system(.caption2, design: .default, weight: weight)
    }
    
    // Tabular numerals for currency (monospaced digits)
    static func tabularNumbers(_ font: Font) -> Font {
        font.monospacedDigit()
    }
}

// MARK: - Spacing Tokens

/// Spacing scale tokens (0, 4, 8, 12, 16, 20, 24, 32)
enum SpacingToken {
    static var zero: CGFloat { 0 }
    static var xs: CGFloat { 4 }
    static var sm: CGFloat { 8 }
    static var md: CGFloat { 12 }
    static var lg: CGFloat { 16 }
    static var xl: CGFloat { 20 }
    static var xxl: CGFloat { 24 }
    static var xxxl: CGFloat { 32 }
}

// MARK: - Radius Tokens

/// Border radius tokens
enum RadiusToken {
    static var chip: CGFloat { 4 }
    static var card: CGFloat { 8 }
    static var modal: CGFloat { 12 }
}

// MARK: - Elevation Tokens

/// Elevation levels for layering
enum ElevationToken {
    case none
    case raised
    case overlay
    
    var shadowRadius: CGFloat {
        switch self {
        case .none: return 0
        case .raised: return 2
        case .overlay: return 8
        }
    }
    
    var shadowOpacity: Double {
        switch self {
        case .none: return 0
        case .raised: return 0.1
        case .overlay: return 0.2
        }
    }
    
    var shadowOffset: CGSize {
        switch self {
        case .none: return .zero
        case .raised: return CGSize(width: 0, height: 1)
        case .overlay: return CGSize(width: 0, height: 4)
        }
    }
}

// MARK: - Motion Tokens

/// Motion tokens respecting Reduce Motion preference
enum MotionToken {
    // Duration scale (120-220ms)
    static var fast: TimeInterval { 0.12 }
    static var standard: TimeInterval { 0.2 }
    static var slow: TimeInterval { 0.22 }
    
    // Easing curves (mapped to system animations)
    static var standardEasing: Animation {
        .easeInOut(duration: standard)
    }
    
    static var decelerate: Animation {
        .easeOut(duration: standard)
    }
    
    static var accelerate: Animation {
        .easeIn(duration: standard)
    }
    
    // Respect Reduce Motion
    static func animation(duration: TimeInterval = standard, curve: Animation = standardEasing) -> Animation {
        // Check for Reduce Motion preference
        // In SwiftUI, we can use @Environment(\.accessibilityReduceMotion)
        // For now, return the standard animation
        // This will be enhanced when we integrate with view environment
        return curve
    }
}

// MARK: - SwiftUI View Extensions

extension View {
    /// Apply elevation shadow
    func elevation(_ level: ElevationToken) -> some View {
        self.shadow(
            color: .black.opacity(level.shadowOpacity),
            radius: level.shadowRadius,
            x: level.shadowOffset.width,
            y: level.shadowOffset.height
        )
    }
    
    /// Apply card radius
    func cardRadius() -> some View {
        self.cornerRadius(RadiusToken.card)
    }
    
    /// Apply chip radius
    func chipRadius() -> some View {
        self.cornerRadius(RadiusToken.chip)
    }
    
    /// Apply modal radius
    func modalRadius() -> some View {
        self.cornerRadius(RadiusToken.modal)
    }
}

