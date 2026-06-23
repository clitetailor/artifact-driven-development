# Folder-Structure Customization — Validity Summary

Companion to `folder-structure-options.md`. Assesses whether the request "create a new
customization under `handbook/customizations/` for folder-structure alternatives" is valid as stated,
against the framework in `handbook/customizations/FORMAT.md`, `handbook/customization.md`, and
`handbook/playbooks/customize-artifacts.md`.

---

## Validity: Partially valid — needs issue #1 resolved before drafting

**What's already valid:**
- **Axis is well-defined:** switches how the 15 artifact-type folders are grouped at vault root.
- **Alternatives are peers:** 4 options (`flat` baseline + `phase` / `product-technical-delivery` / `lifespan`) occupy the same slot; no "revert" semantics. ✓
- **Orthogonality holds:** touches `manifest.yaml` `folder:` fields + `reference/folder-structure.md` + `reference/vault-queries.md` — disjoint from `feature_type:` (requirements-root), `dated_types:` (artifact-id-dating), and `AGENTS.md` bullets (ask-threshold). ✓
- **Impact scope is already analyzed:** the options doc's "Impact assessment" table (lines 260-276) enumerates exactly which files move. ✓

## Issues that must be resolved

### 1. Physical folder moves — new operation type
All 3 existing axes are pure text edits. Switching folder-structure alternatives requires **physically moving directories on disk** (e.g. `mv prds/ specs/prds/` for `lifespan`). Folder moves are bulk by nature — the manifest's `folder:` field is a single value per type, so either all files of a type move together during Apply or the layout is split-brain. This differs from the on-demand migration the other axes assume (per-artifact attribute carried inside each file, fixable lazily when next edited).

**Decision (axis-file override):** Step 2's confirmation line "Already-created artifacts are not touched — they are migrated on demand" is false for this axis. Rather than rewrite the playbook promise for all axes, the axis file overrides it — Step 2 reads a **Migration model** line from the axis's What-changes section; if present, surfaces it instead of the default. The 3 existing axes keep their promise (no Migration model line → default applies); folder-structure declares its own; future file-moving axes declare theirs. Surfacing lands at two points: Step 2 (informed consent at the gate) and the Apply section's Filesystem step (just-in-time preface above the `mv` commands).

**Deliverables:**
1. **`handbook/customizations/folder-structure.md`** —
   - What-changes section: a `**Migration model:**` line — "bulk move during Apply (file content preserved, paths changed)".
   - Apply section: a **Filesystem (bulk move — mandatory, not on-demand)** preface above the `mv` steps, plus the move commands per alternative. Commit moves in one pass — a half-moved layout is broken.
   - Notes section: a bullet — "Migration model differs from other axes: the playbook's default 'not touched — on demand' applies to per-artifact-attribute axes; folder-structure is a layout change, so existing files are moved in bulk during Apply (content preserved, paths changed). See the Apply section's Filesystem step."
   - Alternatives table placement rules: the `lifespan` alternative's rule for `user-story` must encode both the default (`specs/user-stories/`) *and* the defensible alternative (`delivery/user-stories/`), surfacing it as a documented choice in the selection step rather than burying the judgment call. This preserves the transparency established in `folder-structure-options.md` → "The user-story judgment call".
2. **`handbook/playbooks/customize-artifacts.md`** Step 2 — add one clause: "If the axis's What-changes section declares a Migration model, surface that instead of the default 'not touched — on demand' line."
3. **`handbook/customizations/FORMAT.md`** — one-line guidance under the What-changes item (item 2): "Axes that move existing files declare a `**Migration model:**` line here; Step 2 surfaces it instead of the default on-demand line."
4. **`handbook/customizations/README.md`** — add the folder-structure row to the Available customizations table.

## Minor: naming — Resolved
The exploration doc (`folder-structure-options.md`) labeled alternatives as codes: `A`, `P2`, `L2`, with the baseline unlabeled. The customization framework's sibling axes all use descriptive kebab-case word labels (`prd` / `feature-brief` / `press-release`; `none` / `snapshot-style` / `all`; `always-ask-first` / `approach-changing-only` / `read-then-confirm`). Folder-structure should match its siblings, not invent a code convention.

**Chosen labels (all four, replacing the codes):**

| Old | New | Grouping axis |
|---|---|---|
| (baseline) | `flat` | no grouping, flat at root |
| `A` | `phase` | SDLC phase |
| `P2` | `product-technical-delivery` | product / technical / delivery |
| `L2` | `lifespan` | stable-reference / transient-working |

Rejected: keeping codes + adding `F0` for the baseline — internally consistent but breaks consistency with the 3 sibling axes; hybrid (codes in options doc, words in customization file) — divergent labels for the same alternatives force a mental mapping.

**Deliverable:** rename A/P2/L2 → `phase` / `product-technical-delivery` / `lifespan` in `folder-structure-options.md` (section headers + impact assessment table) when drafting `handbook/customizations/folder-structure.md`, so both docs use the same labels. The customization file is drafted with the word labels from the start.

---

## Resolved

- ~~New mechanism class required~~ — **Resolved.** The mechanism-class abstraction has been dropped from `handbook/customization.md`, `handbook/playbooks/customize-artifacts.md`, and `handbook/customizations/FORMAT.md`. Axes now declare their layers directly; the playbook's Step 3 is a generic shell that follows each axis's self-contained Apply section. ~~Adding folder-structure no longer requires framework-doc updates — only the customization file itself + a README row.~~ **Superseded by issue #1 decision:** the user chose a Step 2 axis-file override, which adds a one-clause conditional to the playbook's Step 2 and a one-line guidance note to FORMAT.md. These are scoped additions for the migration-model surfacing, not a revival of the mechanism-class abstraction.

- ~~No applied-state home~~ — **Resolved by design.** No new `folder_structure:` manifest field will be added. Instead of detecting the active alternative by reverse-mapping all 15 `folder:` values (fragile), the customization flow uses **mindset + delta selection, then Apply**:

  1. **Selection step** — agent shows each alternative's `mindset:` (1 line, stable across type-list changes) plus a **delta table** showing only where the changed types (relative to the `types:` list the options were designed against) would land under each alternative. Unchanged types' placements are not re-shown — the user already knows them from the current structure.
  2. **User picks** an alternative based on mindset + delta.
  3. **Apply step** — agent computes the full `folder:` mapping for the picked alternative by applying its placement rules to the current `types:` list, then runs the folder moves (see issue #1 below).

  This eliminates the steady-state reverse-mapping fragility: between customization invocations, each type's `folder:` field is read directly when creating artifacts — no structure-level inference needed. The structure is only (re)negotiated when the user invokes the customization, at which point the delta makes mismatches visible *before* selection (no backtrack round).

  The Alternatives table in the customization file therefore carries **placement rules per alternative** (e.g. "type's phase → parent folder" for `phase`, "type's domain → parent folder" for `product-technical-delivery`), not a fixed 15-row mapping. The agent applies the rules to the current `types:` list to compute the delta at selection time and the full mapping at Apply time.

## Recommendation

Resolve issue #1 per the deliverables above (folder-structure.md with Migration model line + Apply Filesystem preface + Notes bullet; playbook Step 2 conditional clause; FORMAT.md one-line guidance; README row) and the naming deliverable (rename A/P2/L2 → `phase` / `product-technical-delivery` / `lifespan` in `folder-structure-options.md`), then draft `handbook/customizations/folder-structure.md` with the word labels from the start.
