### WellFin — UI/UX (Code‑First)

This folder is the UI/UX source of truth. We design screens directly in code (SwiftUI) with mock data and keep docs concise and actionable.

Scope:

- UI/UX only. No marketing, acquisition, or retention content.
- No MVP checklist here; these docs define the MVP experience.
- No onboarding/first‑run pages.

How to use:

- Start with `foundations/` (principles, tokens).
- Implement screens from `wireframes/pages/` with deterministic mock data.
- Reuse guidance in `components.md`, `patterns.md`, and `interactions-a11y.md`.
- For terms and decisions, see `references/`.

Structure:

- `foundations/` — design principles and tokens
- `wireframes/pages/*` — each core screen
- `wireframes/states/*` — empty, loading, error
- `components.md`, `patterns.md`, `interactions-a11y.md`, `data-visualization.md`
- `references/` — glossary, references, decisions log

Contribution:

- Keep wireframe docs minimal: goal, primary actions, key components, states, mock data fields, code path.
- When adding a new component/pattern, document purpose, variants, states, and a11y in the respective file.
- Record notable decisions in `references/decisions-log.md`.
