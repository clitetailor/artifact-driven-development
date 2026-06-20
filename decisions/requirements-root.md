# Decision: requirements-root type

> Switches the default requirements-root type in `manifest.yaml`, templates, and reference
> docs. Pick one alternative below; the agent applies that column.
> Switching to a different alternative later = apply a different column in this file.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

The requirements-root artifact type is renamed and re-defaulted. Every downstream
artifact that links to the requirements root gets its prefix, folder path, and type name
swapped. Reference docs relabel which type is "the default" vs. "an alternative."

This is a **rename + re-default**, not a structural change — the dependency graph, agent
ownership, and lifecycle are unchanged. Only labels, prefixes, and which type is called
"the default" move.

---

## Alternatives

| Alternative | Prefix | Folder | Display name | Status |
|---|---|---|---|---|
| `prd` | `prd-` | `prds/` | PRD | ✅ Implemented (default) |
| `feature-brief` | `fb-` | `feature-briefs/` | Feature Brief | ✅ Implemented |
| `press-release` | `pr-` | `press-releases/` | Press Release | ✅ Implemented |

All three alternatives have full edit instructions below.

---

## L1 — Templates (12 downstream files)

Every downstream template carries a `feature:` frontmatter field pointing at the
requirements root. Swap the current default's prefix and folder path with the chosen
alternative's.

### Token map

Read `manifest.yaml`'s `feature_type:` field to identify the **current** default. Use that
alternative's prefix/folder as the "find" tokens and the chosen alternative's
prefix/folder as the "replace" tokens.

| Find (current default) | Replace (chosen alternative) |
|---|---|
| `feature: {cur_prefix}-{slug}` | `feature: {new_prefix}-{slug}` |
| `  - {cur_prefix}-{slug}` (inside `refs:` block) | `  - {new_prefix}-{slug}` |
| `[{cur_prefix}-{slug}](../{cur_folder}/{cur_prefix}-{slug}.md)` | `[{new_prefix}-{slug}](../{new_folder}/{new_prefix}-{slug}.md)` |
| `{cur_prefix}-{slug}` (in prose comments) | `{new_prefix}-{slug}` |
| `scenario: {cur_prefix}-{slug}#scenario-{N}` | `scenario: {new_prefix}-{slug}#scenario-{N}` |

Where `{cur_prefix}` / `{cur_folder}` come from the current default's row in the
alternatives table, and `{new_prefix}` / `{new_folder}` come from the chosen alternative's
row.

### Find commands

```bash
# Find every template that has a feature: field (all 12 downstream templates)
# Use the current default's prefix to search
rg -l "feature: {cur_prefix}-\{slug\}" templates/
# (fallback: grep -rl "feature: {cur_prefix}-{slug}" templates/)

# Find every template with a link path to the current default's folder
rg -l "\.\./{cur_folder}/" templates/
# (fallback: grep -rl "../{cur_folder}/" templates/)
```

The first command returns exactly the 12 downstream templates and **excludes the root
template itself** (e.g. `templates/prd.md` has `id: prd-{slug}`, not `feature: prd-{slug}`)
— this is the safety gate that prevents over-editing the root template.

### Illustrative example

> **Warning:** this diff is illustrative — it shows the shape of the change for one file.
> Do not hunt for these exact lines. Match by the token map patterns above. The find
> commands and token map are the source of truth.

Example: switching from `prd` to `feature-brief`, in `templates/plan.md`:

```diff
 ---
 id: plan-{slug}
 type: plan
 owner: project-manager
 status: draft
 version: 1.0
-feature: prd-{slug}
+feature: fb-{slug}
 refs:
-  - prd-{slug}
+  - fb-{slug}
   - story-{slug}
   - td-{slug}
 ---

 # Plan: {title}

 ## Goal
-<!-- One paragraph: what "done" looks like for this plan. Ties back to prd-{slug} Success Metrics. -->
+<!-- One paragraph: what "done" looks like for this plan. Ties back to fb-{slug} Success Metrics. -->
```

```diff
 ## References
-- [prd-{slug}](../prds/prd-{slug}.md)
+- [fb-{slug}](../feature-briefs/fb-{slug}.md)
 - [story-{slug}](../user-stories/story-{slug}.md)
 - [td-{slug}](../tech-designs/td-{slug}.md)
```

Apply the same shape to every file returned by the find commands. Use whatever tool you
choose (sed, Edit, or a mix). The `refs:` block entry and prose comments are covered by
the same prefix swap — no special handling needed.

---

## L2 — Reference docs & handbook (9 files)

This layer re-labels which requirements-root type is "the default" vs. "an alternative."
The pattern is uniform: wherever the current default is presented as the default and the
chosen alternative is presented as an alternative, swap those two roles. Other
alternatives keep their "alternative" framing unchanged.

