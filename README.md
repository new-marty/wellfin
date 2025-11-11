## WellFin Monorepo

This repository contains WellFin, a personal finance tracking app with a modern UI (iOS) and a Swift-based backend using Vapor. It follows a full-Swift stack architecture with a shared package for DTOs, validation, and errors.

### UI/UX Documentation

See `docs/ui-ux/` for the 2B UI architecture, IA, wireframes, tagging, suggestions, onboarding, unique interactions, data visualization, MVP, and references. Start with `docs/ui-ux/README.md`.

### Quick Start

- iOS app now lives at `apps/ios/ios` with project `apps/ios/ios.xcodeproj`.
- Backend and shared code live under `apps/api` and `packages/SharedKit` respectively.

#### Backend (Vapor)

```bash
cd apps/api
swift build
swift test
# or run via Docker Compose
cd ../../infra/docker
docker compose up --build
```

#### SharedKit (Shared Swift Package)

```bash
cd packages/SharedKit
swift build
swift test
```

### Project Structure

```
wellfin/
├─ wellfin.xcworkspace     # Root workspace (open this in Cursor)
├─ apps/
│  ├─ api/                    # Vapor backend (Vapor 4)
│  │  ├─ Sources/App/
│  │  │  └─ Resources/        # runtime resources (empty placeholder ok)
│  │  ├─ Sources/Run/
│  │  └─ Tests/
│  └─ ios/
│     ├─ ios/                 # iOS app sources
│     └─ ios.xcodeproj/       # Xcode project
├─ packages/
│  └─ SharedKit/              # Shared DTOs, validation, errors
├─ infra/
│  └─ docker/                 # Dockerfile + docker-compose
├─ .github/workflows/         # CI
├─ .cursor/                   # Cursor rules and config
└─ docs/                      # Architecture, integrations, roadmap
```

> Note: We migrated the iOS app to `apps/ios/` and updated the project to point at the new `ios` folder.

### Developing in Cursor (Swift + Xcode + Sweetpad)

1. Prerequisites

- Install Xcode (latest) and Command Line Tools
- Install Homebrew tools:
  ```bash
  brew install xcode-build-server xcbeautify swiftformat swiftlint
  ```
- In Cursor, install extensions: “Swift Language Support” and “Sweetpad”.

2. Open the workspace at repo root

- Open `wellfin.xcworkspace` in Cursor (File → Open Workspace…)
- In Xcode (optional), ensure the `ios` scheme is Shared (Product → Scheme → Manage Schemes… → Shared ✓)

3. Generate build server config (enables IntelliSense/LSP)

- Command Palette → “Sweetpad: Generate Build Server Config”
  - Workspace: `/Users/yumabuchi/dev/wellfin/wellfin.xcworkspace`
  - Scheme: `ios`
- If autocompletion is flaky, perform one build in Xcode, then re-run the command above.

4. Run and debug

- iOS app (Simulator) via Sweetpad:
  - Select scheme: `ios`, destination: an installed iOS 26.x simulator (e.g., iPhone 17 Pro)
  - Press Run (F5)
- iOS app (Terminal):
  ```bash
  xcodebuild \
    -workspace wellfin.xcworkspace \
    -scheme ios \
    -destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.0.1" \
    build
  ```
- Backend (Vapor):
  ```bash
  cd apps/api
  swift build && swift test
  swift run Run
  ```
- SharedKit tests:
  ```bash
  cd packages/SharedKit
  swift test
  ```

5. Formatting and linting

```bash
make format   # swiftformat .
make lint     # swiftlint --quiet
```

6. Troubleshooting

- Sweetpad error references old paths:
  - Run "Sweetpad: Clear Build Server Config", then re-run "Generate Build Server Config" targeting `wellfin.xcworkspace` + scheme `ios`.
- “Cannot find module/SharedKit”:
  - Ensure `packages/SharedKit` is added to targets (Vapor via `Package.swift`, iOS via Xcode → Add Packages… → Add Local…)
- “‘main’ attribute cannot be used in a module that contains top-level code”:
  - Remove or disable SwiftUI `#Preview` blocks in the same module, or ensure your toolchain supports the preview macro in your config.
- Simulator destination not found:
  - List installed simulators with `xcrun simctl list devices` and use an exact `name`/`OS` present on your machine.

### Architecture (Full-Swift Stack)

You’ll build both your iOS app and backend in Swift, sharing models via `SharedKit`. The backend uses Vapor 4 + Fluent + PostgreSQL.

- Frontend: SwiftUI/UIKit (iOS)
- Backend: Vapor (SwiftNIO), REST, WebSocket-ready
- ORM/DB: Fluent + PostgreSQL
- Shared Library: `packages/SharedKit` (DTOs, validation, errors)
- Auth: JWTKit + BCrypt (self-hosted)
- Infra: Docker + Compose (local), deploy via Fly.io/ECS/Render
- Tests: XCTVapor for backend, XCTest for SharedKit and iOS

See `docs/ARCHITECTURE.md` for reasoning, trade-offs, and roadmap.

### Cursor Setup (Swift / iOS)

1. Install Xcode and Command Line Tools.
2. Install Homebrew packages:
   ```bash
   brew install xcode-build-server xcbeautify swiftformat swiftlint
   ```
3. In Cursor, install extensions:
   - Swift Language Support
   - Sweetpad
4. Run command palette: `Sweetpad: Generate Build Server Config`.

Detailed instructions are in the workspace README and comments.

### Zaim + Crypto Integrations

MVP focuses on seamless data pulling and storage. Initial design notes in `docs/integrations/zaim.md`. Crypto accounts integration to follow a similar adapter pattern.

### Testing

- The repository includes unit tests for SharedKit and the API.
- You can run all Swift package tests with:
  ```bash
  (cd packages/SharedKit && swift test) && (cd apps/api && swift test)
  ```
