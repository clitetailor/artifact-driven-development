# Decision: artifact-id-dating

> Switches whether artifact IDs carry a creation-date prefix, and which types are dated.
> Pick one alternative below; the agent applies that column.
> Switching to a different alternative later = apply a different column in this file.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

Artifact IDs gain an optional `{YYYY-MM-DD}-` creation-date prefix before the type
prefix. The set of types that carry the date prefix depends on the chosen alternative.
Templates, `manifest.yaml`, and `reference/artifact-frontmatter.md` are updated to
reflect the new ID pattern. `reference/vault-queries.md` is updated so `^id:`-anchored
queries for dated types use a wildcard that matches the date prefix.

This is a **naming convention change**, not a structural change — the dependency graph,
agent ownership, lifecycle, folder structure, and frontmatter fields are unchanged. Only
the ID format and the queries that anchor on IDs move.

**Date semantics:** the date prefix is the **creation date**, set once when the artifact
is first created and never updated — even if the artifact is revised via `needs-review`
or re-accepted. This keeps IDs stable so `refs`/`feature`/`story` links don't break.

---

## Alternatives

| Alternative | Dated types | Undated types | Status |
|---|---|---|---|
| `none` | — | all 15 | ✅ Implemented (default) |
| `snapshot-style` | 10 snapshot types | 5 living types | ✅ Drafted |
| `all` | all 15 | — | ✅ Drafted |

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

## L1 — Templates (15 files)

Every template is affected, because every downstream template carries a `feature:`
field pointing at the requirements root (a dated type under `snapshot-style` and `all`).
The token map below covers both the template's own `id:` field (if its type is dated)
and every cross-reference to a dated type.

### Token map

For each **dated** prefix `P` in the chosen alternative's column above, apply this
find/replace across all files in `templates/`:

| Find | Replace |
|---|---|
| `P-{slug}` | `{date}-P-{slug}` |
| `P-{descriptor}` | `{date}-P-{descriptor}` |

The `{date}` placeholder is the template's stand-in for the creation date; the agent
filling the template replaces it with the actual `YYYY-MM-DD` value. The find pattern
`P-{slug}` matches every occurrence of the prefix-slug combination — in `id:` fields,
`refs:` lists, `feature:`/`story:`/`tech-design:`/`depends-on:` fields, prose comments,
markdown link text, and markdown link paths. Folder names in link paths (e.g.
`../prds/`) are unchanged — only the filename portion shifts.

**Special case — `fb-{descriptor}`:** `templates/feature-brief.md` uses `{descriptor}`
instead of `{slug}` in its own `id:` field. The `P-{descriptor}` row handles this. No
other template uses `{descriptor}` with a dated prefix.

**Special case — `task-{slug}-{be|fe}`:** `templates/task.md` uses
`task-{slug}-{be|fe}` in its `id:` and `depends-on:` fields. Replacing `task-{slug}`
with `{date}-task-{slug}` yields `{date}-task-{slug}-{be|fe}` — the `-{be|fe}` suffix
is preserved automatically.

**Special case — `scenario: prd-{slug}#scenario-{N}`:** `templates/test-spec.md` uses
this pattern. Replacing `prd-{slug}` with `{date}-prd-{slug}` yields
`scenario: {date}-prd-{slug}#scenario-{N}` — the `#scenario-{N}` anchor is preserved.

### Find commands

Run one find command per dated prefix to discover which templates contain that prefix.
The union of all results is the full set of templates to edit.

```bash
# Example: for the `snapshot-style` alternative, run these 10 commands.
# Each returns the templates that reference that dated prefix.
# (fallback: grep -rl "P-{slug}" templates/)

rg -l "prd-\{slug\}" templates/
rg -l "fb-\{slug\}" templates/
rg -l "fb-\{descriptor\}" templates/
rg -l "pr-\{slug\}" templates/
rg -l "story-\{slug\}" templates/
rg -l "uf-\{slug\}" templates/
rg -l "td-\{slug\}" templates/
rg -l "adr-\{slug\}" templates/
rg -l "task-\{slug\}" templates/
rg -l "plan-\{slug\}" templates/
rg -l "note-\{slug\}" templates/
```

