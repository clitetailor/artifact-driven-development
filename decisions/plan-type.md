# Decision: plan type

> Switches the default plan type in `manifest.yaml` and reference docs.
> Pick one alternative below; the agent applies that alternative's section.
> Switching to a different alternative later = apply a different alternative's section.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

The plan artifact type is re-defaulted. Reference docs relabel which type is "the
default" vs. "an alternative." `manifest.yaml`'s `plan_type:` field is updated.

This is a **re-default**, not a structural change — the dependency graph, agent
ownership, and lifecycle are unchanged. Only labels and which type is called "the
default" move. No templates are touched (plan templates are self-contained; they don't
carry a `plan_type:` field pointing at themselves, and downstream templates don't
reference the plan type).

---

## Alternatives

| Alternative | Prefix | Folder | Display name | Status |
|---|---|---|---|---|
| `plan` | `plan-` | `plans/` | Plan | ✅ Implemented (default) |
| `work-breakdown-structure` | `wbs-` | `work-breakdown-structures/` | Work Breakdown Structure | ✅ Implemented |
| `implementation-plan` | `ip-` | `implementation-plans/` | Implementation Plan | ✅ Implemented |

All three alternatives have full edit instructions below.

---

## L2 — Reference docs & README (6 files)

This layer re-labels which plan type is "the default" vs. "an alternative." The pattern
is uniform: wherever the current default is presented as the default and the chosen
alternative is presented as an alternative, swap those two roles. Other alternatives keep
their "alternative" framing unchanged.

