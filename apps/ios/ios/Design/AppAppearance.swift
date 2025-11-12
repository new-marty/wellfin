//
//  AppAppearance.swift
//  wellfin
//
//  Global appearance configuration - single entry point for app-wide styling
//  Prefers system defaults; minimal custom overrides only when required
//

import SwiftUI

/// Global appearance configuration for the app
/// This is the single entry point for app-wide appearance settings
struct AppAppearance {
    /// Configure global appearance settings
    /// Call this once at app launch in WellfinApp
    static func configure() {
        // Use system defaults - no custom overrides unless required
        // System accent color is used by default (configured in Assets.xcassets)
        // Dynamic Type is automatically respected via TypographyToken
        // Light/dark mode is handled automatically via system colors
        
        // Note: If custom tint is needed in the future, set it here:
        // UIApplication.shared.windows.first?.tintColor = UIColor.systemBlue
    }
}

// MARK: - View Modifiers for Global Appearance

extension View {
    /// Apply global appearance settings to a view
    /// This ensures Dynamic Type, system colors, and theming are respected
    func applyGlobalAppearance() -> some View {
        self
            // Dynamic Type is automatically respected when using TypographyToken
            // System colors automatically adapt to light/dark mode
            // No additional modifiers needed - SwiftUI handles this natively
    }
    
    /// Preview helper: Override appearance for previews
    /// Use this in preview code to test different appearance settings
    func previewAppearance(
        colorScheme: ColorScheme? = nil,
        sizeCategory: ContentSizeCategory? = nil
    ) -> some View {
        Group {
            self.applyGlobalAppearance()
        }
        .if(colorScheme != nil) { view in
            view.preferredColorScheme(colorScheme!)
        }
        .if(sizeCategory != nil) { view in
            view.environment(\.sizeCategory, sizeCategory!)
        }
    }
}

// MARK: - View Extension Helper

extension View {
    /// Conditionally apply a modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Environment Keys (for future customization if needed)

/// Environment key for custom accent color (uses system default if not set)
private struct AccentColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    /// Custom accent color override (nil = use system default)
    var customAccentColor: Color? {
        get { self[AccentColorKey.self] }
        set { self[AccentColorKey.self] = newValue }
    }
}

