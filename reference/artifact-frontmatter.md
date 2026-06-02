# Artifact Frontmatter & ID Naming

## Required Frontmatter

Every vault artifact starts with YAML frontmatter:

```yaml
---
id: {prefix}-{charter}-{descriptor}
type: {artifact-type}
owner: {agent-slug}
status: draft
version: 1.0
charter: {charter-slug}
refs:
  - {related-artifact-id}
---
```

## Field Notes

- `id` — globally unique; pattern below
- `type` — must exist in `../registry.yaml` under `types`
- `owner` — see `artifact-ownership.md`
- `status` — informational label; see `artifact-lifecycle.md` for common values
- `charter` — charter slug; must correspond to an existing `project-charters/charter-{slug}.md` artifact on disk
- `refs` — all related artifacts this one references (upstream, downstream, sideways). Used for navigation and impact queries.

## Optional Fields

Task artifacts often carry: `story` (links to `story-{slug}`), `milestone`, `estimated-hours`.
Milestone artifacts often carry: `start-date`, `end-date`.
PRD artifacts may carry: `prd` (the `{charter-slug}/{prd-slug}` path from the registry) for sub-charter scoping.

These are conventions, not enforced.

## ID Naming Pattern

`{prefix}-{charter}-{descriptor}` — lowercase, hyphen-separated only.

- No auto-incrementing integers
- No timestamps
- Prefix list is authoritative in `../registry.yaml` under `types`

Examples: `prd-user-authentication-login`, `api-user-authentication`, `task-token-generation-be`, `cr-api-missing-rate-limit`.