**Does not change:**
- Other plan alternatives not being switched to keep their "alternative" framing.
- Agent ownership and lifecycle are unchanged.
- Templates — plan templates are self-contained and don't reference the plan type.
- `reference/artifact-frontmatter.md` mentions "plan" generically as a downstream
  artifact type — this is not changed (it doesn't specify which plan type is the default).
- `reference/coordination-decision-tree.md` does not mention plan types — not changed.

Six files are touched:
- **`manifest.yaml`** — `plan_type:` field
- **`reference/artifact-dep-graph.md`** — phase row, mermaid node, dependency table (3 spots)
- **`reference/artifact-vocabulary.md`** — plan + chosen alternative rows (roles swapped)
- **`reference/folder-structure.md`** — 2 inline comments
- **`reference/vault-queries.md`** — 1 scan query
- **`README.md`** — 1 line in the Planning section

### Per-alternative full final state

Each section below shows the full final state of the changed lines for that alternative.
The current state is determined by `manifest.yaml`'s `plan_type:` field — read it before
applying to identify which alternative is currently active. If the chosen alternative is
already the current state, skip to Verify.

---

### `plan` (default)

If `manifest.yaml` already says `plan_type: plan`, the vault is already in this state —
skip to Verify. Otherwise, apply the changes below to switch from the current default
to `plan`.

#### `manifest.yaml`

```
plan_type: plan                     # default plan type
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 4 — Development | How is it built? | backend-engineer, frontend-engineer, project-manager | tech-design, task, plan |
```

Mermaid node:
```
        TD --> PLAN["plan"]
```

Dependency table:
```
| plan | tech-design, user-story |
```

#### `reference/artifact-vocabulary.md` (plan + alternatives rows: roles restored)

```
| **plan** | The default planning artifact — a flat ordered list sequencing stories/tasks with estimates. Alternatives: `work-breakdown-structure` (deliverable hierarchy + effort rollup), `implementation-plan` (story queue + task lanes). Owned by project-manager. |
| **work-breakdown-structure** | Plan alternative — deliverable hierarchy with effort rollup. Owned by project-manager. |
| **implementation-plan** | Plan alternative — story queue with task lanes. Owned by project-manager. |
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── plans/                  # Plans (plan-) — default plan type
├── work-breakdown-structures/ # Work Breakdown Structures (wbs-) — plan alternative
├── implementation-plans/   # Implementation Plans (ip-) — plan alternative
```

#### `reference/vault-queries.md` (1 scan query)

```
# All plan artifacts (default plan type)
rg -l --glob '!.*' "type: plan" {vault-root}/
```

#### `README.md` (1 line in Planning section)

```
- `plan-` — flat ordered list sequencing stories/tasks (default plan type)
- `wbs-` — work breakdown structure (deliverable hierarchy + effort rollup)
- `ip-` — implementation plan (story queue + task lanes)
```

---

### `work-breakdown-structure`

#### `manifest.yaml`

```
plan_type: work-breakdown-structure      # default plan type
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 4 — Development | How is it built? | backend-engineer, frontend-engineer, project-manager | tech-design, task, work-breakdown-structure |
```

Mermaid node:
```
        TD --> PLAN["work-breakdown-structure"]
```

Dependency table:
```
| work-breakdown-structure | tech-design, user-story |
```

#### `reference/artifact-vocabulary.md` (plan + work-breakdown-structure rows: roles swapped)

```
| **plan** | A planning alternative — a flat ordered list sequencing stories/tasks with estimates. Owned by project-manager. |
| **work-breakdown-structure** | The default planning artifact — deliverable hierarchy with effort rollup. Tree of stories to tasks with rolled-up effort sums. Owned by project-manager. |
| **implementation-plan** | Plan alternative — story queue with task lanes. Owned by project-manager. |
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── plans/                  # Plans (plan-) — plan alternative
├── work-breakdown-structures/ # Work Breakdown Structures (wbs-) — default plan type
├── implementation-plans/   # Implementation Plans (ip-) — plan alternative
```

#### `reference/vault-queries.md` (1 scan query)

```
# All work-breakdown-structure artifacts (default plan type)
rg -l --glob '!.*' "type: work-breakdown-structure" {vault-root}/
```

#### `README.md` (1 line in Planning section)

```
- `plan-` — flat ordered list sequencing stories/tasks
- `wbs-` — work breakdown structure (deliverable hierarchy + effort rollup) (default plan type)
- `ip-` — implementation plan (story queue + task lanes)
```

---

### `implementation-plan`

#### `manifest.yaml`

```
plan_type: implementation-plan      # default plan type
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 4 — Development | How is it built? | backend-engineer, frontend-engineer, project-manager | tech-design, task, implementation-plan |
```

Mermaid node:
```
        TD --> PLAN["implementation-plan"]
```

Dependency table:
```
| implementation-plan | tech-design, user-story |
```

#### `reference/artifact-vocabulary.md` (plan + implementation-plan rows: roles swapped)

```
| **plan** | A planning alternative — a flat ordered list sequencing stories/tasks with estimates. Owned by project-manager. |
| **work-breakdown-structure** | Plan alternative — deliverable hierarchy with effort rollup. Owned by project-manager. |
| **implementation-plan** | The default planning artifact — story queue + task lanes. Sequences stories by priority/depends-on and lays out backend/frontend parallelism per story. Owned by project-manager. |
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── plans/                  # Plans (plan-) — plan alternative
├── work-breakdown-structures/ # Work Breakdown Structures (wbs-) — plan alternative
├── implementation-plans/   # Implementation Plans (ip-) — default plan type
```

#### `reference/vault-queries.md` (1 scan query)

```
# All implementation-plan artifacts (default plan type)
rg -l --glob '!.*' "type: implementation-plan" {vault-root}/
```

#### `README.md` (1 line in Planning section)

```
- `plan-` — flat ordered list sequencing stories/tasks
- `wbs-` — work breakdown structure (deliverable hierarchy + effort rollup)
- `ip-` — implementation plan (story queue + task lanes) (default plan type)
```

---

## Apply

1. **Read `manifest.yaml`** to find the current `plan_type:` value. This identifies the
   current default.
2. If the chosen alternative is already the current state, skip to Verify.
3. Apply the chosen alternative's section above to each of the 6 files. Match by prose
   meaning ("the line that calls X the default plan type"), not by exact line numbers —
   the surrounding text may have drifted upstream.
4. **`manifest.yaml`:** Edit the `plan_type:` line directly.

Work file-by-file. Read a file, apply all its edits in one pass, move to the next.

---

## Verify

After applying, run these assertions. All must pass.

```bash
# Should be gone — no reference doc still calls the old type the default
rg -n "default plan type" reference/ README.md manifest.yaml  # expect: only the chosen alternative's mentions

# Should be present — the chosen alternative is now the default
rg -n "plan_type: {new_type}" manifest.yaml                   # expect: 1
rg -n "type: {new_type}" reference/vault-queries.md           # expect: 1
rg -n '"{new_type}"' reference/artifact-dep-graph.md          # expect: 1 (mermaid node)

# Sanity — other alternatives untouched
rg -n "plan alternative" reference/artifact-vocabulary.md     # expect: 2 (the two non-chosen alternatives)
```

If any "should be gone" check returns hits for the old type, re-apply the missed edit to
that file.
If any "should be present" check returns nothing, the apply was incomplete — re-read the
target file and apply the missing edit.

---

## Notes

- This decision is **orthogonal** to the requirements-root decision (`prd` vs
  `feature-brief` vs `press-release`) and the ask-threshold decision. They touch disjoint
  files; apply in any order.
- No templates are touched — plan templates are self-contained and don't reference the
  plan type. Only reference docs, `manifest.yaml`, and `README.md` change.
- Already-created artifacts (in `plans/`, `work-breakdown-structures/`,
  `implementation-plans/`) are **not touched** — only reference docs change. Migrate
  existing artifacts on demand by renaming files and updating their `id:`/`type:` fields.
- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different alternative's section" — there is no "revert" operation.
