# SwiftUI Previews Guide

This guide explains how to use SwiftUI previews with stable seeds and state variants in the Wellfin iOS app.

## Overview

All core screens provide SwiftUI previews that render with deterministic mock data using stable seeds. Previews cover core states (default, empty, loading, error) via preview parameters, enabling rapid iteration and visual testing.

## Preview States

Each screen supports four preview states:

- **Default**: Normal state with data loaded
- **Empty**: No data available (empty state)
- **Loading**: Data is being fetched (loading indicator)
- **Error**: An error occurred (error message)

## Using Preview States

### Basic Usage

Each view accepts an optional `previewState` parameter for previews:

```swift
#Preview("Default") {
    NavigationStack {
        TransactionsView(previewState: .default)
    }
}

#Preview("Empty") {
    NavigationStack {
        TransactionsView(previewState: .empty)
    }
}
```

### Available States

Use `PreviewState` enum values:
- `.default` - Normal state with data
- `.empty` - Empty state
- `.loading` - Loading state
- `.error` - Error state

## Stable Seeds

Mock data generators use stable seeds to ensure deterministic, reproducible previews:

- **Default seed**: `12345` (via `DefaultMockDataProvider`)
- **Alternative seed**: `67890` (via `PreviewMockDataProvider`)

### Switching Seeds

To use a different seed in previews, create a custom `MockDataProvider`:

```swift
struct CustomMockDataProvider: MockDataProvider {
    let seed: UInt64 = 99999
    static let shared = CustomMockDataProvider()
}

// Use in preview
let generator = TransactionGenerator(provider: CustomMockDataProvider.shared)
let transactions = generator.generate(count: 20)
```

### Using Preview Seeds

The `PreviewSeed` enum provides predefined seeds:

```swift
#Preview("Stable Seed") {
    let provider = DefaultMockDataProvider(seed: PreviewSeed.stable.value)
    // Use provider...
}

#Preview("Alternative Seed") {
    let provider = DefaultMockDataProvider(seed: PreviewSeed.alternative.value)
    // Use provider...
}
```

## Preview Examples

### Complete Preview Set

Each screen should include previews for all states and appearance variants:

```swift
// MARK: - Previews

#Preview("Default") {
    NavigationStack {
        TransactionsView(previewState: .default)
    }
}

#Preview("Empty") {
    NavigationStack {
        TransactionsView(previewState: .empty)
    }
}

#Preview("Loading") {
    NavigationStack {
        TransactionsView(previewState: .loading)
    }
}

#Preview("Error") {
    NavigationStack {
        TransactionsView(previewState: .error)
    }
}

#Preview("Light Mode") {
    NavigationStack {
        TransactionsView(previewState: .default)
            .previewAppearance(colorScheme: .light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        TransactionsView(previewState: .default)
            .previewAppearance(colorScheme: .dark)
    }
}
```

## Mock Data

Mock data is generated using `MockData` convenience accessors:

- `MockData.transactions` - Uses default seed (12345)
- `MockData.previewTransactions` - Uses preview seed (67890)
- `MockData.accounts` - Account generator
- `MockData.classifications` - Classification generator
- `MockData.suggestions` - Suggestion generator

All generators use stable seeds, ensuring consistent preview output.

## Best Practices

1. **Always include state variants**: Provide previews for default, empty, loading, and error states
2. **Use stable seeds**: Never use random seeds in previews - use `MockData` accessors or stable seed providers
3. **Test appearance variants**: Include light/dark mode previews for visual testing
4. **Keep previews close to views**: Preview code lives in the same file as the view
5. **Compile without warnings**: Ensure all previews compile cleanly

## Troubleshooting

### Preview not updating

- Ensure you're using stable seeds (not random)
- Check that mock data generators are deterministic
- Verify preview state is correctly set

### Preview shows wrong data

- Check which seed/provider is being used
- Verify `MockDataProvider` seed value
- Ensure generator is using the correct provider

### Preview compilation errors

- Ensure `PreviewState` is imported (via `PreviewHelpers.swift`)
- Check that view initializers match preview usage
- Verify all required dependencies are available

## Implementation Details

### PreviewState Enum

Located in `Design/PreviewHelpers.swift`:

```swift
enum PreviewState: String, CaseIterable {
    case `default` = "Default"
    case empty = "Empty"
    case loading = "Loading"
    case error = "Error"
}
```

### Mock Data Providers

Located in `MockData/MockDataProvider.swift`:

- `DefaultMockDataProvider`: Seed `12345`
- `PreviewMockDataProvider`: Seed `67890`

Both implement `MockDataProvider` protocol with `makeGenerator()` method.

