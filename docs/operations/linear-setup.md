# Linear Setup & Best Practices

Team: **new-marty** / Project: **wellfin**

Linear Project: https://linear.app/new-marty/project/wellfin-d1e57acddb81

## Overview

This document defines how we use Linear to manage work for the wellfin project. We follow industry best practices for dependency management, clear issue hierarchy, and effective labeling.

**Key References:**

- [Linear Issue Relations](https://linear.app/docs/issue-relations)
- [Linear Project Dependencies](https://linear.app/docs/project-dependencies)
- [Linear Timeline View](https://linear.app/docs/timeline)

## Issue Hierarchy

### Parent Issues = Epics

- High-level features or objectives
- Contains multiple child issues (stories)
- Apply `type/epic` label
- Example: "User Authentication System"

### Child Issues = Stories/Tasks

- Specific, actionable work items
- Should be completable in 1-3 days
- Apply `type/story` or `type/task` label
- Example: "Implement login API endpoint"

### Sub-stories (if needed)

- Break down complex stories further
- Use sparingly to avoid too much nesting

## Dependency Management

**Problem:** Parent/child relationships show hierarchy but NOT dependencies clearly.

**Solution:** Use Linear's **Issue Relations** feature:

### How to Add Dependencies

1. Open the issue that is blocked
2. Press `Cmd+K` (Mac) or `Ctrl+K` (Windows)
3. Type "Add relation" or click the "…" menu → Relations
4. Select relationship type:
   - **Blocked by** - This issue can't start until another is done
   - **Blocks** - This issue blocks another from starting
   - **Related** - General relationship without blocking
   - **Duplicate** - Mark duplicates

### When to Use Each Relation Type

| Relation Type  | When to Use                                    | Example                                                      |
| -------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| **Blocked by** | Cannot start work until dependency is complete | "Build user profile UI" blocked by "Create user profile API" |
| **Blocks**     | Another issue depends on this being done       | "Database migration" blocks "Deploy to production"           |
| **Related**    | Work is connected but not blocking             | "iOS login screen" related to "API authentication"           |
| **Duplicate**  | Same work tracked in multiple places           | Mark one as duplicate                                        |

## Labeling Strategy

We use a **multi-dimensional labeling system** to make issues easy to filter and understand:

### 1. Type Labels (REQUIRED - exactly one per issue)

- `type/epic` - High-level feature containing multiple stories
- `type/story` - User story or feature implementation
- `type/task` - Technical task or implementation work
- `type/spike` - Research or exploration task
- `type/bug` - Bug fix
- `type/docs` - Documentation work
- `type/chore` - Maintenance, dependencies, tooling

### 2. Area Labels (REQUIRED - at least one per issue)

- `area/api` - Backend/API work (Vapor, Swift)
- `area/ios` - iOS app work (SwiftUI, UIKit)
- `area/infra` - Infrastructure, deployment, Docker, CI/CD
- `area/design` - UI/UX design work, wireframes, design system
- `area/data` - Data model, migrations, database, integrations

**Note:** Issues can have multiple area labels if they span domains.

### 3. Workflow Labels (as needed)

- `workflow/blocked` - Use this ONLY when coordination is needed or blocked by external factors
  - Add a "Blocked by" relation to the blocking issue
  - Remove when unblocked
  - Add a comment explaining why it's blocked
- `workflow/needs-spec` - Needs product or technical specification before work can begin

### 4. Default Labels (legacy - avoid for new issues)

- `Bug` - Something broken that needs fixing (use `type/bug` instead)
- `Feature` - New functionality (use `type/story` or `type/epic` instead)
- `Improvement` - Enhancement to existing functionality (use `type/task` instead)

## ❌ Don't Create Labels for Epics or Individual Features

**Wrong approach:**

- `epic/authentication`
- `epic/transactions`
- `feature/transaction-tagging`

**Why not?**

1. **Label explosion** - Need a new label for every epic/feature
2. **Hard to maintain** - Labels persist after work is complete
3. **Navigation issues** - Can't click through to see epic details
4. **Duplication** - Information already exists in issue hierarchy

**✅ Correct approach:**

Use Linear's built-in features:

- **Parent/child relationships** to show epic → story → task hierarchy
- **`type/epic`** label to identify all epics
- **Issue relations** (`Blocks`/`Blocked by`) for dependencies
- **Linear's hierarchy view** to navigate epic structures
- **Search by parent**: `parent:WEL-123` to find all stories under an epic

Example:

```
Epic WEL-100: User Authentication System
├─ Story WEL-101: Design login wireframes (area/design)
├─ Story WEL-102: Build auth API (area/api, blocked by: WEL-101)
└─ Story WEL-103: Build iOS login UI (area/ios, blocked by: WEL-101, WEL-102)
```

Filter by epic: `parent:WEL-100`
View all epics: `type/epic`
View epic progress: Click epic → View sub-issues

## Issue Hygiene

### Creating Issues

1. **Use descriptive titles**

   - ✅ "Add JWT authentication to user login endpoint"
   - ❌ "Auth stuff"

2. **Write clear acceptance criteria**

   ```markdown
   ## Acceptance Criteria

   - [ ] User can log in with email/password
   - [ ] JWT token is returned on successful login
   - [ ] Invalid credentials return 401 error
   - [ ] Password is hashed with bcrypt
   ```

3. **Apply labels immediately**

   - Exactly one `type/*` label
   - At least one `area/*` label
   - Add `workflow/blocked` only if truly blocked

4. **Set proper parent/child relationships**

   - Stories should have parent epics
   - Tasks can be standalone or under stories

5. **Add dependencies using relations**
   - Don't rely on comments to track dependencies
   - Use "Blocked by" / "Blocks" relations explicitly

### Managing Epics

Epics should include:

1. **Scope** - What's included and what's not
2. **Acceptance Criteria** - High-level success measures
3. **MVP Reference** - Link to relevant MVP scope docs
4. **Wireframes** - Link to UI/UX docs if applicable

Example epic structure:

```markdown
# User Authentication Epic

## Scope

- Email/password login
- JWT token-based auth
- Password reset flow
- Session management

## Out of Scope (for this epic)

- OAuth/social login
- Multi-factor authentication
- Biometric login

## Acceptance Criteria

- [ ] Users can register with email/password
- [ ] Users can log in and receive JWT token
- [ ] API endpoints validate JWT tokens
- [ ] iOS app stores and uses auth tokens
- [ ] Users can reset forgotten passwords

## MVP Reference

See `docs/product/mvp/mvp-scope.md` - Auth section

## Wireframes

See `docs/ui-ux/wireframes/pages/` - Login, Registration flows
```

### Splitting Work by Area

When an epic spans multiple areas (common), create separate child issues per area:

**Epic:** User Profile Feature

- **Story (area/api):** Create user profile API endpoints
- **Story (area/ios):** Build user profile UI screen
- **Story (area/design):** Design user profile wireframes
- **Task (area/data):** Add user profile fields to database schema

Then add dependencies:

- iOS story **blocked by** API story
- API story **blocked by** database task

## GitHub Integration

### Linking PRs to Linear Issues

When creating a PR, include the Linear issue URL in the PR description:

```markdown
Fixes https://linear.app/new-marty/issue/WEL-123/implement-login-endpoint

## Changes

- Added POST /auth/login endpoint
- Implemented JWT token generation
- Added bcrypt password hashing

## Testing

- Added unit tests for auth service
- Tested with Postman collection
```

Linear will automatically detect and link the PR to the issue.

### Setting Up GitHub Integration

1. Go to https://linear.app/new-marty/settings/integrations
2. Click "Add" next to GitHub
3. Authorize Linear to access the new-marty organization
4. Select the `wellfin` repository
5. Configure auto-linking (detect issue IDs like WEL-123 in PR titles/descriptions)

## Workflow Tips

### 1. Use Timeline View for Dependencies

- Navigate to Project view
- Click Display → Timeline view
- Drag from one project/issue to another to create dependencies
- Visual representation helps with planning

### 2. Regular Backlog Grooming

- Review backlog weekly
- Update priorities based on MVP scope
- Close outdated issues
- Split large issues into smaller ones
- Ensure all issues have proper labels and relationships

### 3. Stand-up Efficiency

Filter by:

- Assignee: "me"
- Status: "In Progress"
- Labels: specific area you're working in

### 4. Finding Blocked Work

Filter by:

- Labels: `workflow/blocked`
- Review daily to unblock

### 5. Dependency Queries

Use Linear's search:

```
blocks:WEL-123
blocked-by:WEL-456
```

## Quick Reference

### Issue Creation Checklist

- [ ] Descriptive title
- [ ] Clear acceptance criteria
- [ ] One `type/*` label
- [ ] At least one `area/*` label
- [ ] Parent epic set (for stories)
- [ ] Dependencies added as relations (if any)
- [ ] Description references docs/wireframes (if applicable)

### When to Use workflow/blocked

✅ **Use when:**

- Waiting on external API/service
- Waiting on another team member
- Technical blocker needs investigation
- Design assets not ready

❌ **Don't use when:**

- Just hasn't been started yet (use status instead)
- Low priority (use priority labels if needed)
- Waiting on yourself

**Remember:** Add a "Blocked by" relation when using `workflow/blocked`!

## Example Issue Flow

1. **Create Epic**

   ```
   Title: Transaction Tagging System
   Labels: type/epic, area/data, area/ios, area/api
   Description: Users can tag transactions for categorization
   ```

2. **Create Stories**

   ```
   Story 1: Design transaction tagging UI
   Labels: type/story, area/design
   Parent: Transaction Tagging System

   Story 2: Create transaction tag API
   Labels: type/story, area/api
   Parent: Transaction Tagging System
   Blocked by: Story 1 (needs design specs)

   Story 3: Build iOS tagging screen
   Labels: type/story, area/ios
   Parent: Transaction Tagging System
   Blocked by: Story 2 (needs API)
   ```

3. **Track Progress**
   - Design completes → Remove "blocked by" from Story 2
   - API completes → Remove "blocked by" from Story 3
   - All stories complete → Close epic

## Resources

- **MVP Scope:** `docs/product/mvp/mvp-scope.md`
- **Wireframes:** `docs/ui-ux/wireframes/`
- **Architecture:** `docs/ARCHITECTURE.md`
- **Operations Overview:** `docs/operations/index.md`
- **Cursor MCP Usage:** `docs/operations/cursor-mcp.md`
- **Cursor Rules:** `.cursor/rules/` - See https://cursor.com/docs/context/rules
