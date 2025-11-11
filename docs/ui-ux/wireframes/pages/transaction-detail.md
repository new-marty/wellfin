# Transaction Detail

- Goal: Inspect and adjust a transaction with full context
- Primary actions: Change intent/category/tags, split, attach receipt
- Key components: Summary, editable fields, splits, history
- Core states: default | empty | loading | error
- Mock data: fields [transaction{}, splits[], suggestedFixes[]]
- Code: apps/ios/ios/screens/TransactionDetailView.swift

## Components

### Summary Header

- Merchant name (prominent)
- Amount (currency formatted, tabular numerals)
- Date (formatted per user preferences)
- Status indicator (pending/cleared/reconciled)
- Receipt attachment indicator (if present)

### Editable Fields

- **Intent Selector**: Segmented control or picker (Need/Want/Culture/Unexpected)
- **Category Selector**: Dropdown/picker with search (Food, Transport, Shopping, Bills, etc.)
- **Tags Editor**: Tag chips with add/remove capability (see Tagging wireframe)
- **Notes Field**: Multi-line text input for transaction notes
- All fields editable inline; changes show visual feedback
- Undo affordance after each edit

### Splits Section

- List of split lines (if transaction is split)
- Each split: description, amount, category, intent
- "Add Split" button adds new split line
- Split lines editable (tap to edit)
- Remove split button (X) on each line
- Total validation: sum of splits must equal transaction amount
- "Remove Splits" option to convert back to single transaction

### History Section

- Chronological list of changes to transaction
- Each entry: timestamp, what changed, who changed (if applicable)
- Reverse chronological order (newest first)
- Mock data for UI-only milestone
- Shows: intent changes, category changes, tag additions/removals, splits

### Suggested Fixes (Optional)

- List of suggested improvements or corrections
- Each suggestion: description, impact, "Apply" button
- UI-only, visual feedback only

## Interactions

- Field edits: immediate visual feedback, undo available
- Split editing: inline editing, validation on amount changes
- Navigation: back button returns to previous screen
- Undo: consistent affordance after any edit
- Receipt attachment: placeholder button (UI-only)

## Data Structure

```swift
struct TransactionDetailData {
    let transaction: Transaction
    let splits: [Split]?
    let history: [HistoryEntry]
    let suggestedFixes: [Suggestion]?
}

struct Transaction {
    let id: String
    let merchant: String
    let amount: Decimal
    let date: Date
    let intent: Intent?
    let category: String?
    let tags: [String]
    let notes: String?
    let status: TransactionStatus
    let receiptAttached: Bool
}

struct Split {
    let id: String
    let description: String
    let amount: Decimal
    let category: String?
    let intent: Intent?
}
```

## States

- **Default**: Transaction loaded, all fields populated
- **Empty**: Error state or transaction not found
- **Loading**: Loading transaction data (skeleton or spinner)
- **Error**: Error loading transaction, show retry button
