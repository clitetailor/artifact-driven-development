# Artifact Frontmatter & ID Naming

## Required Frontmatter

Every vault artifact starts with YAML frontmatter:

```yaml
---
id: {prefix}-{slug}
type: {artifact-type}
owner: {agent-slug}
status: draft
version: 1.0
refs:
  - {related-artifact-id}
---
```

## Field Notes

- `id` — globally unique; pattern below
- `type` — must exist in `../manifest.yaml` under `types`
- `owner` — see `artifact-ownership.md`
- `status` — informational label; see `artifact-lifecycle.md` for common values
- `refs` — all related artifact IDs this one references (upstream, downstream, sideways). Plain IDs only — no markdown syntax. Used for grep-based queries and impact analysis. For human-navigable links, add a `## References` section at the bottom of the artifact body (see below).

## Optional Fields

Task artifacts often carry: `story` (links to `story-{slug}`), `milestone`, `estimated-hours`.
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD. This links the artifact to its requirements root; see `artifact-dep-graph.md`. The ID format follows the ID Naming Pattern above (dated if the requirements-root type has `dated: true`).

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

`{prefix}-{slug}` — where `{prefix}` comes from `../manifest.yaml` under `types`.
For types with `dated: true`, the ID is `{YYYY-MM-DD}-{prefix}-{slug}`.
Date is creation date only — never updated on revision.

- No auto-incrementing integers
- Date prefix is **creation date only** — never updated on revision or re-acceptance
  (keeps IDs stable so `refs`/`feature`/`story` links don't break)
- Prefix list and `dated` flag are authoritative in `../manifest.yaml` under `types`

Examples: `fb-user-authentication-login`, `api-user-authentication`, `dd-user-authentication`, `2026-06-21-task-token-generation-be`.
