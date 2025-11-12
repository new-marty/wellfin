# Inbox

- Goal: Quickly triage and classify new transactions
- Primary actions: Swipe to classify (Need/Want/Culture/Unexpected), undo classification
- Key components: Transaction list, swipe gestures, button alternatives, undo affordance
- Core states: default | empty | loading | error
- Mock data: fields [items[], unclassifiedCount]
- Code: apps/ios/ios/screens/InboxView.swift

## Components

### Transaction List

- List of unclassified or newly imported transactions
- Each row: merchant name, amount (tabular numerals), date, transaction preview
- Swipeable rows with gesture recognition
- Visual feedback during swipe (color/icon cues)
- Tap row navigates to Transaction Detail (optional, can be disabled for triage focus)

### Swipe Gestures

- **Swipe Right → Need**: Green color, checkmark icon
- **Swipe Left → Want**: Orange color, shopping icon
- **Swipe Up → Culture**: Blue color, heart icon
- **Swipe Down → Unexpected**: Red color, alert icon
- Gesture threshold: ~30% of screen width/height
- Visual feedback: color overlay and icon appear during swipe
- After classification: row animates out or shows classified state

### Button Alternatives (A11y)

- Explicit buttons below each transaction row
- Buttons: "Need", "Want", "Culture", "Unexpected"
- Buttons use same colors/icons as swipe gestures
- Buttons are keyboard/VoiceOver accessible
- Buttons visible by default or via accessibility rotor action

### Undo Affordance

- Appears after any classification (swipe or button)
- Toast/banner with "Undo" button
- Undo reverts classification and returns transaction to inbox
- Undo accessible via keyboard/VoiceOver
- Undo disappears after timeout (5-10 seconds) or when next action taken

### Empty State

- Shows when all transactions are classified
- Message: "All caught up!" or "No new transactions"
- CTA to refresh or view all transactions
- Can be toggled via debug menu for testing

## Interactions

- Swipe gestures: smooth, responsive, clear visual feedback
- Button actions: immediate visual feedback matching swipe outcomes
- Undo: quick reversal without navigation
- Pull-to-refresh: loads new transactions (UI-only, mock data)
- Logging: emits events to console (intent set, undo, swipe direction)

## Data Structure

```swift
struct InboxData {
    let items: [InboxTransaction] // unclassified transactions
    let unclassifiedCount: Int
}

struct InboxTransaction {
    let id: String
    let merchant: String
    let amount: Decimal
    let date: Date
    let preview: String? // optional transaction description
}
```

## States

- **Default**: List populated with unclassified transactions
- **Empty**: No unclassified transactions; show "All caught up" message
- **Loading**: Skeleton rows or spinner while loading
- **Error**: Error message with retry button

## Accessibility

- All swipe actions have button alternatives
- VoiceOver rotor actions expose classification options
- Focus order: transaction row → classification buttons → undo (if visible)
- Labels: "Transaction from [merchant], [amount], classify as..."
- Hints: "Swipe right for Need, left for Want, or use buttons below"
