## Swift Tech Stack Rules

### iOS (SwiftUI)
- Target name and scheme: `ios`.
- SwiftUI app entry: `IOSApp` in `apps/ios/ios/IOSApp.swift`.
- Avoid top-level executable code in modules that declare `@main`.
- Prefer MVVM and Swift Concurrency (`async/await`).
- Add SharedKit via Xcode → Add Packages… → Add Local… → `packages/SharedKit`.

### Backend (Vapor)
- Package at `apps/api`.
- Use Vapor 4, Fluent, and Postgres driver.
- Keep routes in `Sources/App/routes.swift`; configure in `Sources/App/configure.swift`.
- Expose basic health endpoint at `/health`.
- Resources under `Sources/App/Resources` (list with `.copy("Resources")` in target if needed).

### Shared Library (SharedKit)
- SwiftPM library at `packages/SharedKit`.
- Contents: DTOs, validation, shared errors only (no platform code).
- Tests required for public helpers.

### Auth (Future)
- JWTKit for access tokens, BCrypt for secrets.
- Refresh-token rotation, OIDC (Apple/Google) later.

### Infra & CI
- Docker compose at `infra/docker/compose.yml` runs Postgres + API.
- CI builds `project-tbd.xcworkspace` scheme `ios`, and runs SwiftPM tests for API/SharedKit.

### Tooling
- Format with `swiftformat` (see `.swiftformat`).
- Lint with `swiftlint` (see `.swiftlint.yml`).
- Make targets:
  - `make format`, `make lint`, `make test-packages`, `make api-dev`.


