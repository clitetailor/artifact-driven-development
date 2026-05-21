# Artifact Frontmatter & ID Naming

## Required Frontmatter

Every vault artifact starts with YAML frontmatter:

```yaml
---
id: {prefix}-{feature}-{descriptor}
type: {artifact-type}
owner: {agent-slug}
status: draft
version: 1.0
feature: {feature-slug}
refs:
  - {related-artifact-id}
---
```

## Field Notes

- `id` — globally unique; pattern below
- `type` — must exist in `_registry.md`
- `owner` — see `artifact-ownership.md`
- `status` — informational label; see `artifact-lifecycle.md` for common values
- `feature` — must exist in `_registry.md` (add it first if new)
- `refs` — all related artifacts this one references (upstream, downstream, sideways). Used for navigation and impact queries.

## Optional Fields

Task artifacts often carry: `scenario` (links to `req-{slug}#scenario-N`), `milestone`, `estimated-hours`.
Milestone artifacts often carry: `start-date`, `end-date`.

These are conventions, not enforced.

## ID Naming Pattern

`{prefix}-{feature}-{descriptor}` — lowercase, hyphen-separated only.

- No auto-incrementing integers
- No timestamps
- Prefix list is authoritative in `_registry.md`

Examples: `req-user-authentication`, `api-user-authentication`, `task-token-generation-be`, `cr-api-missing-rate-limit`.
