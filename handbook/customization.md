# Customizing Artifact Decisions

> How to switch the default artifact types for requirements-root and plan alternatives,
> and the ask-threshold policy.

---

## Decisions

The vault ships with concrete defaults:

| Decision | Default | Alternatives |
|---|---|---|
| Requirements-root type | `prd` | `feature-brief`, `press-release` |
| Plan type | `plan` | `work-breakdown-structure`, `implementation-plan` |
| Ask-threshold policy | always-ask-first | `approach-changing-only`, `read-then-confirm` |

Each alternative is realized by a **decision file** in `../decisions/`. A decision file
lists all alternatives for one axis side-by-side. The agent reads the chosen alternative's
section and applies the edits to templates, reference docs, and `manifest.yaml` using its
native file-edit tools. It does **not** touch already-created artifacts — those are
migrated on demand.

For the catalog of available decision files, see `../decisions/README.md`. For the format
conventions that govern decision files, see `../decisions/FORMAT.md`.

## Applying a Decision

Each decision file contains:
- An **alternatives table** — compact overview of all options
- **Per-alternative sections** — full final state of every changed line
- An **Apply** section — step-by-step instructions
- A **Verify** section — grep assertions to confirm the apply succeeded

To apply a decision, reference `handbook/playbooks/customize-artifacts.md` in your AI chat.
The agent will walk you through selecting an alternative and applying it. Or apply
manually: open the decision file, find the chosen alternative's section, and apply the
edits to each target file.

The agent uses its native file-edit tools (Edit, Read) — no `patch`, `yq`, or external
diff tools required. `manifest.yaml` is edited directly like any other file.

## What a Decision Touches

| Layer | Files | What changes |
|---|---|---|
| **L1 — token concretize** | 12 downstream templates | `feature: prd-{slug}` → `feature: {alt}-{slug}`; `../prds/` → `../{alt-folder}/`; refs |
| **L2 — prose dereify** | dep-graph, vocabulary, frontmatter, folder-structure, vault-queries, coordination-decision-tree, PROJECT.md, playbooks/setup.md | Type names, default/alternative labels, example IDs, scan queries |
| **manifest.yaml** | 1 line | `feature_type:` (or `plan_type:`) — edited directly |

Plan decisions are smaller — they touch only the plan template's own identity and
plan-specific reference doc lines, not the `feature:` field (that belongs to the
requirements-root decision).

Ask-threshold decisions touch only `AGENTS.md` (the `## Communication` and
`## Output Style` bullets) — no templates, reference docs, or `manifest.yaml` changes.

## Combining Decisions

Requirements-root, plan, and ask-threshold decisions are **orthogonal** — they touch
disjoint files. Apply them in any order.

## Upgrade Flow

When the seedbed advances and you pull upstream:

| User | Action | Tax |
|---|---|---|
| **Default (prd/plan)** | Pull upstream; artifacts untouched | Zero |
| **Alternative** | Re-apply your decision file onto the new base, then run its §Verify block | Small, per-decision |

The decision file's find commands and token map are drift-tolerant — they locate targets
by pattern, not by exact line numbers. If upstream reworded a line the decision targets,
the agent matches by prose meaning (for L2) or by prefix pattern (for L1). The §Verify
block catches any misses after applying.

L1 (token concretization) is the most upgrade-resilient — frontmatter lines are stable.
L2 (prose) targets the most volatile files and may occasionally need the agent to
interpret the instruction against the new wording.

## Changing a Decision Later

Switching from one alternative to another (e.g. `feature-brief` → `press-release`):

1. Open the decision file (`decisions/requirements-root.md`)
2. Find the new alternative's section
3. Apply its edits to each target file
4. Run the §Verify block

Already-created artifacts are unaffected — only templates and reference docs change.
Migrate existing artifacts on demand by renaming files and updating their
`id:`/`type:`/`feature:` fields.

Alternatives are **peers**, not inverses — switching is always "apply a different
alternative's section." There is no "revert" operation; to go back to a previous
alternative, apply that alternative's section.
