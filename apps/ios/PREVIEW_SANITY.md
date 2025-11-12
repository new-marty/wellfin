# Preview Sanity Checks

This document describes the preview sanity checks implemented for core screens and components.

## Overview

Preview sanity checks verify that SwiftUI previews can be instantiated and rendered without errors. They use deterministic mock data with stable seeds to ensure consistent output.

## Core Screens

The following screens have preview sanity checks:

- **HomeView**: Main dashboard screen
- **InboxView**: Transaction triage screen
- **TransactionsView**: Transaction list screen
- **SettingsView**: Settings and preferences screen
- **MainTabView**: Root tab bar container

## Critical Components

- **TransactionRow**: Individual transaction row component

## Running Preview Sanity Checks

### Via Xcode

1. Open the project in Xcode
2. Run the test scheme: `Product > Test` (⌘U)
3. Preview sanity tests are in `PreviewSanityTests.swift`

### Via Command Line

```bash
cd apps/ios
xcodebuild test \
  -workspace ../../wellfin.xcworkspace \
  -scheme ios \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:iosTests/PreviewSanityTests
```

## Updating Previews

When adding new screens or components:

1. Add a preview block using `#Preview` macro
2. Use deterministic mock data via `MockData` accessors
3. Add a sanity test in `PreviewSanityTests.swift`
4. Verify the preview renders correctly in Xcode

### Example

```swift
#Preview("My New View") {
    NavigationStack {
        MyNewView()
            .environment(UserPreferences.shared)
    }
}
```

## Deterministic Mock Data

All previews use stable seeds to ensure consistent output:

- **Dataset A**: Seed `11111` (default)
- **Dataset B**: Seed `22222`
- **Preview Dataset**: Seed `67890` (for previews)

## CI Integration

Preview sanity checks can be integrated into CI:

```yaml
- name: Run Preview Sanity Checks
  run: |
    xcodebuild test \
      -workspace wellfin.xcworkspace \
      -scheme ios \
      -destination 'platform=iOS Simulator,name=iPhone 17' \
      -only-testing:iosTests/PreviewSanityTests
```

## Troubleshooting

### Preview Fails to Render

1. Check that all dependencies are available
2. Verify mock data generators are working
3. Ensure UserPreferences is properly initialized
4. Check for SwiftUI preview errors in Xcode console

### Preview Shows Different Data

- Verify you're using the correct dataset seed
- Check that `MockData` is using the selected dataset
- Ensure previews aren't using random data

### Test Failures

- Verify the view can be instantiated
- Check that all required environment values are provided
- Ensure mock data is deterministic