For the `all` alternative, add the 5 undated prefixes:
```bash
rg -l "sa-\{slug\}" templates/
rg -l "api-\{slug\}" templates/
rg -l "dd-\{slug\}" templates/
rg -l "ds-\{slug\}" templates/
rg -l "ts-\{slug\}" templates/
# Also: ts-{feature}-{descriptor} in test-spec.md
rg -l "ts-\{feature\}" templates/
```

### Illustrative example

> **Warning:** this diff is illustrative — it shows the shape of the change for one file.
> Do not hunt for these exact lines. Match by the token map patterns above. The find
> commands and token map are the source of truth.

Example: `snapshot-style` alternative, in `templates/user-story.md`:

```diff
 ---
-id: story-{slug}
+id: {date}-story-{slug}
 type: user-story
 owner: business-analyst
 status: open | in-progress | done
 version: 1.0
-feature: prd-{slug}
+feature: {date}-prd-{slug}
 priority: {P0 | P1 | P2}
 estimated-hours: {N}  # provisional — set by BA without technical context; refined later by plan
 depends-on:
-  - story-{slug}
+  - {date}-story-{slug}
 refs:
-  - prd-{slug}
+  - {date}-prd-{slug}
 ---
```

```diff
 ## References
-- [prd-{slug}](../prds/prd-{slug}.md)
+- [{date}-prd-{slug}](../prds/{date}-prd-{slug}.md)
```

Apply the same shape to every file returned by the find commands. Use whatever tool you
choose (sed, Edit, or a mix). The `refs:` block entries, `feature:`/`story:`/`tech-design:`
fields, prose comments, and markdown links are all covered by the same prefix swap — no
special handling needed per field.

---

## L2 — Reference docs & manifest (3 files)

This layer updates the ID naming convention, the manifest's `dated` flags, and the
vault query recipes. The pattern is uniform: the ID pattern section gains a dated
variant, the manifest gains a `dated: true` flag per dated type, and `^id:`-anchored
queries for dated types switch to a wildcard that matches the date prefix.

**Does not change:**
- Folder structure (`folder-structure.md`) — folders and their prefix annotations are
  unchanged; only filenames within folders shift.
- Dependency graph (`artifact-dep-graph.md`) — dependencies are unchanged.
- Artifact vocabulary (`artifact-vocabulary.md`) — type definitions are unchanged.
- Agent ownership (`artifact-ownership.md`) — ownership is unchanged.
- Lifecycle (`artifact-lifecycle.md`) — status labels are unchanged.
- The `type:` frontmatter field and all `type:`-based grep queries — these search for
  the type name, not the ID, so the date prefix has no effect.

Three files are touched:
- **`manifest.yaml`** — add `dated: true` to each dated type under `types`.
- **`reference/artifact-frontmatter.md`** — rewrite the ID Naming Pattern section and
  the `feature` field description in Optional Fields.
- **`reference/vault-queries.md`** — update `^id:` and `feature:`/`story:` queries for
  dated types to use `id:.*` / `feature:.*` / `story:.*` wildcards.

### Per-alternative full final state

Each section below shows the full final state of the changed lines for that alternative.
The current state is determined by reading `manifest.yaml`'s `types` list for `dated:`
flags — if no type has `dated: true`, the vault is in the `none` state. If the chosen
alternative is already the current state, skip to Verify.

---

### `none` (default)

If no type in `manifest.yaml` has `dated: true`, the vault is already in this state —
skip to Verify. Otherwise, remove all `dated: true` flags from `manifest.yaml` and
revert the L2 reference docs to the state below.

#### `manifest.yaml`

No `dated:` field on any type. (Current state — no changes needed if already `none`.)

#### `reference/artifact-frontmatter.md` — ID Naming Pattern

