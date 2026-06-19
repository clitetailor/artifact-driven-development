# Artifact Frontmatter & ID Naming

## Required Frontmatter

Every vault artifact starts with YAML frontmatter:

```yaml
---
id: {prefix}-{descriptor}
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

Task artifacts often carry: `ticket` (links to `ticket-{slug}`), `story` (links to `story-{slug}`), `milestone`, `estimated-hours`.
Ticket artifacts carry: `kind` (feature | change | defect | investigation | spike | review), `created`, `closed`.
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD (`prd-` prefixed). This links the artifact to its requirements root; see `artifact-dep-graph.md`.

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

`{prefix}-{descriptor}` — lowercase, hyphen-separated only.

- No auto-incrementing integers
- No timestamps
- Prefix list is authoritative in `../manifest.yaml` under `types`

Examples: `fb-user-authentication-login`, `api-user-authentication`, `dd-user-authentication`, `task-token-generation-be`, `ticket-add-rate-limiting`.
