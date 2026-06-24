# Customization: folder-structure

> Switches how the artifact-type folders are grouped at vault root. Pick one alternative
> below; the agent applies its placement rules, moves the folders in bulk, and updates
> `manifest.yaml` + reference docs. Switching to a different alternative later = apply a
> different alternative's section.
>
> For the apply flow, see `../playbooks/customize-vault.md`.

---

## What changes

The `folder:` field of every type in `manifest.yaml`'s `types:` list, plus the tree diagram
in `reference/folder-structure.md` and the folder-scoped query paths in
`reference/vault-queries.md`. No templates, `AGENTS.md`, ownership, dep-graph, vocabulary, or
ID-format changes — those are type-based, not folder-based.

**Migration model:** bulk move during Apply (file content preserved, paths changed). Unlike
the per-artifact-attribute axes (requirements-root, artifact-id-dating), folder-structure is
a layout change — existing artifact files are moved in bulk to their new parent folders
during Apply, not migrated on demand. A half-moved layout is broken, so the moves + manifest
edits commit in one pass.

**Framework shipped default:** `flat`. The reference docs depict `flat` (all type folders at
vault root) and note that the active layout is determined by `manifest.yaml`'s `folder:`
fields — they are rewritten when you switch.

---

## Alternatives

| Alternative | Role | Grouping axis | Top-level artifact buckets | Root entries (with framework) |
|---|---|---|---|---|
| `flat` | Default | no grouping — flat at root | 15 | 20 |
| `phase` | Alternative | SDLC phase | 6 | 12 |
| `product-technical-delivery` | Alternative | product / technical / delivery | 4 | 10 |
| `lifespan` | Alternative | stable-reference / transient-working | 3 | 9 |

"Default" = the framework's shipped starting option (a static fact). The current layout is
whatever the `folder:` fields in `manifest.yaml` say right now — if every type's `folder:` is
its own root-level folder (e.g. `folder: prds/`), the vault is in `flat`.

Each alternative's section below gives its **placement rule** (the principle for assigning a
type to a parent bucket — used when the `types:` list grows) and a **bucket assignment** table
mapping each current type to its parent. The agent applies the rule + table to the current
`types:` list to compute the full `folder:` mapping at selection time (delta vs. current
layout) and at Apply time (full mapping).

---

## `flat` (default)

No grouping. Every type's folder sits directly at vault root.

**Placement rule:** no parent bucket — `folder: {type-folder}/` (the type's own folder at
vault root). New types get a new root-level folder.

**Bucket assignment:** every type → root (no parent).

**Resulting `folder:` values:** unchanged from the seedbed default — `folder: feature-briefs/`,
`folder: prds/`, …, `folder: notes/`. If the vault is already in `flat`, skip to Verify.

---

## `phase`

Groups type folders by SDLC phase, matching `reference/artifact-dep-graph.md`'s phases and
`manifest.yaml`'s comment dividers.

**Placement rule:** a type's SDLC phase → parent folder. New types are placed under the
parent matching their phase; a type with no clear phase goes under `general/`.

**Bucket assignment:**

| Parent folder | Types |
|---|---|
| `requirements/` | feature-brief, prd, press-release, user-story |
| `design/` | user-flow, design-spec |
| `architecture/` | adr, system-architecture, api-spec, data-design, tech-design |
| `development/` | task, plan |
| `verification/` | test-spec |
| `general/` | note |

**Resulting `folder:` values:** `folder: {parent}/{type-folder}/` — e.g.
`folder: requirements/prds/`, `folder: architecture/adrs/`, `folder: development/tasks/`,
`folder: general/notes/`.

---

## `product-technical-delivery`

Groups type folders by whether they are product-facing, technical-facing, or
delivery/execution.

**Placement rule:** a type's domain → parent folder. New types are placed under the parent
matching their domain; a type with no product/technical/delivery signal goes under `general/`.

**Bucket assignment:**

| Parent folder | Types |
|---|---|
| `product/` | feature-brief, prd, press-release, user-story, user-flow, design-spec |
| `technical/` | adr, system-architecture, api-spec, data-design, tech-design |
| `delivery/` | task, plan, test-spec |
| `general/` | note |

