# Home Dashboard

- Goal: Show Safe-to-Spend and next best actions at a glance
- Primary actions: Review suggestions, open STS breakdown
- Key components: STS header, Money Rings, Top suggestions, Upcoming
- Core states: default | empty | loading | error
- Mock data: fields [stsValue, ringValues, suggestions[], upcoming[]]
- Code: apps/ios/ios/screens/HomeDashboardView.swift

## Components

### STS Header

- Displays Safe-to-Spend value prominently using currency formatting helpers
- Uses tabular numerals for alignment
- Tappable to open breakdown sheet
- Shows loading skeleton when calculating
- Empty state: shows placeholder or "Calculate STS" CTA

### Money Rings

- Visual representation of spending by category/intent
- Each segment shows category name, amount, and percentage
- Tappable segments navigate to filtered transaction list
- Reduce Motion: discrete value updates, no sweeping animations
- Accessible alternative: data table showing same information
- Empty state: shows message when no spending data

### Top Suggestions

- List of top 3 actionable suggestions
- Each card shows: title, impact badge (savings/time), timer/expiry
- Tappable cards navigate to detail sheet
- Empty state: guided CTA to enable suggestions
- Loading: skeleton cards

### Upcoming (Optional)

- List of upcoming transactions or bills
- Simple list row format
- Can be collapsed/expanded

## Interactions

- Pull-to-refresh updates STS and suggestions
- STS breakdown sheet: adjustable assumptions (UI-only placeholders)
- Ring drilldown: navigates to Transactions filtered by category
- Suggestion cards: tap to view detail, accept, snooze, or decline

## Data Structure

```swift
struct HomeDashboardData {
    let stsValue: Decimal
    let ringValues: [CategoryRing] // category, amount, percentage
    let suggestions: [Suggestion] // title, impact, expiry
    let upcoming: [UpcomingItem] // optional
}
```

## States

- **Default**: All components populated with mock data
- **Empty**: No spending data, no suggestions; show guided CTAs
- **Loading**: Skeletons for STS, rings, suggestions
- **Error**: Error message with retry button
