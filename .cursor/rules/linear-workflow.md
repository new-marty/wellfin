# Linear Issue Management

Team: new-marty / Project: wellfin

## Issue Hygiene

### Creating Issues

- **Create small, outcome-focused issues** with clear acceptance criteria
- Apply **exactly one** `type/*` label:

  - `type/epic` - High-level feature containing multiple stories
  - `type/story` - User story or feature implementation
  - `type/task` - Technical task or implementation work
  - `type/spike` - Research or exploration task
  - `type/bug` - Bug fix
  - `type/docs` - Documentation work
  - `type/chore` - Maintenance, dependencies, tooling

- Apply **at least one** `area/*` label (can have multiple):

  - `area/api` - Backend/API work (Vapor, Swift)
  - `area/ios` - iOS app work (SwiftUI, UIKit)
  - `area/infra` - Infrastructure, deployment, Docker, CI/CD
  - `area/design` - UI/UX design work, wireframes, design system
  - `area/data` - Data model, migrations, database, integrations

- Use workflow labels sparingly:
  - `workflow/blocked` - ONLY when coordination is needed or blocked by external factors
  - `workflow/needs-spec` - Needs product or technical specification

### Epic Structure

Epics should define:

- **Scope** - What's included and what's not
- **Acceptance Criteria** - High-level success measures
- **MVP Reference** - Link to `docs/product/mvp/mvp-scope.md`
- **Wireframes** - Link to `docs/ui-ux/wireframes/` if applicable

Example:

```
Title: User Authentication System
Labels: type/epic, area/api, area/ios, area/data
Description:
- Scope: email/password login, JWT auth, password reset
- Out of scope: OAuth, MFA
- Acceptance criteria:
  - [ ] Users can register with email/password
  - [ ] Users can log in and receive JWT token
  - [ ] API endpoints validate JWT tokens
- MVP reference: docs/product/mvp/mvp-scope.md
```

### Story Structure

Stories should:

- Have a parent epic
- Be completable in 1-3 days
- Include specific acceptance criteria
- List dependencies using issue relations

Example:

```
Story 1: Design login/registration wireframes
Labels: type/story, area/design
Parent: User Authentication System

Story 2: Implement authentication API
Labels: type/story, area/api
Parent: User Authentication System
Blocked by: Story 1

Story 3: Build iOS login screens
Labels: type/story, area/ios
Parent: User Authentication System
Blocked by: Story 1, Story 2
```

## Dependency Management

### Use Issue Relations (Not Just Labels!)

**Required:** Use Linear's issue relations to track dependencies:

- **Blocked by** - This issue cannot start until another is complete
- **Blocks** - This issue blocks another from starting
- **Related** - General relationship without blocking
- **Duplicate** - Mark duplicates

**Why?** Parent/child relationships show hierarchy but NOT dependencies.

### When to Use workflow/blocked

✅ **Use when:**

- Waiting on external API/service
- Waiting on another team member's work
- Technical blocker needs investigation
- Design assets not ready

❌ **Don't use when:**