**Resulting `folder:` values:** `folder: {parent}/{type-folder}/` — e.g.
`folder: product/prds/`, `folder: technical/adrs/`, `folder: delivery/tasks/`,
`folder: general/notes/`.

---

## `lifespan`

Groups type folders by lifespan: stable reference (read across the feature lifecycle) vs
transient working (consumed during a unit of work, then historical). Builds on the seedbed's
existing `notes/` lifespan-aware bucket.

**Placement rule:** a type's lifespan → parent folder. Stable-reference types → `specs/`;
transient-working types → `delivery/`; `note` → `notes/` (its own top-level bucket — do not
nest as `notes/notes/`). New types are placed by the same test: read across the lifecycle →
`specs/`; consumed during a unit of work → `delivery/`.

**Bucket assignment:**

| Parent folder | Types |
|---|---|
| `specs/` | feature-brief, prd, press-release, user-story *(default — see judgment call below)*, user-flow, design-spec, adr, system-architecture, api-spec, data-design, tech-design |
| `delivery/` | task, plan, test-spec |
| `notes/` | note *(no nesting — `folder: notes/`)* |

**The user-story judgment call:** user-story is genuinely borderline. Reference signals
(owned by business-analyst; Given/When/Then AC are spec-like; peer of prd in the dep-graph's
Requirements phase) point to `specs/user-stories/`. Working signals (open/in-progress/done/
withdrawn states like tasks; consumed during implementation; BMAD precedent places stories
with implementation artifacts) point to `delivery/user-stories/`. The default is
`specs/user-stories/` — the seedbed's user-stories are requirements artifacts, not
implementation artifacts. The defensible alternative `delivery/user-stories/` is a documented
choice, not a buried judgment call: at the selection step, surface both placements and let the
user pick; record the choice by setting `folder:` to either `specs/user-stories/` or
`delivery/user-stories/` and moving the folder accordingly.

**Resulting `folder:` values:** `folder: {parent}/{type-folder}/` — e.g. `folder: specs/prds/`,
`folder: specs/adrs/`, `folder: delivery/tasks/`, `folder: notes/` (for note).

---

## Apply

1. **Read `manifest.yaml`** — read the current `types:` list and each type's `folder:` field.
   Compute the target `folder:` mapping for the chosen alternative by applying its placement
   rule + bucket assignment table to the current `types:` list. If every type's current
   `folder:` already matches its target, skip to Verify.

2. **`reference/folder-structure.md`:** rewrite the tree diagram to reflect the target layout
   (parent buckets where the alternative groups, type folders nested under them; framework
   folders `agents/` `conventions/` `reference/` `handbook/` `templates/` and root files
   unchanged).

3. **`reference/vault-queries.md`:** prefix the folder-scoped query paths with the target
   parent bucket. The folder-scoped queries are the ones naming a specific type folder
   (`tasks/`, `test-specs/`, `data-designs/`); type-based queries (`type: api-spec`) are
   unaffected. Under `flat` no path changes.

