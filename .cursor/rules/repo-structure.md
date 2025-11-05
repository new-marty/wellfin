## Repo Structure Rules

- Keep iOS, API, and shared code separated: `apps/`, `packages/`, `infra/`, `docs/`.
- Do not introduce Node/TS unless explicitly requested.
- Prefer SwiftPM for dependencies; share code via `packages/SharedKit`.
- Tests are required alongside any new module or feature.
- Avoid moving the iOS project unless moving the `.xcodeproj` together.





