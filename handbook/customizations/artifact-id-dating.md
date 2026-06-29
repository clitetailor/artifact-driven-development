# Customization: artifact-id-dating

> Switches whether artifact IDs carry a creation-date prefix, and which types are dated.
> Switching alternatives = manifest-only edit (replace the `dated_types:` list).
>
> For the apply flow, see `../playbooks/customize-vault.md`.

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

| Alternative | Role | Dated types | Undated types |
|---|---|---|---|
| `none` | Default | — | all |
| `snapshot-style` | Alternative | snapshot-style types (see table below) | living types (see table below) |
| `all` | Alternative | all | — |

The exact dated/undated type sets per alternative live in the table below — that table is the
source of truth and stays correct when types are added (just add a row). No summary count
column is kept here, since it drifts independently of the table.

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
| test-plan | `tp-` | — | ✓ | ✓ |
| note | `note-` | — | ✓ | ✓ |
| system-architecture | `sa-` | — | — | ✓ |
| api-spec | `api-` | — | — | ✓ |
| data-design | `dd-` | — | — | ✓ |
| design-spec | `ds-` | — | — | ✓ |
| test-spec | `ts-` | — | — | ✓ |
| system-capability | `sc-` | — | — | ✓ |
| domain-model | `dm-` | — | — | ✓ |

**`snapshot-style` rationale:** date types whose creation date carries meaning —
snapshot-style artifacts that serve as point-in-time anchors for derivative works
(`prd`, `feature-brief`, `press-release`, `user-story`, `user-flow`, `tech-design`) or
frozen records (`adr`, `task`, `plan`, `test-plan`, `note`). Leave undated the types that
iterate throughout the project lifecycle (`system-architecture`, `api-spec`, `data-design`,
`design-spec`, `test-spec`, `system-capability`, `domain-model`).

---

## Template placeholder reference

Templates use parameterized placeholders so that prefix and folder changes (including
dating) are manifest-only edits. Four placeholder forms:

| Placeholder | Used for | Example expansion |
|---|---|---|
| `{prefix}-{slug}` | Own `id:` field | `prd-user-auth` or `2026-06-21-prd-user-auth` (date prefix added per manifest `dated` flag) |
| `{<type>-id}` | Cross-reference to another artifact's full concrete ID — frontmatter fields, `refs:`/`depends-on:` lists, prose, table cells, hierarchy trees | `2026-06-21-prd-user-auth` |
| `{<type>-link}` | Full markdown link to another artifact — `## References` section, inline links | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |
| `{feature-id}` / `{feature-link}` | Cross-reference or link to the **requirements root** — resolves dynamically from `manifest.yaml`'s `requirements_root:` field (see `requirements-root.md`). Used in all downstream templates that point at the feature root. | `2026-06-21-fb-user-auth` / `[2026-06-21-fb-user-auth](../feature-briefs/2026-06-21-fb-user-auth.md)` (when `requirements_root: feature-brief`) |

`<type>` is the type's prefix stem (e.g. `sa`, `task`, `story`, `fb`). The agent
filling the template copies the referenced artifact's full concrete ID (including date
prefix if dated) — it already knows the referenced artifact's ID.

`{feature-id}` / `{feature-link}` are the option-agnostic form for requirements-root
references: instead of hardcoding `{prd-id}` (which would need swapping when the
requirements-root type changes), they resolve to whatever type `requirements_root:` names. The
agent reads `requirements_root:` from `manifest.yaml`, looks up the type's prefix and folder,
and fills the concrete ID/link accordingly. This makes the requirements-root customization
a manifest-only edit — no template or reference-doc swaps needed.

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
| Frontmatter field | `{feature-id}` | `feature: 2026-06-21-prd-user-auth` |
| `refs:` list | `{feature-id}` | `- 2026-06-21-prd-user-auth` |
| `depends-on:` list | `{task-id}` | `- 2026-06-21-task-token-generation-be` |
| `scenario:` with fragment | `{feature-id}#scenario-{N}` | `scenario: 2026-06-21-prd-user-auth#scenario-1` |
| Entity reference with fragment | `{dd-id}.{Entity}` | `dd-user-auth.User` |
| Markdown link (References section) | `{feature-link}` | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |
| Inline markdown link (body) | `{adr-link}` | `[2026-06-21-adr-auth-strategy](../adrs/2026-06-21-adr-auth-strategy.md)` |
| Prose / table cell | `{feature-id}` | `2026-06-21-prd-user-auth` |
| Hierarchy tree (plan.md) | `{task-id}` | `2026-06-21-task-token-generation-be` |

---

## Per-alternative manifest values

Each alternative is realized by a single `manifest.yaml` edit — replacing the `dated_types:`
list. The values below are the full final state of that line for each alternative.

### `none`

```
dated_types: []
```

### `snapshot-style`

```
dated_types: [feature-brief, prd, press-release, user-story, user-flow, adr, tech-design, task, plan, test-plan, note]
```

This list is the shipped default for the `snapshot-style` alternative (the snapshot-style types
from the dated type sets table above — every type marked ✓ in the `snapshot-style` column). It is
**adjustable** — after applying, you may add or remove type names to tune which types carry the
date prefix. The `all` and `none` alternatives are fixed; `snapshot-style` is the only
alternative whose list is meant to be tuned to your project's needs.

### `all`

```
dated_types: [<every type name from manifest.yaml's types: list>]
```

Populate the list by reading `manifest.yaml`'s `types:` list and collecting every type's
`name:` field, in the order they appear. This auto-adjusts when types are added — no need to
maintain a hardcoded list here. Run the §Verify `all` self-check to confirm the count matches.

---

## Apply

1. **Read `manifest.yaml`** — check the current `dated_types:` list. If it already
   matches the chosen alternative's set, skip to Verify.

2. **`manifest.yaml`:** Replace the `dated_types:` list with the chosen alternative's
   value from its per-alternative section above. This is the only edit needed — templates
   are already parameterized and resolve the date prefix from the manifest at fill time.

3. **Run Verify** (below) to catch misses.

---

## Verify

```bash
# `none`: empty list
rg "^dated_types: \[\]" manifest.yaml
# Expected: 1 match

# `snapshot-style`: list contains exactly the snapshot-style types from the dated type sets
# table above, no living types.
rg "^dated_types: \[" manifest.yaml
# Expected: 1 match — visually confirm the list matches the snapshot-style column (✓ rows)
# in the dated type sets table.
# Living types absent (negative checks — add a line if a new living type is introduced):
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

# `all`: list contains every type registered in manifest.yaml's types: list.
# Self-check: the dated_types: item count equals the type count (template: fields are unique
# to types: entries, so they're a reliable type-count proxy — catches a missed type).
expected=$(rg -c "^\s+template: " manifest.yaml)
actual=$(rg "^dated_types:" manifest.yaml | sed 's/#.*//' | sed 's/.*\[//; s/\].*//' | tr ',' '\n' | grep -c '[a-z]')
[ "$expected" = "$actual" ] && echo "OK: $actual dated types match $expected registered types" \
  || echo "MISMATCH: $actual dated types vs $expected registered types — a type is missing from dated_types:"
# Also visually confirm the list matches manifest.yaml's types: names.
rg "^dated_types:" manifest.yaml
```

---

## Notes

- **Orthogonality with `requirements-root.md`:** This customization is orthogonal to the
  requirements-root customization. Both are manifest-driven — the two touch disjoint
  manifest fields (`dated_types:` list vs. `requirements_root:` field) and disjoint aspects of
  the ID (date prefix vs. type prefix). Apply in any order.

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