```
## ID Naming Pattern

`{prefix}-{descriptor}` — lowercase, hyphen-separated only.

- No auto-incrementing integers
- No timestamps
- Prefix list is authoritative in `../manifest.yaml` under `types`

Examples: `fb-user-authentication-login`, `api-user-authentication`, `dd-user-authentication`, `task-token-generation-be`.
```

#### `reference/artifact-frontmatter.md` — Optional Fields (feature description)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD (`prd-` prefixed). This links the artifact to its requirements root; see `artifact-dep-graph.md`.
```

#### `reference/vault-queries.md`

No changes — `^id:` anchors work as-is when no date prefix is present.

---

### `snapshot-style`

Apply this section to switch from the current alternative to `snapshot-style`.

#### `manifest.yaml` — `types` section

Add `dated: true` to the 10 snapshot types. The 5 living types are unchanged.

```
  # Requirements
  - name: feature-brief
    prefix: fb-
    template: templates/feature-brief.md
    dated: true
  - name: prd
    prefix: prd-
    template: templates/prd.md
    dated: true
  - name: press-release
    prefix: pr-
    template: templates/press-release.md
    dated: true
  - name: user-story
    prefix: story-
    template: templates/user-story.md
    dated: true

  # Design
  - name: user-flow
    prefix: uf-
    template: templates/user-flow.md
    dated: true
  - name: design-spec
    prefix: ds-
    template: templates/design-spec.md

  # Architecture
  - name: adr
    prefix: adr-
    template: templates/adr.md
    dated: true
  - name: system-architecture
    prefix: sa-
    template: templates/system-architecture.md
  - name: api-spec
    prefix: api-
    template: templates/api-spec.md
  - name: data-design
    prefix: dd-
    template: templates/data-design.md

  # Development
  - name: tech-design
    prefix: td-
    template: templates/tech-design.md
    dated: true
  - name: task
    prefix: task-
    template: templates/task.md
    dated: true

  # Planning
  - name: plan
    prefix: plan-
    template: templates/plan.md
    dated: true

  # Verification
  - name: test-spec
    prefix: ts-
    template: templates/test-spec.md

  # General
  - name: note
    prefix: note-
    template: templates/note.md
    dated: true
```

#### `reference/artifact-frontmatter.md` — ID Naming Pattern

```
## ID Naming Pattern

Two patterns, determined by the type's `dated` flag in `../manifest.yaml`:

- **Dated types** (`dated: true`): `{YYYY-MM-DD}-{prefix}-{descriptor}` — creation date
  prefix, stable for the artifact's lifetime. Lowercase, hyphen-separated only.
- **Undated types**: `{prefix}-{descriptor}` — lowercase, hyphen-separated only.

