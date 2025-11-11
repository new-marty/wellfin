### Appendix — Minimal Data Model & Event Schema (MVP)

This appendix defines a lightweight schema to align design, engineering, and analytics for the MVP.

#### Core entities

- `User(id, locale, jp_presets_enabled, notification_prefs)`
- `Account(id, type, name, currency, status, autopay_mode)`
- `Transaction(id, account_id, amount, currency, posted_at, merchant, channel, is_recurring, is_transfer, is_bnpl)`
- `Classification(transaction_id, intent, category, tags[], source, confidence, at)`
- `Rule(id, conditions, actions, enabled, precedence, created_at)`
- `Goal(id, name, target_amount, target_date, schedule, status)`
- `Suggestion(id, type, inputs, expected_impact, confidence, created_at, expires_at, state)`
- `STS_Snapshot(id, at, value, components, confidence)`
- `BNPL_Plan(id, provider, installments[])`
- `Merchant(id, normalized_name, aliases[], mcc?)`
- `Category(id, name, parent_id?)`
- `Tag(id, name, type: context|system, canonical_parent?)`
- `Split(id, transaction_id, amount, intent, category_id, tag_ids[])`
- `RecurringPattern(entity_id, cadence, window, confidence)`
- `IrregularFlag(entity_id, reasons[], confidence, created_at)`

#### Key events

- `triage_swipe(direction, intent, confidence, undoable_id)`
- `intent_undo(undoable_id, previous_intent, new_intent)`
- `triage_error_hint_shown()`
- `triage_direction_misfire(direction)`
- `rule_created(id, preview_count, preview_delta)`
- `rule_applied(id, affected_count)`
- `auto_tag_applied(source: rule|model, fields[], confidence)`
- `auto_tag_undone(source, fields[])`
- `suggestion_shown(id)`
- `suggestion_accepted(id)`
- `suggestion_declined(id)`
- `suggestion_snoozed(id)`
- `suggestion_expired(id)`
- `irregular_flag_shown(reasons[], confidence)`
- `irregular_flag_dismissed(reasons[])`
- `sts_breakdown_opened()`
- `sts_assumption_changed(key, old, new)`
- `sts_mismatch_reported(user_note, snapshot_id)`
- `ring_delta_shown(type, delta_percent)`

Notes

- Use this as a stub for instrumentation during M2–M3; refine as needed once real data flows are wired.
- Precedence: manual > user_rule > system_hint (see tagging doc).


