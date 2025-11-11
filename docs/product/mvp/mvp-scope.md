### 09 — MVP Scope

#### In Scope

- iOS app with tabs: **Home**, Inbox, Transactions, Goals, Profile
- Safe‑to‑Spend calculation and display on Home
- Money Rings component with drilldowns
- Connections UI (placeholder states OK); Demo mode
- Swipe triage (Need/Want/Culture/Unexpected)
- Tagging with rules; Amazon unpacker (basic)
- Suggestions surfaces (top 3 on Home, Inbox, notifications)
- Goals: create, progress ring, manual funding

#### Out of Scope (MVP)

- Full budgeting frameworks beyond basics; deep investing analytics
- Advanced forecasting; multi-currency accounting
- Desktop/web clients

#### First-Run & Placeholders

- Demo data if no connections; clear handoff once accounts connect
- Empty states and guided CTA for each tab

#### Instrumentation & DoD

- Events: swipe intent set, **undo intent**, rule created/applied with **preview deltas**, suggestion shown/accepted/snoozed/declined/**expired**, ring closed, **triage_error_hint_shown**, **triage_direction_misfire**
- Test cohort targets:
  - ≥60% complete first suggestion within 24h
  - ≥70% daily triage streak ≥3 days in week 1
  - ≥10% drop in Wants vs baseline by week 4 (opt‑in cohort)
  - **First‑60s**: user sees STS and accepts one suggestion in first session
  - ≤5% of auto‑applied category/tags undone within 24h
  - ≥60% of users open STS breakdown and change one assumption without guidance
- Recovery KPI:
  - ≥80% of mis‑classifications corrected via Undo within 30s (measures comfort with triage)

#### Accessibility & Localization Acceptance (M4)

- All actionable components reachable with VoiceOver and rotor actions; **every swipe has a button alternative**; focus order and labels verified in Inbox and Home rings
- Reduce Motion replaces ring sweeps with discrete value snaps
- Charts have table alternatives that expose the same information
- JP defaults: yen formatting, yyyy‑mm‑dd option, Monday week start, payday presets; strings ready for pluralization and fixed‑width numerals

#### Milestones

- M1: IA + Wireframes clickable prototype
- M2: Swipe triage + Tagging + Demo data
- M3: Suggestions feed + Goals
- M4: Data viz polish + Onboarding + Accessibility pass

Definition of done: Usability testable prototype; can complete daily triage, accept suggestions, fund a goal, and review spending.


