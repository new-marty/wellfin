### Glossary & Naming (Single Source of Truth)

- **Home**: The primary landing surface. Shows Safe‑to‑Spend, Money Rings (Savings/Needs/Wants), top suggestions, and upcoming items.
- **Inbox**: The swipe triage queue for new/uncertain transactions and surfaced suggestions that need a quick decision.
- **Transactions**: Search, filter, edit, batch-tag, receipts, and rules.
- **Goals**: Create/track goals; manual funding; schedules.
- **Profile**: Accounts, notifications, privacy, preferences.

- **Kakeibo Intents (primary classification via swipe)**: `Need`, `Want`, `Culture`, `Unexpected`.
  - Intent drives Money Rings and Safe‑to‑Spend.
- **Budget Category (secondary)**: Groceries, Rent, Dining, Transport, etc.
- **Context Tags (secondary)**: Home, Travel, Work, Tax, Refund, Subscription, Business, Amazon, etc.

- **Money Rings**: Three-ring visual on Home — inner Savings, middle Needs, outer Wants — representing progress toward weekly/monthly targets.
- **Safe‑to‑Spend**: One number on Home answering “Can I afford this?” (cash available + near‑term expected income − scheduled bills − minimum payments − planned savings).

- **Suggestion**: A proposed next action with an expected impact, likelihood, and timeliness, accompanied by a “Why this?” panel.
- **Coach Action**: Post‑swipe or Home action (e.g., “Move ¥X to Savings”), not a classification.

- **Subscription Radar**: Secondary visualization for subscriptions; primary control is a sortable list.

Conventions
- Use “Home” (not Overview) and “Inbox” (not Deck) everywhere.
- Use “Intent” for Kakeibo classification; “Category” for budget categories.
- Charts must have a primary action; otherwise they belong on secondary surfaces.

Additional terms
- **Spree day**: A day where discretionary (Wants) spend exceeds user’s typical 75th percentile by ≥X%. Triggers gentle friction and micro‑budget suggestions.
- **Cool‑down**: A temporary cap (e.g., 48h or 7 days) created after a spree day.
- **Ring delta**: Change to any Money Ring (%) resulting from triage, rules, or accepted suggestions.
- **Return‑by**: The last date an Amazon item can be returned for refund.
- **Confidence**: The model’s certainty in an impact estimate (High ≥0.8, Medium 0.6–0.79, Low <0.6).
- **Runway days**: Estimated days until STS reaches zero.  
  runway = max(0, STS_today / daily_burn), daily_burn = EMA_14d(Needs + contractual obligations).
- **Savings rate (MTD)**: (saved + invested MTD) / net inflows MTD, where net inflows exclude transfers and refunds.
- **Culture floor**: Minimum % of Wants reserved for Culture per period (default 1–3%). Visualized as a dotted micro‑arc on the Wants ring.
- **STS confidence**: High — forecast share <20% and all contractual items known; Medium — 20–50% forecast or some contracts unknown; Low — >50% forecast or key items missing.



