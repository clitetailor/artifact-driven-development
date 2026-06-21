# Customizing Artifact Decisions

> How customization files work — mechanism classes, applying, combining, upgrade flow.
> For the catalog of available axes, see `../customizations/README.md`.

---

## Mechanism Classes

Every customization axis falls into one of three mechanism classes, determined by which
files its alternatives touch. The class dictates the apply flow.

| Class | What it touches | Example axes |
|---|---|---|
| **Template-touching** | L1 templates (placeholder swaps) + L2 reference docs & handbook (prose relabeling) + `manifest.yaml` (one field) | *(no current axes — kept for future axes that need prose swaps)* |
| **AGENTS-only** | `AGENTS.md` bullets only | ask-threshold |
| **Manifest-only** | One `manifest.yaml` field only — templates and reference docs are already parameterized/option-agnostic | requirements-root, artifact-id-dating |

Each alternative is realized by a **customization file** in `../customizations/`. A
customization file lists all alternatives for one axis side-by-side. The agent reads the
chosen alternative's section and applies the edits using its native file-edit tools. It
does **not** touch already-created artifacts — those are migrated on demand.

For the catalog of available customization files, see `../customizations/README.md`. For
the format conventions that govern customization files, see `../customizations/FORMAT.md`.

## Applying a Decision

Each customization file contains:
- An **alternatives table** — compact overview of all options
- **Per-alternative sections** — full final state of every changed line (template-touching
  and AGENTS-only classes) or the manifest field value (manifest-only class)
- An **Apply** section — step-by-step instructions
- A **Verify** section — grep assertions to confirm the apply succeeded

To apply a decision, reference `handbook/playbooks/customize-artifacts.md` in your AI chat.
The agent will walk you through selecting an alternative and applying it. Or apply
manually: open the customization file, find the chosen alternative's section, and apply the
edits to each target file.

The agent uses its native file-edit tools (Edit, Read) — no `patch`, `yq`, or external
diff tools required. `manifest.yaml` is edited directly like any other file.

## What a Decision Touches

The files touched depend on the axis's mechanism class (see the table above). For the
**template-touching** class *(no current axes — kept for future axes that need prose
swaps)*, the layers are:

| Layer | Files | What changes |
|---|---|---|
| **L1 — placeholder swap** | downstream templates | `{cur-id}` → `{new-id}`; `{cur-link}` → `{new-link}` (parameterized placeholders; see `customizations/artifact-id-dating.md` → "Template placeholder reference") |
| **L2 — prose relabel** | reference docs & handbook | Type names, default/alternative labels, example IDs, scan queries |
| **manifest.yaml** | 1 line | the relevant field — edited directly |

The **AGENTS-only** class touches two bullets in `AGENTS.md` (`## Communication` and
`## Output Style`) — no templates, reference docs, or `manifest.yaml` changes.

The **manifest-only** class touches a single `manifest.yaml` field (e.g. `feature_type:`,
`dated_types:`) — no templates, reference docs, or `AGENTS.md` changes. Templates use
parameterized placeholders (e.g. `{feature-id}`, `{prefix}-{slug}`) and reference docs are
option-agnostic — both resolve the active value from the manifest at fill/read time.

## Combining Decisions

Customization axes are **orthogonal** when they touch disjoint files. All current axes
are pairwise orthogonal — they touch disjoint files and can be applied in any order. To
confirm orthogonality for a new axis, compare its mechanism class's file set against the
existing axes' file sets.

## Upgrade Flow

When the seedbed advances and you pull upstream:

| User | Action | Tax |
|---|---|---|
| **Default** | Pull upstream; artifacts untouched | Zero |
| **Alternative** | Re-apply your customization file onto the new base, then run its §Verify block | Small, per-decision |

The customization file's find commands and token map are drift-tolerant — they locate targets
by pattern, not by exact line numbers. If upstream reworded a line the decision targets,
the agent matches by prose meaning (for L2) or by placeholder pattern (for L1). The §Verify
block catches any misses after applying.

L1 (placeholder swap) is the most upgrade-resilient — frontmatter lines are stable.
L2 (prose) targets the most volatile files and may occasionally need the agent to
interpret the instruction against the new wording.
Manifest-only and AGENTS-only classes are the most resilient of all — one field or two
bullets, no pattern matching needed.

## Changing a Decision Later

Switching from one alternative to another (e.g. `feature-brief` → `press-release` for
requirements-root, or `none` → `snapshot-style` for artifact-id-dating):

1. Open the customization file for the axis (e.g. `customizations/requirements-root.md`)
2. Find the new alternative's section
3. Apply its edits to each target file (per the axis's mechanism class)
4. Run the §Verify block

Already-created artifacts are unaffected — only templates, reference docs, or manifest
fields change (depending on the class). Migrate existing artifacts on demand by renaming
files and updating their `id:`/`type:`/`feature:` fields.

Alternatives are **peers**, not inverses — switching is always "apply a different
alternative's section." There is no "revert" operation; to go back to a previous
alternative, apply that alternative's section.
