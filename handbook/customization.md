# Customizing Artifact Decisions

> How customization files work — layers, applying, combining, upgrade flow.
> For the catalog of available axes, see `../customizations/README.md`.

---

## What a Decision Touches

A customization axis touches one or more **layers** — kinds of edits it makes to the
vault. The layer catalog lives in `../customizations/FORMAT.md` → "Layers"; each axis
declares which layers it uses in its **What changes** section.

In brief, the four layers are:

- **L1 — templates:** placeholder swaps across downstream templates.
- **L2 — reference docs & handbook:** prose relabeling across reference docs.
- **manifest.yaml:** one or more field edits.
- **AGENTS.md:** bullet replacements.

Templates use parameterized placeholders (e.g. `{feature-id}`, `{prefix}-{slug}`) and
reference docs are option-agnostic where possible — both resolve the active value from
the manifest at fill/read time. Axes that touch only `manifest.yaml` (e.g.
requirements-root, artifact-id-dating) need no template or reference-doc edits; axes
that touch only `AGENTS.md` (e.g. ask-threshold) need no manifest edits.

## Applying a Decision

Each customization file contains:
- An **alternatives table** — compact overview of all options
- **Per-alternative sections** — full final state of every changed line, or just the
  manifest field value for axes that touch only `manifest.yaml`
- An **Apply** section — self-contained step-by-step instructions (the source of truth
  for the apply procedure)
- A **Verify** section — grep assertions to confirm the apply succeeded

To apply a decision, reference `handbook/playbooks/customize-artifacts.md` in your AI chat.
The agent will walk you through selecting an alternative and applying it. Or apply
manually: open the customization file, find the chosen alternative's section, and follow
the Apply section's steps.

The agent uses its native file-edit tools (Edit, Read) — no `patch`, `yq`, or external
diff tools required. `manifest.yaml` is edited directly like any other file.

## Combining Decisions

Customization axes are **orthogonal** when they touch disjoint files. All current axes
are pairwise orthogonal — they touch disjoint files and can be applied in any order. To
confirm orthogonality for a new axis, compare its declared file set against existing
axes' file sets.

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

Axes with L1 (placeholder swaps) are upgrade-resilient — frontmatter lines are stable.
Axes with L2 (prose) target the most volatile files and may occasionally need the agent to
interpret the instruction against the new wording. Axes touching only `manifest.yaml` or
`AGENTS.md` bullets are the most resilient of all — one field or two bullets, no pattern
matching needed.

## Changing a Decision Later

Switching from one alternative to another (e.g. `feature-brief` → `press-release` for
requirements-root, or `none` → `snapshot-style` for artifact-id-dating):

1. Open the customization file for the axis (e.g. `customizations/requirements-root.md`)
2. Find the new alternative's section
3. Apply its edits to each target file (per the axis's Apply section)
4. Run the §Verify block

Already-created artifacts are unaffected — only the files the axis touches change (per its
Apply section). Migrate existing artifacts on demand by renaming files and updating their
`id:`/`type:`/`feature:` fields.

Alternatives are **peers**, not inverses — switching is always "apply a different
alternative's section." There is no "revert" operation; to go back to a previous
alternative, apply that alternative's section.
