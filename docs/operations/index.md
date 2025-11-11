# Operations Documentation

This directory contains operational documentation for the wellfin project.

## Contents

### [Linear Setup & Best Practices](./linear-setup.md)
Complete guide for using Linear to manage work, including:
- Issue hierarchy (epics, stories, tasks)
- Dependency management using issue relations
- Labeling strategy
- GitHub integration
- Workflow tips and examples

**Start here** if you're setting up Linear or want to understand our workflow.

### [Cursor MCP Integration](./cursor-mcp.md)
Guide for using Cursor's Model Context Protocol with Linear:
- Creating and updating issues from Cursor
- Searching and filtering issues
- Workflow integration examples
- Quick reference for common commands

**Use this** when working in Cursor and need to interact with Linear.

## Quick Links

- Linear Project: https://linear.app/new-marty/project/wellfin-d1e57acddb81
- GitHub Repository: https://github.com/new-marty/wellfin
- Team Workspace: https://linear.app/new-marty

## Key Conventions

### Issue Labeling

**Required labels:**
- Exactly one `type/*` label (epic, story, task, spike, bug, docs, chore)
- At least one `area/*` label (api, ios, infra, design, data)

**Optional labels:**
- `workflow/blocked` - Only when coordination is needed
- `workflow/needs-spec` - Needs product/technical specification

### Dependencies

- Use **issue relations** (`Blocks`/`Blocked by`) to track dependencies
- Don't rely on parent/child relationships alone
- Always add a relation when using `workflow/blocked`

### Issue Naming

✅ **Good:**
- "Implement JWT authentication middleware"
- "Design transaction list wireframe"
- "Add database indexes for transaction queries"

❌ **Bad:**
- "Auth"
- "Fix stuff"
- "Update the thing"

## Resources

- MVP Scope: `docs/product/mvp/mvp-scope.md`
- Architecture: `docs/ARCHITECTURE.md`
- UI/UX Docs: `docs/ui-ux/index.md`
- Wireframes: `docs/ui-ux/wireframes/`
- Cursor Rules: `.cursor/rules/` - See https://cursor.com/docs/context/rules

