# Documentation Standards

## File Naming Convention

### ✅ Use index.md (Not README.md)

**Rule:** Use `index.md` for directory indexes, except for the root repository README.

**Correct:**
```
/README.md                        # Root only
/docs/operations/index.md         # Directory index
/docs/ui-ux/index.md             # Directory index
/docs/product/mvp/index.md       # Directory index
```

**Incorrect:**
```
/docs/operations/README.md       # ❌ Use index.md
/docs/ui-ux/README.md           # ❌ Use index.md
```

**Rationale:**
- `index.md` is the web standard for directory landing pages
- Reduces confusion with repository root README
- Makes URL structure cleaner (auto-resolves to directory)
- Consistent with documentation site generators

### Documentation Structure

```
docs/
├── operations/
│   ├── index.md              # Operations overview
│   ├── linear-setup.md       # Linear workflow guide
│   └── cursor-mcp.md         # Cursor MCP integration
├── product/
│   ├── mvp/
│   │   └── mvp-scope.md      # MVP scope definition
│   └── vision/
│       └── product-vision.md # Product vision
├── ui-ux/
│   ├── index.md              # UI/UX overview
│   ├── wireframes/
│   │   └── pages/            # Page wireframes
│   └── foundations/          # Design foundations
└── ARCHITECTURE.md           # Top-level architecture doc
```

## Documentation Content Guidelines

### When to Update Docs

Update documentation when:
- Adding or changing features
- Modifying architecture or tech stack
- Changing development workflows
- Creating new Linear issue patterns
- Updating project structure

### Reference Relevant Docs

In code comments and PRs, reference docs using relative paths:
```swift
// See architecture decisions: docs/ARCHITECTURE.md
// UI/UX guidelines: docs/ui-ux/index.md
// MVP scope: docs/product/mvp/mvp-scope.md
```

### Cross-References

Use relative links in markdown:
```markdown
See [Linear Setup](./operations/linear-setup.md) for workflow details.
Refer to [MVP Scope](../product/mvp/mvp-scope.md) for feature priorities.
View [wireframes](./ui-ux/wireframes/pages/) for UI reference.
```

## Directory Index Content

Each `index.md` should contain:

1. **Overview** - Brief description of directory contents
2. **Contents** - List of documents with descriptions  
3. **Quick Links** - Common references
4. **Getting Started** - Entry point for new readers

Example structure:
```markdown
# Section Title

Brief overview of what this section covers.

## Contents

### [Document Name](./document.md)
Description of what this document contains and when to use it.

## Quick Links

- [External Resource](https://example.com)
- [Internal Reference](../other/doc.md)

## Getting Started

Start with [Document Name](./document.md) if you're new.
```

## Markdown Style

### Headers

- Use ATX-style headers (`#`)
- One H1 per document (title)
- Logical hierarchy (don't skip levels)

### Code Blocks

- Always specify language for syntax highlighting
- Use relative paths in examples
- Keep examples concise but complete

### Links

- Use descriptive link text (not "click here")
- Prefer relative paths for internal docs
- Keep external links up to date

### Lists

- Use `-` for unordered lists
- Use `1.` for ordered lists (markdown auto-numbers)
- Consistent indentation (2 spaces)

## AI Assistant Guidelines

When creating or updating documentation:

1. **Check file naming** - Use `index.md` not `README.md` (except root)
2. **Update cross-references** - Fix links when moving/renaming docs
3. **Maintain structure** - Follow existing directory hierarchy
4. **Reference docs in code** - Link to relevant docs in PRs and comments
5. **Keep docs current** - Update docs alongside code changes

