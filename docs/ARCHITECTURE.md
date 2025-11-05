## Final Architecture: Full-Swift Stack (Vapor)

### Overview

Both iOS app and backend are built in Swift, sharing models, validation, and errors through a shared Swift package (`SharedKit`). The backend uses Vapor (SwiftNIO) and runs in Docker for environment parity.

### Components

- Frontend: iOS (SwiftUI/UIKit)
- Backend: Vapor 4 + SwiftNIO (REST API + async/await)
- ORM / DB: Fluent + PostgreSQL
- Shared Library: Swift Package `SharedKit` (DTOs, validation, errors)
- Auth: JWTKit + BCrypt (self-hosted access/refresh tokens)
- Infra: Docker (Compose locally; Fly.io/ECS/Render for deploy)
- AWS SDK: Soto (optional for S3/SES/etc.)
- Testing: XCTVapor (API), XCTest (SharedKit/iOS)

### Why Swift End-to-End

- Developer velocity: one language, Codable, async/await across client and server
- Type-safety & consistency via shared DTOs and errors
- Fewer dependencies (no Node/TS stack required)
- Zero SaaS cost for auth (self-hosted with JWTKit/BCrypt)
- Maintainability and performance (SwiftNIO)

### Folder Structure

```
repo/
├─ apps/
│  ├─ api/                # Vapor backend
├─ packages/
│  └─ SharedKit/          # DTOs, errors, validation
├─ infra/
│  └─ docker/             # Dockerfile + docker-compose.yml
└─ docs/                  # Architecture, integrations, roadmap
```

The current iOS app is at the root to preserve Xcode paths. It can be moved into `apps/ios/` later by moving the app folder and `.xcodeproj` together.

### Auth Design

- Access token: short-lived (5–15 min)
- Refresh token: hashed in DB, rotated on use
- Email+Password, Magic Link, and OIDC (Apple/Google) converge on single token issuer
- Optional MFA via TOTP

### CI/CD

- GitHub Actions: swift build + test, build Docker image
- macOS runner can build iOS; optional and allowed to be flaky initially

### Roadmap (MVP → v1)

1. SharedKit DTOs and validation
2. Auth MVP (email/password, JWT, refresh rotation)
3. Zaim integration adapter
4. Containerize & deploy
5. iOS client integration using SharedKit (SPM local)
6. Tests and hardening (rate limiting, logging)
7. Enhancements (magic links, TOTP MFA, visualizations)





