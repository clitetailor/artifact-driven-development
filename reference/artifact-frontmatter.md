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
- `refs` — all related artifact IDs this one references (upstream, downstream, sideways). Plain IDs only — no markdown syntax. Used for grep-based queries and impact analysis. For human-navigable links, add a `## References` section at the bottom of the artifact body (see below).

## Optional Fields

Task artifacts often carry: `story` (links to `story-{slug}`), `milestone`, `estimated-hours`.
Milestone artifacts often carry: `start-date`, `end-date`.
PRD artifacts may carry: `prd` (the `{charter-slug}/{prd-slug}` path from the registry) for sub-charter scoping.

These are conventions, not enforced.

## References Section (body)

Every artifact must close with a `## References` section containing markdown links that mirror the `refs` frontmatter field. This is the only place markdown links to other artifacts appear.

```markdown
## References
- [Artifact Title](../{folder}/{artifact-id}.md)
```

Rules:
- One link per `refs` entry, in the same order.
- Link text is the artifact ID (agents filling real artifacts may use a descriptive title instead).
- Path is relative from the artifact's own folder to the target file.
- This section is always the **last section** in the document.
- If `refs` is empty (`refs: []`), add the section with a `<!-- none -->` placeholder.

## ID Naming Pattern

`{prefix}-{charter}-{descriptor}` — lowercase, hyphen-separated only.

- No auto-incrementing integers
- No timestamps
- Prefix list is authoritative in `../registry.yaml` under `types`

Examples: `prd-user-authentication-login`, `api-user-authentication`, `task-token-generation-be`, `cr-api-missing-rate-limit`.
