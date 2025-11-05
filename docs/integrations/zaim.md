## Zaim Integration (Design Notes)

### Goals

- Pull categorized transactions, accounts/balances into our data model
- Normalize to shared DTOs in `SharedKit`
- Schedule background syncs and on-demand refresh

### Approach

- Implement an adapter module on the backend (Vapor) that:
  - Authenticates with Zaim (OAuth-based)
  - Fetches transactions, categories, accounts
  - Maps to our internal DTOs (SharedKit)
  - Persists via Fluent (PostgreSQL)

### Data Flow

1. iOS obtains user auth with our backend
2. Backend initiates Zaim connect flow (redirect, callback)
3. Tokens stored server-side (encrypted at rest)
4. Sync job pulls latest data, dedupes, updates balances
5. iOS fetches consolidated view from our API

### Notes

- Rate limit and backoff strategy required
- Idempotent upsert on transactions (keyed by external id + source)
- Add audit log entries per sync