**Does not change:**
- Other requirements-root alternatives not being switched to keep their "alternative"
  framing.
- Agent ownership and lifecycle are unchanged.
- Generic mentions of "PRD" in other artifact definitions (e.g. "extracted from a PRD" in
  the `user-story` row, "the feature's PRD" in the `task` row of `artifact-vocabulary.md`;
  "active tasks, PRDs, status" in `folder-structure.md`) are NOT changed — only the
  rows/entries that present a type as the default are swapped.

Nine files are touched, in three flavors:
- **Default-swap prose** (`artifact-vocabulary.md`, `PROJECT.md`, `folder-structure.md`,
  `handbook/playbooks/setup.md`) — reword which type is called "default."
- **Graph/table relabeling** (`artifact-dep-graph.md`, `coordination-decision-tree.md`) —
  replace the type name in dependency tables and mermaid nodes.
- **Query/example updates** (`vault-queries.md`, `artifact-frontmatter.md`,
  `manifest.yaml`) — replace the type name, example ids, and scan queries.

### Per-alternative full final state

Each section below shows the full final state of the changed lines for that alternative.
The current state is determined by `manifest.yaml`'s `feature_type:` field — read it
before applying to identify which alternative is currently active. If the chosen
alternative is already the current state, skip to Verify.

---

### `prd` (default)

If `manifest.yaml` already says `feature_type: prd`, the vault is already in this state —
skip to Verify. Otherwise, apply the L2 changes below to switch from the current default
to `prd`.

#### `manifest.yaml`

```
feature_type: prd                   # default requirements-root type
```

#### `reference/artifact-vocabulary.md` (prd + feature-brief rows: roles swapped)

```
| **prd** | Product Requirements Document — the default requirements-root artifact. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
| **feature-brief** | Feature Brief — a lighter requirements-root alternative to prd. Captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst. |
```

#### `PROJECT.md` (heading + comment + table)

```
## PRDs

<!-- One row per feature's PRD. The default requirements-root type is prd;
     alternatives (feature-brief, press-release) can be
     selected via decisions — see handbook/customization.md. -->

| PRD | Status | Summary |
|-----|--------|---------|
| <!-- prd-{slug} --> | <!-- draft/ready-for-review/accepted --> | <!-- brief summary --> |
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | prd, user-story |
```

Mermaid node:
```
        ROOT["prd"] --> STORY[user-story]
```

Dependency table:
```
| prd | — |
| user-story | prd |
| user-flow | prd |
| design-spec | user-flow |
| system-architecture | prd |
| adr | system-architecture |
| api-spec | system-architecture |
| data-design | system-architecture |
| tech-design | system-architecture, prd |
```

#### `reference/artifact-frontmatter.md` (1 sentence)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD (`prd-` prefixed). This links the artifact to its requirements root; see `artifact-dep-graph.md`.
```

#### `reference/coordination-decision-tree.md` (5 spots)

Research row:
```
| Research before committing to changes | Add investigation notes to `prd` | — |
```

User-story work type:
```
New user-facing capability. Derived from PRD. Format: "As a [role], I want [goal], so that [benefit]". Includes Given/When/Then acceptance criteria and an execution checklist for sub-tasks.
```

Epic-level grouping bullet:
```
- Both link to `prd` as the Epic-level grouping
```

Example frontmatter:
```
feature: prd-{slug}
```

Mermaid nodes:
```
  PRD["PRD (Epic level — what and why)"]
```
```
  PRD --> Tech
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── feature-briefs/         # Feature Briefs (fb-) — requirements-root alternative
├── prds/                   # Product Requirements Documents (prd-) — default requirements-root
```

#### `reference/vault-queries.md` (opening paragraph + scan queries + example ids)

```
PRD artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'prd'` once the CLI is available. Downstream artifacts link to the feature's PRD via the `feature:` frontmatter field.
```

```
# All PRD artifacts (default requirements-root type)
rg -l --glob '!.*' "type: prd" {vault-root}/
```

```
# Find the PRD for a feature (by its root id, e.g. prd-user-auth)
rg -l --glob '!.*' "^id: prd-user-auth" {vault-root}/
```

```
# All downstream artifacts tied to a feature (via the `feature:` field)
rg -l --glob '!.*' "feature: prd-user-auth" {vault-root}/
```

```
# Find a specific artifact by id
rg -l --glob '!.*' "^id: prd-user-authentication-login" {vault-root}/
```

#### `handbook/playbooks/setup.md` (1 line)

```
Agent: Which pattern should identify a feature? (Default is `prd` — a feature is anything matching that pattern. Optional — leave blank to keep the default.)
```

---

### `feature-brief`

#### `manifest.yaml`

