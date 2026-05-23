# Guide: Artifacts

How to add, remove, and understand the artifact system.

For reference schemas: `reference/artifact-frontmatter.md`, `reference/artifact-lifecycle.md`, `reference/artifact-dep-graph.md`.

---

## How artifact types are defined

`_registry.md` is the source of truth. Every artifact type must have:
- An entry under **Artifact Types** (grouped by SDLC phase)
- An ID prefix entry under **ID Prefixes**

The folder structure mirrors the registry. Each type gets one folder under the vault root. See `reference/folder-structure.md` for the full layout.

---

## Adding a new artifact type

Do all five steps — partial additions cause broken refs and missing ownership.

**1. Create the folder**
```bash
mkdir {vault-root}/{artifact-type-plural}/
```

**2. Register the type in `_registry.md`**
- Add the type name under the appropriate SDLC phase group in **Artifact Types**
- Add a prefix line under **ID Prefixes**: `{type-name} : {prefix}-`
- Update `updated:` date

**3. Create the template**

Add `templates/{artifact-type}.md`. Every template needs:
- A frontmatter block with all required fields (`id`, `type`, `owner`, `status`, `version`, `feature`, `refs`)
- Section headings that define the artifact's shape
- `{placeholder}` syntax for values the author fills in

Use an existing template (e.g., `templates/feature.md`) as a structural starting point.

**4. Assign ownership**

Edit `reference/artifact-ownership.md` — add the new type to the ownership table under the appropriate agent role. If a new role is needed, see `handbook/guide/agent-skills.md`.

**5. Place in the dependency graph**

Edit `reference/artifact-dep-graph.md`:
- Add the type to the correct **Group** row in the Groups table
- Add intra-group dependency edges to the **Intra-Group Dependencies** diagram if the type depends on or is depended on by other types in its group
- Add inter-group rows to the **Inter-Group Matrix** if it crosses group boundaries
- Add the type to the **Creation Order** table

Also update the narrative companion `handbook/artifact-dependency-graph.md` — add a note under the relevant per-group section.

---

## Removing an artifact type

Use `handbook/playbooks/cleanup-artifacts.md` Part B — it walks through file removal, registry update, and dep graph cleanup with confirmation steps.

Do not delete an artifact type folder if any accepted artifacts still live there. Archive them first or confirm with the team that the history is disposable.

---

## Frontmatter conventions

Every artifact starts with YAML frontmatter. Required fields:

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

Rules:
- `id` is globally unique, lowercase, hyphen-separated — no integers, no timestamps
- `feature` must exist in `_registry.md` before the artifact is created
- `refs` lists every artifact this one depends on or is related to — used for impact queries and navigation
- `status` is informational, not enforced; see `reference/artifact-lifecycle.md` for the label set

---

## Naming files

File name = artifact ID + `.md`. Place in the correct folder.

```
requirements/req-user-authentication.md
api-contracts/api-user-authentication.md
tasks/task-token-generation-be.md
```

---

## Finding artifacts

Grep recipes for common lookups are in `reference/vault-queries.md`. Most useful:

```bash
# All artifacts for a feature
grep -rl "feature: {slug}" . --include="*.md"

# All artifacts referencing another artifact
grep -rl "refs:.*{artifact-id}" . --include="*.md"

# All open change requests
grep -rl "status: open" change-requests/ --include="*.md"
```
