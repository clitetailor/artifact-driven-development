# Customization: artifact-id-dating

> Switches whether artifact IDs carry a creation-date prefix, and which types are dated.
> Switching alternatives = manifest-only edit (replace the `dated_types:` list).
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

Artifact IDs gain an optional `{YYYY-MM-DD}-` creation-date prefix before the type
prefix. The set of types that carry the date prefix depends on the chosen alternative.

This is a **naming convention change**, not a structural change — the dependency graph,
agent ownership, lifecycle, folder structure, and frontmatter fields are unchanged. Only
the ID format and the queries that anchor on IDs move.

**Date semantics:** the date prefix is the **creation date**, set once when the artifact
is first created and never updated — even if the artifact is revised via `needs-review`
or re-accepted. This keeps IDs stable so `refs`/`feature`/`story` links don't break.

---

## Alternatives

| Alternative | Dated types | Undated types |
|---|---|---|
| `none` | — | all 15 |
| `snapshot-style` | 10 snapshot types | 5 living types |
| `all` | all 15 | — |

### Dated type sets per alternative

| Type | Prefix | `none` | `snapshot-style` | `all` |
|---|---|---|---|---|
| feature-brief | `fb-` | — | ✓ | ✓ |
| prd | `prd-` | — | ✓ | ✓ |
| press-release | `pr-` | — | ✓ | ✓ |
| user-story | `story-` | — | ✓ | ✓ |
| user-flow | `uf-` | — | ✓ | ✓ |
| adr | `adr-` | — | ✓ | ✓ |
| tech-design | `td-` | — | ✓ | ✓ |
| task | `task-` | — | ✓ | ✓ |
| plan | `plan-` | — | ✓ | ✓ |
| note | `note-` | — | ✓ | ✓ |
| system-architecture | `sa-` | — | — | ✓ |
| api-spec | `api-` | — | — | ✓ |
| data-design | `dd-` | — | — | ✓ |
| design-spec | `ds-` | — | — | ✓ |
| test-spec | `ts-` | — | — | ✓ |

**`snapshot-style` rationale:** date types whose creation date carries meaning —
snapshot-style artifacts that serve as point-in-time anchors for derivative works
(`prd`, `feature-brief`, `press-release`, `user-story`, `user-flow`, `tech-design`) or
frozen records (`adr`, `task`, `plan`, `note`). Leave undated the types that iterate
throughout the project lifecycle (`system-architecture`, `api-spec`, `data-design`,
`design-spec`, `test-spec`).

---

## Template placeholder reference

Templates use parameterized placeholders so that prefix and folder changes (including
dating) are manifest-only edits. Three placeholder forms:

| Placeholder | Used for | Example expansion |
|---|---|---|
| `{prefix}-{slug}` | Own `id:` field | `prd-user-auth` or `2026-06-21-prd-user-auth` (date prefix added per manifest `dated` flag) |
| `{<type>-id}` | Cross-reference to another artifact's full concrete ID — frontmatter fields, `refs:`/`depends-on:` lists, prose, table cells, hierarchy trees | `2026-06-21-prd-user-auth` |
| `{<type>-link}` | Full markdown link to another artifact — `## References` section, inline links | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |

`<type>` is the type's prefix stem (e.g. `prd`, `sa`, `task`, `story`, `fb`). The agent
filling the template copies the referenced artifact's full concrete ID (including date
prefix if dated) — it already knows the referenced artifact's ID.

### Parenthetical aliases for separation disambiguation

When the same placeholder type appears multiple times in close proximity and the reader
could reasonably wonder whether the occurrences refer to the same or different artifacts,
a **parenthetical alias** annotates each occurrence with its role:

```
{<type>-id (role)}     {<type>-link (role)}
```

The text in parentheses is a human-readable label describing which specific artifact this
occurrence refers to — it is not filled in by the agent (the agent replaces the entire
`{...}` expression with the concrete ID/link). Use parenthetical aliases only at
separation-concern sites (e.g. `{task-id (be-task)} → {task-id (fe-task)}` in a critical
path, or `{story-id (story-1)}, {story-id (story-2)}` in a multi-story table cell). Sites
where a placeholder type appears once in a context need no alias — the context itself is
unambiguous.