```
feature_type: feature-brief         # default requirements-root type
```

#### `reference/artifact-vocabulary.md` (prd + feature-brief rows: roles swapped)

```
| **prd** | Product Requirements Document — a requirements-root alternative to feature-brief. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
| **feature-brief** | Feature Brief — the default requirements-root artifact. Captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst. |
```

#### `PROJECT.md` (heading + comment + table)

```
## Feature Briefs

<!-- One row per feature's Feature Brief. The default requirements-root type is feature-brief;
     alternatives (prd, press-release) can be
     selected via decisions — see handbook/customization.md. -->

| Feature Brief | Status | Summary |
|-----|--------|---------|
| <!-- fb-{slug} --> | <!-- draft/ready-for-review/accepted --> | <!-- brief summary --> |
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | feature-brief, user-story |
```

Mermaid node:
```
        ROOT["feature-brief"] --> STORY[user-story]
```

Dependency table:
```
| feature-brief | — |
| user-story | feature-brief |
| user-flow | feature-brief |
| design-spec | user-flow |
| system-architecture | feature-brief |
| adr | system-architecture |
| api-spec | system-architecture |
| data-design | system-architecture |
| tech-design | system-architecture, feature-brief |
```

#### `reference/artifact-frontmatter.md` (1 sentence)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's Feature Brief (`fb-` prefixed). This links the artifact to its requirements root; see `artifact-dep-graph.md`.
```

#### `reference/coordination-decision-tree.md` (5 spots)

Research row:
```
| Research before committing to changes | Add investigation notes to `feature-brief` | — |
```

User-story work type:
```
New user-facing capability. Derived from Feature Brief. Format: "As a [role], I want [goal], so that [benefit]". Includes Given/When/Then acceptance criteria and an execution checklist for sub-tasks.
```

Epic-level grouping bullet:
```
- Both link to `feature-brief` as the Epic-level grouping
```

Example frontmatter:
```
feature: fb-{slug}
```

Mermaid nodes:
```
  FB["Feature Brief (Epic level — what and why)"]
```
```
  FB --> Tech
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── feature-briefs/         # Feature Briefs (fb-) — default requirements-root
├── prds/                   # Product Requirements Documents (prd-) — requirements-root alternative
```

#### `reference/vault-queries.md` (opening paragraph + scan queries + example ids)

```
Feature Brief artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'feature-brief'` once the CLI is available. Downstream artifacts link to the feature's Feature Brief via the `feature:` frontmatter field.
```

```
# All Feature Brief artifacts (default requirements-root type)
rg -l --glob '!.*' "type: feature-brief" {vault-root}/
```

```
# Find the Feature Brief for a feature (by its root id, e.g. fb-user-auth)
rg -l --glob '!.*' "^id: fb-user-auth" {vault-root}/
```

```
# All downstream artifacts tied to a feature (via the `feature:` field)
rg -l --glob '!.*' "feature: fb-user-auth" {vault-root}/
```

```
# Find a specific artifact by id
rg -l --glob '!.*' "^id: fb-user-authentication-login" {vault-root}/
```

#### `handbook/playbooks/setup.md` (1 line)

```
Agent: Which pattern should identify a feature? (Default is `feature-brief` — a feature is anything matching that pattern. Optional — leave blank to keep the default.)
```

---

### `press-release`

#### `manifest.yaml`

```
feature_type: press-release         # default requirements-root type
```

#### `reference/artifact-vocabulary.md` (prd + press-release rows: roles swapped)

```
| **prd** | Product Requirements Document — a requirements-root alternative to press-release. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
| **press-release** | Press Release — the default requirements-root artifact. Uses "working backwards" framing written as if the product has launched; surfaces customer-outcome gaps before implementation. Owned by business-analyst. |
```

#### `PROJECT.md` (heading + comment + table)

```
## Press Releases

<!-- One row per feature's Press Release. The default requirements-root type is press-release;
     alternatives (prd, feature-brief) can be
     selected via decisions — see handbook/customization.md. -->

| Press Release | Status | Summary |
|-----|--------|---------|
| <!-- pr-{slug} --> | <!-- draft/ready-for-review/accepted --> | <!-- brief summary --> |
```

#### `reference/artifact-dep-graph.md` (3 spots)

Phase row:
```
| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | press-release, user-story |
```

Mermaid node:
```
        ROOT["press-release"] --> STORY[user-story]
```

Dependency table:
```
| press-release | — |
| user-story | press-release |
| user-flow | press-release |
| design-spec | user-flow |
| system-architecture | press-release |
| adr | system-architecture |
| api-spec | system-architecture |
| data-design | system-architecture |
| tech-design | system-architecture, press-release |
```

