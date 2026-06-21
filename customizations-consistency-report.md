# Customizations Consistency Report

### Files reviewed
- `customizations/README.md`, `FORMAT.md`
- `customizations/requirements-root.md`, `ask-threshold.md`, `artifact-id-dating.md`
- Cross-checked against: `manifest.yaml`, `AGENTS.md`, all 15 templates, `reference/` docs, `PROJECT.md`, `handbook/playbooks/setup.md`, `handbook/customization.md`, `handbook/playbooks/customize-artifacts.md`

---

### `ask-threshold.md` — CLEAN

Fully consistent with FORMAT.md, README.md, and the current `AGENTS.md` state (`always-ask-first` is active). Alternatives table has the Role column, all three per-alternative sections present, Apply/Verify/Notes all correct. No issues found.

---

### `artifact-id-dating.md` — 2 minor issues

**Issue A — Missing "role" column in Alternatives table.** FORMAT.md §Alternatives table specifies "prefix, folder, role (default/alternative), and key identifiers." This file's table has `| Alternative | Dated types | Undated types |` with no role column. `none` is the shipped default; the other two are alternatives. `ask-threshold.md` has the Role column; this one should too.

**Issue B — No per-alternative sections (structural deviation).** FORMAT.md Principle 7 says an alternative with only a table row (no per-alternative section) is "pending." This file has no `### none`, `### snapshot-style`, `### all` sections — the manifest field values are inline in the Apply section instead. The content is all there and correct (I verified all 15 type prefixes against `manifest.yaml`, the 10/5 split is accurate, the `snapshot-style` rationale lists match the table). But the structure doesn't match FORMAT.md's expected per-alternative section pattern. `handbook/customization.md` line 31-32 says manifest-only class uses "the manifest field value" as the per-alternative content — so inline-in-Apply may be acceptable, but it conflicts with Principle 7's "only a row = pending" rule.

**Placeholder reference updated:** The "Template placeholder reference" section now documents four placeholder forms (added `{feature-id}` / `{feature-link}` for option-agnostic requirements-root references). The placeholder contexts table now uses `{feature-id}` for requirements-root references instead of `{prd-id}`. Verified against actual template content — all 10 downstream templates use `{feature-id}` / `{feature-link}` (0 residual `{prd-*}` placeholders).

**Everything else checks out:** dated type sets table (15 types, prefixes, ✓/— grid) all match `manifest.yaml`; Apply/Verify blocks are correct; orthogonality notes are accurate.

---

### `requirements-root.md` — CLEAN (refactored to Manifest-only class)

**Previous state (6 issues, all now moot):** This file was previously a Template-touching class axis with L1 (template placeholder swaps) and L2 (reference-doc prose relabeling) sections. Six issues were found — a broken Verify section, three stale L2 "full final state" blocks, and two missing edits — all caused by L2 prose blocks drifting from the reference docs they claimed to control.

**Refactor:** The axis has been refactored to a **Manifest-only class** — only `manifest.yaml`'s `feature_type:` field changes when switching alternatives. The L1 and L2 sections were removed entirely.

This was achieved by making templates and reference docs **option-agnostic**:
- **L1 templates** now use generic `{feature-id}` / `{feature-link}` placeholders (replacing the type-specific `{prd-id}` / `{prd-link}`) that resolve the active type from `manifest.yaml`'s `feature_type:` at fill time. Verified: 26 placeholder swaps across 10 downstream templates, 0 residual `{prd-*}` / `{fb-*}` / `{pr-*}` placeholders.
- **L2 reference docs** (`artifact-vocabulary.md`, `folder-structure.md`, `artifact-frontmatter.md`, `vault-queries.md`, `artifact-dep-graph.md`, `coordination-decision-tree.md`, `PROJECT.md`) now describe the requirements root generically and point to `manifest.yaml`'s `feature_type:` as the source of truth. No prose swaps needed when switching.
- **`manifest.yaml`** `feature_type:` comment updated to clarify it is the single source of truth.

**Current state:** All 6 previous issues are moot (the L1/L2 sections that contained them no longer exist). The file now follows the same Manifest-only pattern as `artifact-id-dating.md`: alternatives table, per-alternative manifest values, Apply (single manifest edit), Verify (manifest field + placeholder sanity checks), Notes (orthogonality, migration).

**Minor: Missing "role" column in Alternatives table** — same as `artifact-id-dating.md` Issue A. The table has `| Alternative | Prefix | Folder | Display name |` with no role column. `prd` is the shipped default (labeled "(default)" in the prose but not in the table).

---

### Cross-file consistency — OK

- `README.md` table lists all 3 axes with correct alternatives ✓
- `handbook/customization.md` mechanism-class table lists all 3 axes correctly (requirements-root now in Manifest-only class) ✓
- `handbook/playbooks/customize-artifacts.md` describes all 3 mechanism classes correctly ✓
- `manifest.yaml` current state (`feature_type: prd`, `dated_types: []`) matches the "default" alternatives ✓
- `AGENTS.md` current state matches `always-ask-first` ✓
- Templates use `{feature-id}` / `{feature-link}` (option-agnostic) — verified 26 placeholders across 10 downstream templates, 0 residual type-specific placeholders ✓
- L2 reference docs are option-agnostic — verified no "default requirements-root" / "requirements-root alternative" labels remain in reference docs or PROJECT.md (only in `artifact-dep-graph.md`'s note, which intentionally says "framework default" + points to manifest) ✓
- All 15 type prefixes in `artifact-id-dating.md` match `manifest.yaml` ✓
- `artifact-id-dating.md` snapshot-style 10/5 split is internally consistent ✓
- Orthogonality claims are accurate (axes touch disjoint manifest fields) ✓

---

### Summary by severity

| Severity | File | Issue |
|---|---|---|
| **Format** | requirements-root.md, artifact-id-dating.md | Missing "role" column in Alternatives table (FORMAT.md requires it) |
| **Format** | artifact-id-dating.md | No per-alternative sections — content is inline in Apply, conflicts with Principle 7 |

All previously-listed Broken/Corrupting/Stale/Incomplete issues in `requirements-root.md` are resolved by the Manifest-only refactor — the L1/L2 sections that contained them no longer exist.
