# Decision: feature-brief as requirements-root

> Switches the default requirements-root type from `prd` to `feature-brief`.
> Apply this file when the user picks `feature-brief` in the customize-artifacts flow.
> Revert by applying `decisions/prd.md` (the symmetric default file).

---

## What changes

The requirements-root artifact becomes **Feature Brief** (`fb-` prefix, `feature-briefs/` folder).
`prd` is demoted from "default" to "alternative." Every downstream artifact that links to the
requirements root now links to a Feature Brief instead of a PRD.

This is a **rename + re-default**, not a structural change — the dependency graph, agent
ownership, and lifecycle are unchanged. Only labels, prefixes, and which type is called
"the default" move.

---

## Token map

These are systematic find-and-replace tokens. Apply them across the target files listed in
each layer below. `{slug}` is a literal placeholder in templates; in reference docs it may
appear as a concrete example slug (e.g. `user-auth`) — replace the example slug too.

| Find | Replace | Where |
|---|---|---|
| `feature: prd-{slug}` | `feature: fb-{slug}` | All 12 downstream templates (frontmatter) |
| `  - prd-{slug}` (inside `refs:` block) | `  - fb-{slug}` | Templates that list the root in `refs:` |
| `[prd-{slug}](../prds/prd-{slug}.md)` | `[fb-{slug}](../feature-briefs/fb-{slug}.md)` | Templates' `## References` section |
| `prd-{slug}` (in prose comments) | `fb-{slug}` | Templates' body comments mentioning the root |

> The `{slug}` vs concrete-slug distinction matters: in templates the literal string is
> `prd-{slug}`; in reference docs the example is e.g. `prd-user-auth`. Match by the `prd-`
> prefix and the surrounding context, not by exact `{slug}`.

---

## Layer 1 — Templates (12 files)

**Targets:** `templates/api-spec.md`, `templates/data-design.md`, `templates/design-spec.md`,
`templates/implementation-plan.md`, `templates/plan.md`, `templates/system-architecture.md`,
`templates/task.md`, `templates/tech-design.md`, `templates/test-spec.md`,
`templates/user-flow.md`, `templates/user-story.md`, `templates/work-breakdown-structure.md`

**Action:** Apply every applicable row from the Token map to each file. Most files take only
the frontmatter `feature:` swap; files that list the root in `refs:` or in `## References`
take those rows too.

### Example — `templates/plan.md`

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

> The example above is **illustrative** — it shows the shape of the change for one file.
> Apply the same shape to every file in the target list. Do not hunt for the exact lines
> shown; match by the `prd-` prefix and `../prds/` path patterns from the Token map.

---

## Layer 2 — Reference docs & handbook (8 files)

These are semantic prose edits, not pure token swaps. The pattern is: wherever `prd` is
presented as **the default** requirements-root and `feature-brief` as **an alternative**,
swap those two roles. Other alternatives (pitch, one-pager, press-release) keep their
"alternative" framing unchanged.

### `PROJECT.md`

The `## PRDs` section becomes `## Feature Briefs`. The HTML comment and table header
swap which type is default. The row template's `prd-{slug}` becomes `fb-{slug}`.

```diff
-## PRDs
+## Feature Briefs

-<!-- One row per feature's PRD. The default requirements-root type is prd;
-     alternatives (feature-brief, pitch, one-pager, press-release) can be
+<!-- One row per feature's Feature Brief. The default requirements-root type is feature-brief;
+     alternatives (prd, pitch, one-pager, press-release) can be
      selected via switch-patches — see handbook/customization.md. -->

-| PRD | Status | Summary |
+| Feature Brief | Status | Summary |
 |-----|--------|---------|
-| <!-- prd-{slug} --> | <!-- draft/ready-for-review/accepted --> | <!-- brief summary --> |
+| <!-- fb-{slug} --> | <!-- draft/ready-for-review/accepted --> | <!-- brief summary --> |
```

### `manifest.yaml`

One line — the `feature_type` default. Edit directly (no `yq` needed).

```diff
-feature_type: prd                   # default requirements-root type
+feature_type: feature-brief         # default requirements-root type
```

### `reference/artifact-vocabulary.md`

Swap the `prd` and `feature-brief` row definitions so `feature-brief` reads as the default
and `prd` reads as the alternative. Keep `pitch`, `one-pager`, `press-release` rows as-is.

```diff
-| **prd** | Product Requirements Document — the default requirements-root artifact. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
-| **feature-brief** | Feature Brief — a lighter requirements-root alternative to prd. Captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst. |
+| **prd** | Product Requirements Document — a requirements-root alternative to feature-brief. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
+| **feature-brief** | Feature Brief — the default requirements-root artifact. Captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst. |
```

### `reference/artifact-dep-graph.md`

Three spots: the Phase 1 row artifact list, the mermaid `ROOT` node label, and the
"First create…" dependency table. Replace `prd` → `feature-brief` in all three.

```diff
-| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | prd, user-story |
+| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | feature-brief, user-story |
```

```diff
         subgraph REQ[Requirements]
-        ROOT["prd"] --> STORY[user-story]
+        ROOT["feature-brief"] --> STORY[user-story]
         end
```

```diff
-| prd | — |
-| user-story | prd |
-| user-flow | prd |
+| feature-brief | — |
+| user-story | feature-brief |
+| user-flow | feature-brief |
 | design-spec | user-flow |
-| system-architecture | prd |
+| system-architecture | feature-brief |
 | adr | system-architecture |
 | api-spec | system-architecture |
 | data-design | system-architecture |
-| tech-design | system-architecture, prd |
+| tech-design | system-architecture, feature-brief |
```

