# Folder-Structure Customization — Validity Summary

Companion to `folder-structure-options.md`. Assesses whether the request "create a new
customization under `handbook/customizations/` for folder-structure alternatives" is valid as stated,
against the framework in `handbook/customizations/FORMAT.md`, `handbook/customization.md`, and
`handbook/playbooks/customize-artifacts.md`.

---

## Validity: Partially valid — needs 3 issues resolved before drafting

**What's already valid:**
- **Axis is well-defined:** switches how the 15 artifact-type folders are grouped at vault root.
- **Alternatives are peers:** 5 options (current flat baseline + A/P2/L1/L2) occupy the same slot; no "revert" semantics. ✓
- **Orthogonality holds:** touches `manifest.yaml` `folder:` fields + `reference/folder-structure.md` + `reference/vault-queries.md` — disjoint from `feature_type:` (requirements-root), `dated_types:` (artifact-id-dating), and `AGENTS.md` bullets (ask-threshold). ✓
- **Impact scope is already analyzed:** the options doc's "Impact assessment" table (lines 313-329) enumerates exactly which files move. ✓

## Issues that must be resolved

### 1. Physical folder moves — new operation type
All 3 existing axes are pure text edits. Switching folder-structure alternatives requires **physically moving directories on disk** (e.g. `mv prds/ specs/prds/` for L2). The `customize-artifacts.md` playbook's generic shell says "follow the Apply section" — the folder-structure Apply section must carry the move steps, plus a migration note for already-created artifacts (folder moves are bulk by nature, unlike the on-demand migration the existing axes assume).

### 2. L1 is not a clean peer
The options doc itself flags that L1 "Breaks folder-scoped queries in `reference/vault-queries.md`" — L1 requires query rewrites that go beyond the path-prefix edits the other alternatives need. This asymmetry must be called out in the customization file's Notes section, or L1 needs its own per-alternative query-rewrite section that the others don't need.

## Minor: naming
The current flat baseline is labeled "Current structure (baseline)" but has no short peer name like A/P2/L1/L2. It needs one (e.g. `flat`) to be a proper alternative in the Alternatives table.

---

## Resolved

- ~~New mechanism class required~~ — **Resolved.** The mechanism-class abstraction has been dropped from `handbook/customization.md`, `handbook/playbooks/customize-artifacts.md`, and `handbook/customizations/FORMAT.md`. Axes now declare their layers directly; the playbook's Step 3 is a generic shell that follows each axis's self-contained Apply section. Adding folder-structure no longer requires a new class or framework-doc updates — only the customization file itself + a README row.

- ~~No applied-state home~~ — **Resolved by design.** No new `folder_structure:` manifest field will be added. Instead of detecting the active alternative by reverse-mapping all 15 `folder:` values (fragile), the customization flow uses **mindset + delta selection, then Apply**:

  1. **Selection step** — agent shows each alternative's `mindset:` (1 line, stable across type-list changes) plus a **delta table** showing only where the changed types (relative to the `types:` list the options were designed against) would land under each alternative. Unchanged types' placements are not re-shown — the user already knows them from the current structure.
  2. **User picks** an alternative based on mindset + delta.
  3. **Apply step** — agent computes the full `folder:` mapping for the picked alternative by applying its placement rules to the current `types:` list, then runs the folder moves (see issue #1 below).

  This eliminates the steady-state reverse-mapping fragility: between customization invocations, each type's `folder:` field is read directly when creating artifacts — no structure-level inference needed. The structure is only (re)negotiated when the user invokes the customization, at which point the delta makes mismatches visible *before* selection (no backtrack round).

  The Alternatives table in the customization file therefore carries **placement rules per alternative** (e.g. "type's phase → parent folder" for A, "type's domain → parent folder" for P2), not a fixed 15-row mapping. The agent applies the rules to the current `types:` list to compute the delta at selection time and the full mapping at Apply time.

## Recommendation

Resolve issue #1 (physical folder moves — the Apply section's move steps + bulk-migration note), then draft `handbook/customizations/folder-structure.md`. Issue #2 (L1's query-rewrite asymmetry) is a documentation matter inside the customization file itself.
