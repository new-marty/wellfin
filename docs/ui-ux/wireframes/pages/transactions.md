# Transactions

- Goal: Browse, search, and edit transactions efficiently
- Primary actions: Search/filter, edit transaction, batch actions
- Key components: Search bar, filter bar, transaction list, bulk toolbar
- Core states: default | empty | loading | error
- Mock data: fields [items[], filters{}, selection[]]
- Code: apps/ios/ios/screens/TransactionsView.swift

## Components

### Search Bar

- Prominent search field at top
- Real-time filtering of transaction list (local, no backend)
- Clear button appears when text entered
- Placeholder: "Search transactions..."

### Filter Bar

- Horizontal scrollable chips for quick filters
- Filters: Time range (Today, Week, Month, Custom), Category, Intent, Amount range
- Active filters highlighted
- "Clear all" option when filters active
- Advanced filters accessible via sheet

### Transaction List

- Virtualized list for performance
- Each row: merchant name, amount (tabular numerals), date, intent badge
- Swipe actions: Edit, Delete (UI-only)
- Tap row navigates to Transaction Detail
- Pull-to-refresh (UI-only, visual feedback)
- Infinite scroll placeholder (UI-only)

### Bulk Selection Toolbar

- Appears when Edit button tapped or selection mode entered
- Shows count of selected items
- Actions: Change Category, Add Tag, Mark Intent, Delete
- Actions are stubs (visual feedback only, no backend)
- Undo affordance after bulk actions

## Interactions

- Search: filters list in real-time as user types
- Filter chips: tap to toggle, shows active state
- Transaction row: tap to detail, swipe for quick actions
- Bulk selection: long-press or Edit button enters selection mode
- Bulk actions: show confirmation, then visual feedback, then undo option
- Filter persistence: maintains filter state during navigation

## Data Structure

```swift
struct TransactionsData {
    let items: [Transaction] // merchant, amount, date, intent, category
    let filters: FilterState // timeRange, category, intent, amountRange
    let selection: Set<TransactionID> // for bulk operations
}

struct Transaction {
    let id: String
    let merchant: String
    let amount: Decimal
    let date: Date
    let intent: Intent?
    let category: String?
    let tags: [String]
}
```

## States

- **Default**: List populated with mock transactions, filters inactive
- **Empty**: No transactions match current filters; show "No transactions" message and clear filters CTA
- **Loading**: Skeleton rows or spinner
- **Error**: Error message with retry button