Parentheses (not pipe) are used because the pipe character collides with markdown's table
column separator — `{story-id | story-1}` inside a table cell breaks the column count.
Parentheses are inert in both YAML frontmatter and markdown tables.

### Placeholder contexts

| Context | Placeholder | Example expansion |
|---|---|---|
| Frontmatter field | `{prd-id}` | `feature: 2026-06-21-prd-user-auth` |
| `refs:` list | `{prd-id}` | `- 2026-06-21-prd-user-auth` |
| `depends-on:` list | `{task-id}` | `- 2026-06-21-task-token-generation-be` |
| `scenario:` with fragment | `{prd-id}#scenario-{N}` | `scenario: 2026-06-21-prd-user-auth#scenario-1` |
| Entity reference with fragment | `{dd-id}.{Entity}` | `dd-user-auth.User` |
| Markdown link (References section) | `{prd-link}` | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |
| Inline markdown link (body) | `{adr-link}` | `[2026-06-21-adr-auth-strategy](../adrs/2026-06-21-adr-auth-strategy.md)` |
| Prose / table cell | `{prd-id}` | `2026-06-21-prd-user-auth` |
| Hierarchy tree (plan.md) | `{task-id}` | `2026-06-21-task-token-generation-be` |

---

## Apply

1. **Read `manifest.yaml`** — check the current `dated_types:` list. If it already
   matches the chosen alternative's set, skip to Verify.

2. **`manifest.yaml`:** Replace the `dated_types:` list with the chosen alternative's
   set of type names (from the dated type sets table above). This is the only edit
   needed — templates are already parameterized and resolve the date prefix from the
   manifest at fill time.

   - `none` → `dated_types: []`
   - `snapshot-style` → `dated_types: [feature-brief, prd, press-release, user-story, user-flow, adr, tech-design, task, plan, note]`
   - `all` → `dated_types: [feature-brief, prd, press-release, user-story, user-flow, adr, tech-design, task, plan, note, system-architecture, api-spec, data-design, design-spec, test-spec]`

3. **Run Verify** (below) to catch misses.

---

## Verify

```bash
# `none`: empty list
rg "^dated_types: \[\]" manifest.yaml
# Expected: 1 match

# `snapshot-style`: list contains exactly the 10 snapshot types, no living types
rg "^dated_types: \[" manifest.yaml
# Expected: 1 match — visually confirm the list matches:
#   [feature-brief, prd, press-release, user-story, user-flow, adr, tech-design, task, plan, note]
# Living types absent:
rg "^dated_types: \[.*system-architecture" manifest.yaml
# Expected: 0 hits
rg "^dated_types: \[.*api-spec" manifest.yaml
# Expected: 0 hits
rg "^dated_types: \[.*data-design" manifest.yaml
# Expected: 0 hits
rg "^dated_types: \[.*design-spec" manifest.yaml
# Expected: 0 hits
rg "^dated_types: \[.*test-spec" manifest.yaml
# Expected: 0 hits

# `all`: list contains all 15 types
rg "^dated_types: \[" manifest.yaml
# Expected: 1 match — visually confirm the list matches:
#   [feature-brief, prd, press-release, user-story, user-flow, adr, tech-design, task, plan, note, system-architecture, api-spec, data-design, design-spec, test-spec]
```

---

## Notes

- **Orthogonality with `requirements-root.md`:** This customization is orthogonal to the
  requirements-root customization. Both are manifest-driven — the two touch disjoint
  manifest fields (`dated_types:` list vs. `feature_type:` field) and disjoint aspects of
  the ID (date prefix vs. type prefix). Apply in any order.

- **Orthogonality with `ask-threshold.md`:** No interaction — different files entirely.

- **`plan` is the weakest fit in the `snapshot-style` dated set.** Plans get
  re-sequenced as work progresses — more living than the other dated types. Kept dated
  on the "frozen record" rationale; the creation date may go stale faster here than
  elsewhere. Acceptable trade-off for chronological sortability in the `plans/` folder.

- **Migration caveat for existing vaults:** If the vault already contains artifacts with
  un-dated IDs, applying this customization changes templates and conventions but does **not**
  retroactively rename existing artifact files. Existing artifacts keep their un-dated
  IDs; new artifacts created from updated templates get dated IDs. A separate migration
  pass (not covered by this customization) would be needed to rename existing files and
  update all `refs`/`feature`/`story` links pointing at them.