- Issue just hasn't been started yet (use status instead)
- Low priority (that's not the same as blocked)
- Waiting on yourself

**Remember:** Always add a "Blocked by" relation when using `workflow/blocked`!

## ❌ Don't Create Epic-Specific Labels

**Wrong approach:**

- `epic/authentication`
- `epic/transactions`
- `feature/transaction-tagging`

**Why not?**

1. Label explosion - need new label for every epic
2. Hard to maintain - labels persist after completion
3. Redundant - parent/child relationships already show this
4. Can't navigate - can't click through to epic details

**✅ Correct approach:**

- Use `type/epic` label + parent/child relationships
- Search by parent: `parent:WEL-123`
- Use issue relations: `Blocks`/`Blocked by`
- Use Linear's hierarchy view

## Finding Work

### Common Filters

```
assignee:me status:"In Progress"
area/api -workflow/blocked
parent:WEL-123
blocks:WEL-456
type/epic
```

### Workflow Queries

- **My current work:** `assignee:me status:"In Progress"`
- **Unblocked API work:** `area/api -workflow/blocked status:Todo`
- **All stories in an epic:** `parent:WEL-123`
- **What this blocks:** `blocks:WEL-456`
- **What blocks this:** `blocked-by:WEL-123`

## GitHub Integration

### Link PRs to Linear

Include Linear issue URL in PR description:

```markdown
Fixes https://linear.app/new-marty/issue/WEL-123/implement-login-endpoint

## Changes

- Added POST /auth/login endpoint
- Implemented JWT token generation with JWTKit

## Testing

- Added unit tests for AuthService
- Tested with Postman

## Related Issues

- Blocked by: WEL-100 (database schema)
- Blocks: WEL-125 (iOS login screen)
```

Linear will automatically detect and link the PR.

## AI Assistant Guidelines - Linear MCP

When creating Linear issues via Cursor MCP, **ALWAYS** include these settings:

### Required Fields for Every Issue

**1. Labels (REQUIRED)**

Type (exactly one):

- `type/epic` - High-level feature
- `type/story` - User story
- `type/task` - Technical task
- `type/spike` - Research
- `type/bug` - Bug fix
- `type/docs` - Documentation
- `type/chore` - Maintenance

Area (at least one, can have multiple):

- `area/api` - Backend/API work
- `area/ios` - iOS app work
- `area/infra` - Infrastructure
- `area/design` - UI/UX design
- `area/data` - Data/database

Workflow (optional):

- `workflow/blocked` - Only when blocked
- `workflow/needs-spec` - Needs specification

**2. Description with Acceptance Criteria**

Always include:

```markdown
## Description

[Clear description of what needs to be done]

## Acceptance Criteria

- [ ] Specific measurable outcome 1
- [ ] Specific measurable outcome 2
- [ ] Specific measurable outcome 3

## References

- docs/product/mvp/mvp-scope.md
- docs/ui-ux/wireframes/
```

**3. Relationships (when applicable)**

- `parent` - Link stories to parent epic
- Issue relations - Use `blocked by:` or `blocks:` for dependencies

**4. Additional Settings (when known)**

- `assignee` - User email, name, or "me"
- `priority` - 0=None, 1=Urgent, 2=High, 3=Normal, 4=Low (only when specified)
- `state` - "Todo", "In Progress", "Backlog"
- `dueDate` - ISO format: YYYY-MM-DD

### Complete MCP Examples

**Example 1: Epic**

```
Create Linear issue:
Title: User Authentication System
Labels: type/epic, area/api, area/ios, area/data
Description:
## Scope
- Email/password login
- JWT token authentication
- Password reset flow

## Acceptance Criteria
- [ ] Users can register with email/password
- [ ] Users can log in and receive JWT
- [ ] API validates JWT tokens
- [ ] iOS app stores auth tokens

## MVP Reference
docs/product/mvp/mvp-scope.md
```

**Example 2: Story with Dependencies**

```
Create Linear issue:
Title: Implement authentication API endpoints
Labels: type/story, area/api
Parent: WEL-100
Blocked by: WEL-101
Assignee: me
Description:
## Description
Build REST API endpoints for user auth (register, login, refresh).

## Acceptance Criteria
- [ ] POST /auth/register endpoint
- [ ] POST /auth/login endpoint
- [ ] POST /auth/refresh endpoint
- [ ] Integration tests added
- [ ] Error handling complete

## References
- API routes: apps/api/Sources/App/routes.swift
- Architecture: docs/ARCHITECTURE.md
```

**Example 3: Task**

```
Create Linear issue:
Title: Add database indexes for user queries
Labels: type/task, area/data
Parent: WEL-100
Priority: 2
Description:
## Description
Add indexes to optimize user lookup queries.

## Acceptance Criteria
- [ ] Index on users.email (unique)
- [ ] Index on users.created_at
- [ ] Migration script created
- [ ] Performance tested

## Technical Notes
Use Fluent migrations in apps/api/
```

**Example 4: Blocked Task**

```
Create Linear issue:
Title: Write integration tests for login
Labels: type/task, area/api, workflow/blocked
Blocked by: WEL-102
Description:
## Description
Write integration tests for complete login flow.

## Acceptance Criteria
- [ ] Test successful login
- [ ] Test invalid credentials
- [ ] Test expired tokens
- [ ] All edge cases covered

## Blocked By
WEL-102 (API endpoints) must be complete first.
```

### Validation Checklist

Before creating any issue, verify:

- [ ] Exactly one `type/*` label
- [ ] At least one `area/*` label
- [ ] Parent ID if story under epic
- [ ] Issue relations for dependencies
- [ ] Acceptance criteria with `- [ ]` checkboxes
- [ ] References to docs
- [ ] Descriptive title
- [ ] Assignee if known
- [ ] `workflow/blocked` + relation if blocked

## Documentation References

- Full guide: `docs/operations/linear-setup.md`
- Cursor MCP usage: `docs/operations/cursor-mcp.md`
- Operations overview: `docs/operations/index.md`
