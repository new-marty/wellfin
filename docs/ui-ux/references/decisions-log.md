### Decisions Log (Lightweight ADR)

Record material UI/UX decisions that affect multiple docs or surfaces. Keep entries short; link to PRs.

---

#### 2025-11-05 — Nomenclature Unification
- Decision: Use **Home** (not Overview) and **Inbox** (not Deck) across all surfaces.
- Rationale: Reduce cognitive load and ensure consistent mental model.
- Impact: Updated `02-IA`, `03-Wireframes`, `README`, and `Glossary`.

#### 2025-11-05 — Kakeibo Intents and Coach Actions
- Decision: Kakeibo intents = **Need / Want / Culture / Unexpected**. Treat **Save/Invest** as a **Coach action** post‑swipe or via Suggestions, not a classification.
- Rationale: Align with Kakeibo methodology and avoid mixing movement with expense intents.
- Impact: Updated `03-Wireframes`, `04-Tagging`, `07-Interactions`.

#### 2025-11-05 — Money Rings on Home
- Decision: Add **Money Rings** (Savings/Needs/Wants) to Home, tap to drilldown; show ring deltas post‑swipe.
- Rationale: Close‑the‑ring habit loop; immediate feedback from triage.
- Impact: Updated `02-IA`, `03-Wireframes`, `08-Data Visualization`.

#### 2025-11-05 — Safe‑to‑Spend as Primary Metric
- Decision: Show **Safe‑to‑Spend** on Home (cash available + near‑term expected income − scheduled bills/minimums − planned savings).
- Rationale: One number answers “Can I afford this?”; drives behavior change.
- Impact: Updated `01-Vision`, `02-IA`, `03-Wireframes`, `09-MVP`.

#### 2025-11-05 — Suggestions Scoring and Capping
- Decision: Central scoring `impact_yen × likelihood(user) × timeliness`; cap Home to ≤3 suggestions.
- Rationale: Single source of truth; avoid cluttering Home.
- Impact: Updated `05-Suggestions`.

#### 2025-11-05 — Swipe Mapping Standardization
- Decision: Right=Need, Left=Want, Up=Unexpected, Down=Culture across all surfaces and onboarding.
- Rationale: Aligns with common motor memory and reduces mis-swipes.
- Impact: Updated `03-Wireframes`, `06-Onboarding`, `07-Interactions`.

#### 2025-11-05 — STS Exclusions & Confidence
- Decision: Exclude transfers, refunds, pending auths, and unsettled FX from STS and define STS confidence thresholds.
- Rationale: Prevent double counting; make uncertainty visible.
- Impact: Updated `03-Wireframes`, `Glossary`.