#### `reference/artifact-frontmatter.md` (1 sentence)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's Press Release (`pr-` prefixed). This links the artifact to its requirements root; see `artifact-dep-graph.md`.
```

#### `reference/coordination-decision-tree.md` (5 spots)

Research row:
```
| Research before committing to changes | Add investigation notes to `press-release` | — |
```

User-story work type:
```
New user-facing capability. Derived from Press Release. Format: "As a [role], I want [goal], so that [benefit]". Includes Given/When/Then acceptance criteria and an execution checklist for sub-tasks.
```

Epic-level grouping bullet:
```
- Both link to `press-release` as the Epic-level grouping
```

Example frontmatter:
```
feature: pr-{slug}
```

Mermaid nodes:
```
  PR["Press Release (Epic level — what and why)"]
```
```
  PR --> Tech
```

#### `reference/folder-structure.md` (2 inline comments)

```
├── prds/                   # Product Requirements Documents (prd-) — requirements-root alternative
├── press-releases/         # Press Releases (pr-) — default requirements-root
```

#### `reference/vault-queries.md` (opening paragraph + scan queries + example ids)

```
Press Release artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'press-release'` once the CLI is available. Downstream artifacts link to the feature's Press Release via the `feature:` frontmatter field.
```

```
# All Press Release artifacts (default requirements-root type)
rg -l --glob '!.*' "type: press-release" {vault-root}/
```

```
# Find the Press Release for a feature (by its root id, e.g. pr-user-auth)
rg -l --glob '!.*' "^id: pr-user-auth" {vault-root}/
```

```
# All downstream artifacts tied to a feature (via the `feature:` field)
rg -l --glob '!.*' "feature: pr-user-auth" {vault-root}/
```

```
# Find a specific artifact by id
rg -l --glob '!.*' "^id: pr-user-authentication-login" {vault-root}/
```

#### `handbook/playbooks/setup.md` (1 line)

```
Agent: Which pattern should identify a feature? (Default is `press-release` — a feature is anything matching that pattern. Optional — leave blank to keep the default.)
```

---

## Apply

1. **Read `manifest.yaml`** to find the current `feature_type:` value. This identifies the
   current default and its prefix/folder (from the alternatives table).
2. **L1 (templates):** Run the find commands with the current default's prefix/folder.
   Apply the token map to each file returned, replacing current default tokens with the
   chosen alternative's tokens. Use whatever tool you choose (sed, Edit, or a mix).
3. **L2 (reference docs & handbook):** Apply the per-alternative full final state blocks
   above. Match by the prose meaning ("the line that calls X the default requirements-root
   type"), not by exact line numbers — the surrounding text may have drifted upstream.
4. **`manifest.yaml`:** Edit the `feature_type:` line directly.

Work file-by-file. Read a file, apply all its edits in one pass, move to the next.

---

## Verify

After applying, run these assertions. All must pass.

```bash
# Should be gone — no template still references the old default's prefix
rg -l "feature: {cur_prefix}-\{slug\}" templates/            # expect: 0 files
rg -l "\.\./{cur_folder}/{cur_prefix}-\{slug\}\.md" templates/  # expect: 0 files

# Should be gone — no reference doc still calls the old type the default
rg -n "default requirements-root type is {cur_type}" reference/ PROJECT.md manifest.yaml  # expect: 0

# Should be present — the chosen alternative is now the default
rg -n "feature_type: {new_type}" manifest.yaml               # expect: 1
rg -n "type: {new_type}" reference/vault-queries.md          # expect: ≥1
rg -l "feature: {new_prefix}-\{slug\}" templates/            # expect: 12 files

# Sanity — other alternatives untouched
rg -n "feature-brief|press-release" reference/artifact-vocabulary.md  # expect: rows still present

# Edge cases — these should NOT have been changed
rg -n "extracted from a PRD" reference/artifact-vocabulary.md    # expect: 1 (unchanged)
rg -n "the feature's PRD" reference/artifact-vocabulary.md       # expect: 1 (unchanged)
rg -n "active tasks, PRDs, status" reference/folder-structure.md # expect: 1 (unchanged)
```

If any "should be gone" check returns hits, re-apply the missed edit to that file.
If any "should be present" check returns nothing, the apply was incomplete — re-read the
target file and apply the missing edit.
If any edge-case check returns 0, the agent over-edited a generic "PRD" mention — restore
it.

---

## Notes

- This decision is **orthogonal** to the plan-type decision (`plan` vs
  `work-breakdown-structure` vs `implementation-plan`). They touch disjoint lines; apply
  in any order.
- Already-created artifacts (in `prds/`, `feature-briefs/`, etc.) are **not touched** —
  only templates and reference docs change. Migrate existing artifacts on demand by
  renaming files and updating their `id:`/`type:`/`feature:` fields.
- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different column" — there is no "revert" operation.
