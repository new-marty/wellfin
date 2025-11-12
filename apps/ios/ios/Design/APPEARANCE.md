# Global Appearance Configuration

This document describes how global appearance is configured in the WellFin iOS app and how to override it in previews.

## Overview

The app uses **system defaults** for appearance, following Apple's Human Interface Guidelines:
- **System accent color** (configurable in Assets.xcassets/AccentColor)
- **System colors** that automatically adapt to light/dark mode
- **Dynamic Type** support via `TypographyToken` (uses system text styles)
- **SF Symbols** that scale with Dynamic Type

## Single Entry Point

Global appearance is configured via `AppAppearance.configure()`, called in `WellfinApp.init()`. This is the **only place** where global appearance should be modified.

### Current Configuration

```swift
AppAppearance.configure()
```

Currently uses system defaults. If custom tint or other overrides are needed in the future, add them here.

## Design Tokens

All styling should use design tokens from `DesignTokens.swift`:

- **Colors**: `ColorToken` - Maps to system colors
- **Typography**: `TypographyToken` - Uses system text styles (respects Dynamic Type)
- **Spacing**: `SpacingToken` - Consistent spacing scale
- **Radius**: `RadiusToken` - Border radius values
- **Elevation**: `ElevationToken` - Shadow levels

## Dynamic Type

Dynamic Type is **automatically respected** when using `TypographyToken` methods:

```swift
Text("Hello")
    .font(TypographyToken.body()) // Automatically scales with user's text size preference
```

**Never use fixed font sizes.** Always use `TypographyToken` or system text styles.

## System Colors

All colors use system colors that automatically adapt to light/dark mode:

```swift
Text("Hello")
    .foregroundColor(ColorToken.text) // Adapts to light/dark automatically
```

**Never hardcode colors.** Always use `ColorToken` or system colors.

## SF Symbols

SF Symbols automatically scale with Dynamic Type when using system font sizes:

```swift
Image(systemName: "house.fill")
    .font(.system(.title)) // Scales with Dynamic Type
```

## Overriding Appearance in Previews

Use the `previewAppearance()` helper to test different appearance settings:

### Light/Dark Mode

```swift
#Preview("Light Mode") {
    MyView()
        .previewAppearance(colorScheme: .light)
}

#Preview("Dark Mode") {
    MyView()
        .previewAppearance(colorScheme: .dark)
}
```

### Dynamic Type Sizes

```swift
#Preview("Large Text") {
    MyView()
        .previewAppearance(sizeCategory: .accessibilityExtraExtraExtraLarge)
}

#Preview("Small Text") {
    MyView()
        .previewAppearance(sizeCategory: .extraSmall)
}
```

### Combined

```swift
#Preview("Dark Mode + Large Text") {
    MyView()
        .previewAppearance(
            colorScheme: .dark,
            sizeCategory: .accessibilityExtraExtraExtraLarge
        )
}
```

### Manual Override (if needed)

```swift
#Preview {
    MyView()
        .preferredColorScheme(.dark)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
```

## Custom Tints (Future)

If custom accent colors are needed in the future:

1. Add configuration to `AppAppearance.configure()`
2. Document the custom color and rationale
3. Ensure it works in both light and dark modes

## Testing

To verify appearance works correctly:

1. **Light/Dark Mode**: Toggle in iOS Settings > Display & Brightness
2. **Dynamic Type**: Test in iOS Settings > Accessibility > Display & Text Size > Larger Text
3. **Reduce Motion**: Test in iOS Settings > Accessibility > Motion > Reduce Motion

The app should adapt automatically to all these settings.

## Best Practices

✅ **DO:**
- Use `TypographyToken` for all text
- Use `ColorToken` for all colors
- Use system SF Symbols with system font sizes
- Test in both light and dark modes
- Test with different Dynamic Type sizes

❌ **DON'T:**
- Hardcode font sizes
- Hardcode colors
- Override system appearance globally (except in `AppAppearance`)
- Use fixed-size SF Symbols

