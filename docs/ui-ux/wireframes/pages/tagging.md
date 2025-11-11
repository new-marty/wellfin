# Tagging

- Goal: Apply intents, categories, and context tags quickly
- Primary actions: Set intent, add/remove tags, create rule
- Key components: Tag chips, rule preview, suggestions
- Core states: default | empty | loading | error
- Mock data: fields [intent, category, tags[], rulePreview{}]
- Code: apps/ios/ios/screens/TaggingView.swift

## Components

### Intent Selector

- Radio button group or segmented control
- Options: Need, Want, Culture, Unexpected
- Visual indicators (colors/icons) match Inbox swipe gestures
- Selected state clearly indicated

### Category Selector

- Dropdown or sheet picker
- Common categories: Food, Transport, Shopping, Bills, etc.
- Searchable if many options
- Can add custom category (UI-only)

### Tag Chips

- Display existing tags as removable chips
- Add tag input field with autocomplete suggestions
- Chip removal: tap X or swipe to remove
- New tags can be created inline

### Rule Preview

- Shows what transactions would be affected by current rule
- Displays count and sample transactions
- Preview updates as user modifies intent/category/tags
- "Apply to X transactions" button (UI-only, no backend)

### Suggestions

- Shows suggested tags based on merchant name or transaction history
- Tappable suggestions add tag immediately
- Can be dismissed

## Interactions

- Intent selection updates rule preview immediately
- Category selection updates rule preview
- Adding/removing tags updates rule preview
- Rule preview shows delta (what changes)
- Apply button shows confirmation (UI-only, visual feedback only)
- Undo affordance after applying rule

## Data Structure

```swift
struct TaggingData {
    let currentIntent: Intent? // Need, Want, Culture, Unexpected
    let currentCategory: String?
    let currentTags: [String]
    let rulePreview: RulePreview // affectedCount, sampleTransactions[]
    let suggestedTags: [String]
}
```

## States

- **Default**: Transaction loaded, intent/category/tags populated
- **Empty**: New rule creation, no existing tags
- **Loading**: Loading transaction or calculating preview
- **Error**: Error loading transaction or preview calculation failed