### `reference/artifact-frontmatter.md`

One sentence: the `feature:` field description. `PRD (prd- prefixed)` → `Feature Brief (fb- prefixed)`.

```diff
-Downstream artifacts (...) carry: `feature` — the ID of the feature's PRD (`prd-` prefixed).
+Downstream artifacts (...) carry: `feature` — the ID of the feature's Feature Brief (`fb-` prefixed).
```

### `reference/coordination-decision-tree.md`

Replace `prd` → `feature-brief` in: the "Research before committing" row, the `user-story`
work-type description ("Derived from PRD" → "Derived from Feature Brief"), the "Epic-level
grouping" bullet, the example frontmatter `feature:` line, and the mermaid `PRD` node label
→ `FB`.

```diff
-| Research before committing to changes | Add investigation notes to `prd` | — |
+| Research before committing to changes | Add investigation notes to `feature-brief` | — |
```

```diff
-New user-facing capability. Derived from PRD. Format: ...
+New user-facing capability. Derived from Feature Brief. Format: ...
```

```diff
-- Both link to `prd` as the Epic-level grouping
+- Both link to `feature-brief` as the Epic-level grouping
```

```diff
-feature: prd-{slug}
+feature: fb-{slug}
```

```diff
-  PRD["PRD (Epic level — what and why)"]
+  FB["Feature Brief (Epic level — what and why)"]
```

```diff
-  PRD --> Tech
+  FB --> Tech
```

### `reference/folder-structure.md`

Swap the inline comments on the `feature-briefs/` and `prds/` lines so `feature-briefs/`
is labeled "default requirements-root" and `prds/` is labeled "alternative".

```diff
-├── feature-briefs/         # Feature Briefs (fb-) — requirements-root alternative
-├── prds/                   # Product Requirements Documents (prd-) — default requirements-root
+├── feature-briefs/         # Feature Briefs (fb-) — default requirements-root
+├── prds/                   # Product Requirements Documents (prd-) — requirements-root alternative
```

### `reference/vault-queries.md`

Replace `prd` → `feature-brief` in: the opening paragraph (discovery instructions), the
"type: prd" scan query, and all example ids `prd-user-auth*` → `fb-user-auth*`.

```diff
-PRD artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'prd'` ...
+Feature Brief artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'feature-brief'` ...
```

```diff
-# All PRD artifacts (default requirements-root type)
-rg -l --glob '!.*' "type: prd" {vault-root}/
+# All Feature Brief artifacts (default requirements-root type)
+rg -l --glob '!.*' "type: feature-brief" {vault-root}/
```

```diff
-rg -l --glob '!.*' "^id: prd-user-auth" {vault-root}/
+rg -l --glob '!.*' "^id: fb-user-auth" {vault-root}/
```

### `handbook/playbooks/setup.md`

One line: the feature-type-pattern question's stated default.

```diff
-Agent: Which pattern should identify a feature? (Default is `prd` — ...)
+Agent: Which pattern should identify a feature? (Default is `feature-brief` — ...)
```

---

## Apply

Use your native file-edit tools (Edit/Read) — do **not** run `patch`. For each layer:

1. **Layer 1 (templates):** For each of the 12 target files, apply every Token-map row that
   matches. Most files need only the frontmatter `feature:` line; files with a `refs:` entry
   for the root and a `## References` link also take those rows.
2. **Layer 2 (reference docs & handbook):** Apply the per-file edits above. Match by the
   prose meaning ("the default requirements-root is X"), not by exact line numbers — the
   surrounding text may have drifted upstream.
3. **manifest.yaml:** Edit the one `feature_type:` line directly.

Work file-by-file. Read a file, apply all its edits in one pass, move to the next.

---

## Verify

After applying, run these assertions. All must pass (0 hits for the "should be gone"
checks; ≥1 hit for the "should be present" checks).

```bash
# Should be gone — no template still references the prd root
rg -l "feature: prd-\{slug\}" templates/            # expect: 0 files
rg -l "\.\./prds/prd-\{slug\}\.md" templates/       # expect: 0 files

# Should be gone — no reference doc still calls prd the default
rg -n "default requirements-root type is prd" reference/ PROJECT.md manifest.yaml  # expect: 0

# Should be present — feature-brief is now the default
rg -n "feature_type: feature-brief" manifest.yaml   # expect: 1
rg -n "type: feature-brief" reference/vault-queries.md  # expect: ≥1
rg -l "feature: fb-\{slug\}" templates/             # expect: 12 files

# Sanity — other alternatives untouched
rg -n "pitch|one-pager|press-release" reference/artifact-vocabulary.md  # expect: 3 rows still present
```

If any "should be gone" check returns hits, re-apply the missed edit to that file.
If any "should be present" check returns nothing, the apply was incomplete — re-read the
target file and apply the missing edit.

---

## Notes

- This decision is **orthogonal** to the plan-type decision (`plan` vs `work-breakdown-structure`
  vs `implementation-plan`). They touch disjoint lines; apply in any order.
- Already-created artifacts (in `prds/`, `user-stories/`, etc.) are **not touched** — only
  templates and reference docs change. Migrate existing artifacts on demand by renaming
  files and updating their `id:`/`type:`/`feature:` fields.
- The example diffs in each section are **illustrative** — they show the shape of one edit,
  not the only lines to change. The Token map and per-file prose instructions are the source
  of truth.