Rules:
- No auto-incrementing integers
- Date prefix is **creation date only** — never updated on revision or re-acceptance
  (keeps IDs stable so `refs`/`feature`/`story` links don't break)
- Prefix list and `dated` flag are authoritative in `../manifest.yaml` under `types`

Examples: `2026-06-21-fb-user-authentication-login`, `api-user-authentication`, `dd-user-authentication`, `2026-06-21-task-token-generation-be`.
```

#### `reference/artifact-frontmatter.md` — Optional Fields (feature description)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD. This links the artifact to its requirements root; see `artifact-dep-graph.md`. The ID format follows the ID Naming Pattern above (dated if the requirements-root type has `dated: true`).
```

#### `reference/vault-queries.md` — queries referencing dated-type IDs

Dated-type IDs now start with `YYYY-MM-DD-`, so `^id:` line anchors no longer match.
Switch to `id:.*` wildcards for dated types. Queries using `type:`, `status:`, or
undated-type prefixes are unchanged.

Add this note at the top of the query section, after the existing intro paragraph:

```
**Dated-type IDs:** Types with `dated: true` in `manifest.yaml` carry a `YYYY-MM-DD-`
creation-date prefix. Queries that anchor on `^id:` must use `id:.*` (wildcard) instead
of `^id:` (line-start anchor) for those types. `type:` and `status:` queries are
unaffected — they search frontmatter field values, not IDs.
```

Updated queries (replace the existing lines):

```bash
# Find the PRD for a feature (by its root id, e.g. prd-user-auth)
# prd is a dated type — use id:.* wildcard
rg -l --glob '!.*' "id:.*prd-user-auth" {vault-root}/

# All downstream artifacts tied to a feature (via the `feature:` field)
# prd is a dated type — use feature:.* wildcard
rg -l --glob '!.*' "feature:.*prd-user-auth" {vault-root}/

# Find a specific artifact by id
# prd is a dated type — use id:.* wildcard
rg -l --glob '!.*' "id:.*prd-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
# story is a dated type — use story:.* wildcard
rg -l --glob '!.*' "story:.*story-user-login" {vault-root}/tasks/
```

Queries that remain unchanged (reference undated types or use `type:`/`status:`/`refs:.*`):

```bash
# All artifacts of a given type — unchanged (searches type: field, not id)
rg -l --glob '!.*' "type: api-spec" {vault-root}/
rg -l --glob '!.*' "type: data-design" {vault-root}/
rg -l --glob '!.*' "type: prd" {vault-root}/
rg -l --glob '!.*' "type: plan" {vault-root}/

# All artifacts that reference a specific artifact — unchanged (refs:.* already wildcarded)
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/
rg -l --glob '!.*' "refs:.*story-user-login" {vault-root}/test-specs/
rg -l --glob '!.*' "refs:.*ts-user-authentication" {vault-root}/tasks/

# All artifacts in needs-review state — unchanged (status: field)
rg -l --glob '!.*' "status: needs-review" {vault-root}/

# Specs still in draft / accepted — unchanged (type: + status: fields)
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: draft"
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: accepted"

# Data designs referencing a specific api-spec — unchanged (refs:.* + undated api)
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/data-designs/
```

---

### `all`

Apply this section to switch from the current alternative to `all`.

#### `manifest.yaml` — `types` section

Add `dated: true` to all 15 types.

```
  # Requirements
  - name: feature-brief
    prefix: fb-
    template: templates/feature-brief.md
    dated: true
  - name: prd
    prefix: prd-
    template: templates/prd.md
    dated: true
  - name: press-release
    prefix: pr-
    template: templates/press-release.md
    dated: true
  - name: user-story
    prefix: story-
    template: templates/user-story.md
    dated: true

  # Design
  - name: user-flow
    prefix: uf-
    template: templates/user-flow.md
    dated: true
  - name: design-spec
    prefix: ds-
    template: templates/design-spec.md
    dated: true

  # Architecture
  - name: adr
    prefix: adr-
    template: templates/adr.md
    dated: true
  - name: system-architecture
    prefix: sa-
    template: templates/system-architecture.md
    dated: true
  - name: api-spec
    prefix: api-
    template: templates/api-spec.md
    dated: true
  - name: data-design
    prefix: dd-
    template: templates/data-design.md
    dated: true

  # Development
  - name: tech-design
    prefix: td-
    template: templates/tech-design.md
    dated: true
  - name: task
    prefix: task-
    template: templates/task.md
    dated: true

  # Planning
  - name: plan
    prefix: plan-
    template: templates/plan.md
    dated: true

  # Verification
  - name: test-spec
    prefix: ts-
    template: templates/test-spec.md
    dated: true

  # General
  - name: note
    prefix: note-
    template: templates/note.md
    dated: true
```

#### `reference/artifact-frontmatter.md` — ID Naming Pattern

```
## ID Naming Pattern

`{YYYY-MM-DD}-{prefix}-{descriptor}` — creation date prefix, stable for the artifact's
lifetime. Lowercase, hyphen-separated only.

Rules:
- No auto-incrementing integers
- Date prefix is **creation date only** — never updated on revision or re-acceptance
  (keeps IDs stable so `refs`/`feature`/`story` links don't break)
- Prefix list is authoritative in `../manifest.yaml` under `types`

Examples: `2026-06-21-fb-user-authentication-login`, `2026-06-21-api-user-authentication`, `2026-06-21-dd-user-authentication`, `2026-06-21-task-token-generation-be`.
```

#### `reference/artifact-frontmatter.md` — Optional Fields (feature description)

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD. This links the artifact to its requirements root; see `artifact-dep-graph.md`. The ID format follows the ID Naming Pattern above (all IDs are date-prefixed under the `all` alternative).
```

#### `reference/vault-queries.md`

Add this note at the top of the query section, after the existing intro paragraph:

```
**All artifact IDs are date-prefixed** (`YYYY-MM-DD-{prefix}-{descriptor}`). Queries
that anchor on `^id:` must use `id:.*` (wildcard) instead of `^id:` (line-start anchor).
`type:` and `status:` queries are unaffected.
```

Updated queries (replace all `^id:` and `feature:`/`story:` anchored queries):

```bash
# Find the PRD for a feature (by its root id, e.g. prd-user-auth)
rg -l --glob '!.*' "id:.*prd-user-auth" {vault-root}/

# All downstream artifacts tied to a feature (via the `feature:` field)
rg -l --glob '!.*' "feature:.*prd-user-auth" {vault-root}/

# Find a specific artifact by id
rg -l --glob '!.*' "id:.*prd-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
rg -l --glob '!.*' "story:.*story-user-login" {vault-root}/tasks/
```

All `type:` and `status:` queries remain unchanged. `refs:.*` queries remain unchanged
(already wildcarded).

---

## Apply

1. **Read `manifest.yaml`** — check whether any type already has `dated: true`. If the
   chosen alternative is already the current state, skip to Verify.

2. **L1 — Templates:** Run the find commands for the chosen alternative's dated
   prefixes. For each file returned, apply the token map find/replace for every dated
   prefix. Work prefix-by-prefix (not file-by-file) to keep the operation uniform.
   Use whatever tool you choose (sed, Edit, or a mix).

3. **L2 — `manifest.yaml`:** Add or remove `dated: true` flags on each type to match
   the chosen alternative's column in the dated type sets table.

4. **L2 — `reference/artifact-frontmatter.md`:** Replace the ID Naming Pattern section
   and the `feature` field description in Optional Fields with the chosen alternative's
   full final state above.

5. **L2 — `reference/vault-queries.md`:** Add the dated-type note and update the
   `^id:`/`feature:`/`story:` queries for dated types with `id:.*`/`feature:.*`/`story:.*`
   wildcards, per the chosen alternative's section above.

6. **Run Verify** (below) to catch misses.

---

## Verify

Run these assertions after applying. Expected counts assume a clean seedbed with 15
templates and the `snapshot-style` alternative. Adjust counts for `all` (15 dated types)
or `none` (0 dated types) accordingly.

### `snapshot-style` assertions

```bash
# manifest.yaml: exactly 10 types have dated: true
rg -c "dated: true" manifest.yaml
# Expected: 10

# manifest.yaml: 5 types do NOT have dated: true (living types)
# (Count type entries without dated: true — check by confirming these 5 lack the flag)
rg -A2 "name: system-architecture" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: api-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: data-design" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: design-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: test-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits

# Templates: no residual un-dated IDs for dated prefixes
# (Each of these should return 0 hits after applying)
rg -l "^id: prd-\{slug\}" templates/
# Expected: 0 (was 1: templates/prd.md)
rg -l "^id: story-\{slug\}" templates/
# Expected: 0 (was 1: templates/user-story.md)
rg -l "^id: note-\{slug\}" templates/
# Expected: 0 (was 1: templates/note.md)

# Templates: dated IDs present
rg -l "^id: \{date\}-prd-\{slug\}" templates/
# Expected: 1 (templates/prd.md)
rg -l "^id: \{date\}-story-\{slug\}" templates/
# Expected: 1 (templates/user-story.md)

# Templates: undated types still have un-dated IDs
rg -l "^id: sa-\{slug\}" templates/
# Expected: 1 (templates/system-architecture.md)
rg -l "^id: api-\{slug\}" templates/
# Expected: 1 (templates/api-spec.md)

# artifact-frontmatter.md: "No timestamps" rule is gone
rg "No timestamps" reference/artifact-frontmatter.md
# Expected: 0 hits

# artifact-frontmatter.md: creation-date rule is present
rg "creation date only" reference/artifact-frontmatter.md
# Expected: ≥1 hit

# vault-queries.md: no residual ^id: anchors for dated types
rg "\^id: prd-" reference/vault-queries.md
# Expected: 0 hits
rg "\^id: story-" reference/vault-queries.md
# Expected: 0 hits (if story- query existed)

# vault-queries.md: wildcard queries present for dated types
rg "id:.*prd-" reference/vault-queries.md
# Expected: ≥1 hit
rg "feature:.*prd-" reference/vault-queries.md
# Expected: ≥1 hit
```

### `none` assertions

```bash
# manifest.yaml: no type has dated: true
rg -c "dated: true" manifest.yaml
# Expected: 0

# artifact-frontmatter.md: "No timestamps" rule is present
rg "No timestamps" reference/artifact-frontmatter.md
# Expected: ≥1 hit

# Templates: no {date}- prefix in any id field
rg -l "^id: \{date\}-" templates/
# Expected: 0 hits
```

### `all` assertions

```bash
# manifest.yaml: exactly 15 types have dated: true
rg -c "dated: true" manifest.yaml
# Expected: 15

# Templates: no residual un-dated IDs for any prefix
rg -l "^id: sa-\{slug\}" templates/
# Expected: 0
rg -l "^id: api-\{slug\}" templates/
# Expected: 0
rg -l "^id: dd-\{slug\}" templates/
# Expected: 0
rg -l "^id: ds-\{slug\}" templates/
# Expected: 0
rg -l "^id: ts-" templates/
# Expected: 0
```

---

## Notes

- **Orthogonality with `requirements-root.md`:** This decision is orthogonal to the
  requirements-root decision. The dating token map operates on whatever prefix is
  currently active. If `requirements-root` is applied after `artifact-id-dating`, the
  prefix swap (`prd-` → `fb-` etc.) runs on top of the dated IDs — e.g.
  `{date}-prd-{slug}` → `{date}-fb-{slug}`. If `artifact-id-dating` is applied after
  `requirements-root`, the dating token map uses the current active prefix. Either order
  works; the two decisions touch disjoint aspects of the ID (date prefix vs. type
  prefix).

- **Orthogonality with `ask-threshold.md`:** No interaction — different files entirely.

- **`plan` is the weakest fit in the `snapshot-style` dated set.** Plans get
  re-sequenced as work progresses — more living than the other dated types. Kept dated
  on the "frozen record" rationale; the creation date may go stale faster here than
  elsewhere. Acceptable trade-off for chronological sortability in the `plans/` folder.

- **Considered and rejected — `derivative-only` alternative:** Dating only types with
  outgoing `Produces` edges in the dep graph (prd, user-story, user-flow,
  system-architecture, api-spec, data-design, design-spec, tech-design). Rejected
  because it leaves `adr`, `task`, and `note` undated — the three types where a creation
  date is most human-meaningful (ADR = point-in-time decision; task = "when was this
  done?"; note = scratchpad timestamp). The `snapshot-style` alternative covers both
  derivative anchors and frozen records.

- **Migration caveat for existing vaults:** If the vault already contains artifacts with
  un-dated IDs, applying this decision changes templates and conventions but does **not**
  retroactively rename existing artifact files. Existing artifacts keep their un-dated
  IDs; new artifacts created from updated templates get dated IDs. A separate migration
  pass (not covered by this decision) would be needed to rename existing files and
  update all `refs`/`feature`/`story` links pointing at them.

- **`{date}` placeholder convention:** Templates use `{date}` as the stand-in for the
  creation date, consistent with existing placeholders (`{slug}`, `{title}`, `{N}`).
  The agent filling the template replaces `{date}` with the actual `YYYY-MM-DD` value at
  creation time.