4. **Filesystem (bulk move — mandatory, not on-demand):** move each type's folder to its
   target parent. This is a layout change, not a per-artifact edit — existing files move in
   bulk (content preserved, paths changed). A half-moved layout is broken, so complete all
   moves before committing.

   **Missing-folder check (run first):** some or all artifact type folders may not exist yet
   in a fresh vault. Before any move, check which target folders are missing:

   ```bash
   # List every type's target folder, then check which don't exist yet.
   # (Computed from the target mapping in step 1.)
   for d in {target-folders}; do [ -d "$d" ] || echo "missing: $d"; done
   ```

   If any folders are missing, **ask the user**:

   > The following artifact folders don't exist yet: {missing-folders}.
   > Create them now as empty directories?

   - **Yes** — `mkdir -p` each missing folder at its target path, then proceed to the move
     procedure below (existing folders are moved, newly created ones are already in place).
   - **No** — skip creation; only move folders that already exist. The vault will have gaps
     until the missing folders are created manually or by a future artifact's creation.

   **Move procedure** (computed from the target mapping in step 1):
   - Create the parent bucket directories the alternative introduces (`mkdir -p …`).
   - For each type whose target folder differs from its current folder:
     `mv {current-folder} {target-parent}/`. Move whole directories — file content is
     untouched. Skip types whose folders were just created in place (nothing to move).
   - Example — `flat → lifespan` (user-story placed at `specs/`):
     ```
     mkdir -p specs delivery
     mv feature-briefs prds press-releases user-stories user-flows design-specs \
        adrs system-architectures api-specs data-designs tech-designs specs/
     mv tasks plans test-specs delivery/
     # notes/ stays at root (its own bucket)
     ```
   - For `flat → phase` and `flat → product-technical-delivery`, the same procedure with the
     alternative's parent buckets and bucket assignment. For switches between two non-flat
     alternatives, move each type folder from its old parent to its new parent and remove the
     now-empty old parents.

5. **`manifest.yaml`:** update each type's `folder:` field to its target value from the
   mapping computed in step 1 (e.g. `folder: specs/prds/` for lifespan). Keep `prefix:`,
   `template:`, and the comment dividers unchanged.

6. **Commit in one pass** — moves + `manifest.yaml` + the two reference docs together. A
   half-moved layout is broken, so do not commit partway. Under git: `git add -A && git commit
   …`; under jj, moves are auto-detected on the next snapshot — describe the new commit and let
   the sync land everything together.

7. **Run Verify** (below) to catch misses.

---

## Verify

```bash
# Every type's folder: field matches the chosen alternative's target mapping.
# Read manifest.yaml's types: list and confirm each folder: equals {parent}/{type-folder}/
# (or {type-folder}/ for flat, and for note under lifespan).
rg "^\s+folder: " manifest.yaml
# Expected: 15 matches — visually confirm each matches the target mapping.

# No type folder remains at a stale root location after a non-flat switch.
# (Run for types that moved — expect no hits at the old root path.)
ls -d prds tasks test-specs 2>/dev/null
# Expected under lifespan: no hits (they now live under specs/ , delivery/).

# The reference tree depicts the target layout.
rg "^├── |^│   ├── " reference/folder-structure.md
# Expected: parent buckets present (for non-flat), type folders nested under them.

# Folder-scoped queries carry the target parent prefix (non-flat only).
rg "\{vault-root\}/(tasks|test-specs|data-designs)/" reference/vault-queries.md
# Expected under flat: matches with no parent prefix.
# Expected under lifespan: matches read {vault-root}/delivery/tasks/ etc.
```

If a `folder:` field is stale, re-edit it. If a folder wasn't moved, move it and re-run. If a
reference doc still shows the old layout, re-apply steps 2–3.

---

## Notes

- **Migration model differs from other axes:** the playbook's default "not touched — on
  demand" applies to per-artifact-attribute axes; folder-structure is a layout change, so
  existing files are moved in bulk during Apply (content preserved, paths changed). See the
  Apply section's Filesystem step.

- **No applied-state field:** there is no `folder_structure:` manifest field. The active
  layout is read directly from each type's `folder:` value. The customization flow uses
  mindset + delta selection, then Apply: at selection, the agent shows each alternative's
  grouping axis (1 line) plus a delta table of only the types whose placement would change;
  the user picks; at Apply, the agent computes the full mapping and runs the moves.

- **Orthogonality:** touches `manifest.yaml` `folder:` fields + `reference/folder-structure.md`
  + `reference/vault-queries.md` — disjoint from `feature_type:` (requirements-root),
  `dated_types:` (artifact-id-dating), and `AGENTS.md` bullets (ask-threshold). Apply in any
  order.

- **Type-based concerns are unaffected:** ownership (`reference/artifact-ownership.md`), the
  dependency graph (`reference/artifact-dep-graph.md`), vocabulary, templates, and `AGENTS.md`
  are all type-based, not folder-based — they do not change.

- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different alternative's section" — there is no "revert" operation.
