# Cursor MCP Integration with Linear

This document explains how to use Cursor's Model Context Protocol (MCP) integration with Linear to manage issues, projects, and workflow directly from your development environment.

## Overview

Cursor's Linear MCP integration allows you to:

- Create and update issues
- Search and filter issues
- Add labels and set relationships
- Link issues to code changes
- View project status

All without leaving your editor!

## Prerequisites

- Cursor IDE installed
- Linear API key configured in Cursor
- Access to the new-marty Linear workspace

## Common MCP Commands

### Listing Issues

**View your current work:**

```
Show me my in-progress issues
```

**Filter by project:**

```
List all issues in the wellfin project
```

**Filter by labels:**

```
Show all area/api issues that are blocked
```

**Filter by assignee:**

```
Show all issues assigned to me in the API area
```

### Creating Issues

**Create a story:**

```
Create a Linear issue:
Title: Implement transaction search endpoint
Type: story
Area: api
Description: Add GET /transactions/search endpoint with filtering
Parent: Transaction Management Epic
```

**Create a task with dependencies:**

```
Create a Linear issue:
Title: Add database indexes for transaction queries
Type: task
Area: data
Blocked by: WEL-123 (needs schema finalized)
```

### Updating Issues

**Update status:**

```
Update Linear issue WEL-123 status to "In Progress"
```

**Add labels:**

```
Add labels area/ios and type/story to WEL-456
```

**Add dependencies:**

```
Update WEL-789 to be blocked by WEL-123
```

**Mark as blocked:**

```
Add workflow/blocked label to WEL-456 and mark it as blocked by WEL-123
```

### Searching and Filtering

**Find related work:**

```
Search for all authentication related issues
```

**Check dependencies:**

```
Show me all issues that block WEL-123
```

**Find unblocked work:**

```
Show me pending issues in area/api that are not blocked
```

## Workflow Integration

### Starting New Work

1. **Check for unblocked issues:**

   ```
   Show me pending area/api issues not blocked
   ```

2. **Update status:**

   ```
   Move WEL-123 to "In Progress" and assign to me
   ```

3. **Create a branch:**
   ```
   Create a git branch for WEL-123
   ```

### During Development

**Add notes to the issue:**

```
Add comment to WEL-123: "Implemented JWT validation, needs testing"
```

**Create follow-up tasks:**

```
Create a task:
Title: Add integration tests for login endpoint
Area: api
Type: task
Related to: WEL-123
```

### Completing Work

1. **Create PR with Linear reference**
2. **Update issue status:**

   ```
   Complete WEL-123
   ```

3. **Check for unblocked downstream work:**
   ```
   Show issues blocked by WEL-123
   ```

## Best Practices

### 1. Use Natural Language

Cursor's AI understands context. Instead of rigid commands, describe what you want:

✅ "Create an epic for user authentication with stories for API, iOS, and design"
✅ "Show me all blocked iOS issues"
✅ "Update the transaction tagging epic to add acceptance criteria"

### 2. Reference Issues by ID

When you know the issue ID, use it:

```
What's the status of WEL-123?
Add tests to WEL-456
```

### 3. Batch Operations

Group related operations:

```
Create three stories under the User Profile epic:
1. Design user profile wireframes (area/design)
2. Build profile API endpoints (area/api, blocked by #1)
3. Implement iOS profile screen (area/ios, blocked by #2)
```

### 4. Keep Context

Cursor remembers recent conversations:

```
You: "Show me the authentication epic"
Cursor: [shows WEL-100]
You: "Create a story under that epic for password reset"
```

## Common Scenarios

### Scenario 1: Planning a New Feature

```
1. "Create an epic for transaction tagging"
2. "Add these labels: type/epic, area/data, area/api, area/ios"
3. "Now create child stories for each area"
4. "Set up dependencies: iOS blocked by API, API blocked by design"
```

### Scenario 2: Finding Work

```
"Show me unblocked stories in area/api that I can work on"
```

### Scenario 3: Unblocking Work

```
"I just completed WEL-123. Show me what it was blocking and update those issues to remove the blocker"
```

### Scenario 4: Daily Standup Prep

```
"Show my in-progress issues with their latest status"
```

### Scenario 5: Sprint Planning

```
"List all pending stories in the wellfin project, grouped by epic"
```

## Integration with Code

### Linking Code to Issues

When working on an issue, reference it in:

**Commit messages:**

```bash
git commit -m "feat(auth): implement JWT validation [WEL-123]"
```

**PR descriptions:**

```markdown
Fixes https://linear.app/new-marty/issue/WEL-123

## Changes

- Added JWT middleware
- Updated auth tests
```

**Code comments:**

```swift
// TODO(WEL-456): Add retry logic for failed requests
// See: https://linear.app/new-marty/issue/WEL-456
```

### Creating Issues from Code

While reviewing code:

```
Create a task to refactor the authentication service in apps/api/Sources/App/configure.swift
```

## Tips & Tricks

### 1. Quick Status Check

```
"Give me a summary of the wellfin project status"
```

### 2. Dependency Visualization

```
"Show me the dependency chain for the authentication epic"
```

### 3. Label Management

```
"List all available labels in the new-marty team"
```

### 4. Bulk Updates

```
"Mark all stories under the authentication epic as ready for review"
```

### 5. Search by Content

```
"Find issues mentioning Zaim integration"
```

## Troubleshooting

### Issue Not Found

If Cursor can't find an issue:

1. Check the issue ID (WEL-XXX)
2. Ensure you have access to the new-marty workspace
3. Try searching by title instead

### Can't Update Issue

- Verify you have write permissions in Linear
- Check if the issue is archived
- Ensure the status/label exists in your workflow

### Rate Limiting

If you see rate limit errors:

- Wait a few minutes
- Reduce frequency of requests
- Use batch operations instead of individual updates

## Examples

### Complete Epic Creation

```
Create an epic for transaction management with the following:

Title: Transaction Management System
Labels: type/epic, area/data, area/api, area/ios
Description:
- Users can view transaction history
- Filter and search transactions
- Export transaction data
- Tag and categorize transactions

Acceptance Criteria:
- [ ] API endpoints for CRUD operations
- [ ] iOS UI for transaction list
- [ ] Search and filter functionality
- [ ] Export to CSV

Now create child stories:
1. Design transaction list wireframes (area/design, type/story)
2. Create transaction database schema (area/data, type/task)
3. Build transaction API endpoints (area/api, type/story, blocked by #2)
4. Implement iOS transaction list (area/ios, type/story, blocked by #1 and #3)
5. Add search and filter API (area/api, type/story, blocked by #3)
6. Build iOS search UI (area/ios, type/story, blocked by #5)
```

## References

- **Linear Setup:** `docs/operations/linear-setup.md`
- **Operations Overview:** `docs/operations/index.md`
- **Linear API Docs:** https://developers.linear.app/docs
- **Cursor MCP Docs:** https://docs.cursor.com/mcp
- **Cursor Rules:** https://cursor.com/docs/context/rules

## Quick Reference Card

| Task           | Command Example                         |
| -------------- | --------------------------------------- |
| List your work | "Show my in-progress issues"            |
| Create issue   | "Create a story for [description]"      |
| Update status  | "Move WEL-123 to In Progress"           |
| Add labels     | "Add area/api to WEL-123"               |
| Set dependency | "WEL-123 is blocked by WEL-456"         |
| Find related   | "Show issues related to authentication" |
| Check blockers | "What blocks WEL-123?"                  |
| Assign         | "Assign WEL-123 to me"                  |
| Add comment    | "Comment on WEL-123: [text]"            |
| Close issue    | "Complete WEL-123"                      |
