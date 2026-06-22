# Folder-Structure Customization — Validity Summary

Companion to `folder-structure-options.md`. Assesses whether the request "create a new
customization under `handbook/customizations/` for folder-structure alternatives" is valid as stated,
against the framework in `handbook/customizations/FORMAT.md`, `handbook/customization.md`, and
`handbook/playbooks/customize-artifacts.md`.

---

## Validity: Partially valid — needs 4 issues resolved before drafting

**What's already valid:**
- **Axis is well-defined:** switches how the 15 artifact-type folders are grouped at vault root.
- **Alternatives are peers:** 5 options (current flat baseline + A/P2/L1/L2) occupy the same slot; no "revert" semantics. ✓
- **Orthogonality holds:** touches `manifest.yaml` `folder:` fields + `reference/folder-structure.md` + `reference/vault-queries.md` — disjoint from `feature_type:` (requirements-root), `dated_types:` (artifact-id-dating), and `AGENTS.md` bullets (ask-threshold). ✓
- **Impact scope is already analyzed:** the options doc's "Impact assessment" table (lines 313-329) enumerates exactly which files move. ✓

## Issues that must be resolved

### 1. No applied-state home
The 3 existing axes record active state in a single field (`feature_type:`, `dated_types:`) or AGENTS.md bullet lead-in. Folder-structure has **no single field** — the active alternative would have to be inferred by reverse-mapping all 15 `folder:` values, which is fragile (one manual folder move breaks the inference). A new field like `folder_structure: flat` should be added to `manifest.yaml`.

### 2. Physical folder moves — new operation type
All 3 existing axes are pure text edits. Switching folder-structure alternatives requires **physically moving directories on disk** (e.g. `mv prds/ specs/prds/` for L2). The `customize-artifacts.md` playbook's generic shell says "follow the Apply section" — the folder-structure Apply section must carry the move steps, plus a migration note for already-created artifacts (folder moves are bulk by nature, unlike the on-demand migration the existing axes assume).

### 3. L1 is not a clean peer
The options doc itself flags that L1 "Breaks folder-scoped queries in `reference/vault-queries.md`" — L1 requires query rewrites that go beyond the path-prefix edits the other alternatives need. This asymmetry must be called out in the customization file's Notes section, or L1 needs its own per-alternative query-rewrite section that the others don't need.

## Minor: naming
The current flat baseline is labeled "Current structure (baseline)" but has no short peer name like A/P2/L1/L2. It needs one (e.g. `flat`) to be a proper alternative in the Alternatives table.

---

## Resolved

- ~~New mechanism class required~~ — **Resolved.** The mechanism-class abstraction has been dropped from `handbook/customization.md`, `handbook/playbooks/customize-artifacts.md`, and `handbook/customizations/FORMAT.md`. Axes now declare their layers directly; the playbook's Step 3 is a generic shell that follows each axis's self-contained Apply section. Adding folder-structure no longer requires a new class or framework-doc updates — only the customization file itself + a README row.

## Recommendation

Resolve issues 1-2 first (they're structural — the `folder_structure:` manifest field and the folder-move Apply steps), then draft `handbook/customizations/folder-structure.md`. Issue 3 is a documentation matter inside the customization file itself.
