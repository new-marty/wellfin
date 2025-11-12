# Settings

- Goal: Manage accounts, notifications, privacy, and preferences
- Primary actions: Connect accounts, adjust notifications, update privacy
- Key components: Sectioned list, toggles, navigation links
- Core states: default | empty | loading | error
- Mock data: fields [accounts[], prefs{}, notifications{}]
- Code: apps/ios/ios/screens/SettingsView.swift

## Sections

### Accounts (Stub)

- List of connected accounts (placeholder)
- "Connect Account" button (navigates to placeholder screen)
- Shows connection status (connected/disconnected)
- For MVP: placeholder states OK

### Notifications (Stub)

- Toggle switches for notification types (placeholder)
- Types: Suggestions, Goals progress, Weekly summary
- All toggles functional but no actual notifications sent
- Persists via UserDefaults

### Privacy (Stub)

- Privacy policy link (placeholder)
- Data export option (placeholder)
- Delete account option (placeholder, shows confirmation)
- For MVP: UI only, no backend

### Preferences (Functional)

- **JP Formatting Toggles** (see NM-40):
  - Currency: JPY display toggle
  - Date format: yyyy-mm-dd toggle
  - Week start: Monday toggle
- **Demo/Data Controls** (see NM-22):
  - Reset demo data button
  - Switch dataset dropdown
- All preferences persist via UserDefaults
- Changes reflect immediately in UI

## Components

- Section headers with clear labels
- Toggle switches with labels and descriptions
- Navigation links with chevrons
- Buttons with appropriate styling (primary/secondary)
- Confirmation dialogs for destructive actions

## Interactions

- Toggle switches: immediate visual feedback, persist to UserDefaults
- Navigation links: push to detail screens (stubs for accounts/privacy)
- Buttons: show loading state, then success/error feedback
- Reset data: shows confirmation dialog, then resets to default dataset

## Data Structure

```swift
struct SettingsData {
    let accounts: [Account] // name, status, type (stub)
    let preferences: Preferences // jpFormatting, demoMode
    let notifications: NotificationSettings // enabled types (stub)
}

struct Preferences {
    let currencyJPY: Bool
    let dateFormatYYYYMMDD: Bool
    let weekStartMonday: Bool
    let demoDataset: String // "datasetA", "datasetB", etc.
}
```

## States

- **Default**: All sections populated, preferences loaded from UserDefaults
- **Empty**: No accounts connected (normal state for stub)
- **Loading**: Loading account status or preferences
- **Error**: Error loading settings, show retry option
