## Coding Standards (Swift)

- Use Swift Concurrency, avoid completion-closure pyramids where possible.
- Prefer immutable `let` and small, focused types and functions.
- Naming: descriptive, no 1–2 letter identifiers; types PascalCase, methods/vars camelCase.
- Errors: prefer typed errors (`enum`) in SharedKit; return domain-specific messages.
- Tests: colocate tests with package targets; name tests after behavior.
- Formatting: run `swiftformat .` before commit; keep diffs minimal.
- Linting: run `swiftlint --quiet`; warnings are acceptable initially, avoid regressions.


