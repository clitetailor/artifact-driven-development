# Patch-Driven Decisions — Plan

> Replace the `role:` abstraction with concrete-default scaffolding + switch-patches for alternatives.

## Problem

The current `role:` abstraction (introduced in commit `0ee6615`) groups interchangeable artifact types (`requirements-root`, `plan`) so a feature can pick one. It carries three costs beyond template duplication:

1. **Vocabulary collision.** "role" is overloaded across three concepts: agent roles (`reference/artifact-ownership.md` titled `# Agent Roles & Artifact Ownership`; every `agents/*.md` has a `## Role` section), artifact-type roles (`manifest.yaml` `role: requirements-root`; `artifact-dep-graph.md` `## Roles & Alternatives`), and domain RBAC (`conventions/api-conventions.md` `### Role→permission map`). End-users see one word, three meanings.
2. **Workflow mismatch with Jinja.** A Jinja/render approach implies a recurrent render step; re-rendering overwrites user edits to scaffolding. The actual workflow is one-shot (apply once, then own the concrete file).
3. **Agent-UX friction.** Jinja conditionals (`{% if %}`) make multiple template versions coexist in one file and force the filling agent to pick branches. Concrete markdown with placeholders (`{title}`) is universally understood and unambiguous.

## Concerns

Two concerns drive the design and must be verified:

1. **Decision independence / low conflict between patch files.** A repo can carry many decisions (which requirements format, which plan format, …) each realized by its own patch file. The decisions are almost separated, so the patch files should introduce the least conflicts possible. This needs verification: do the per-decision patch surfaces overlap, and if so where?
2. **Upgrade-flow smoothness.** Patches are applied once at init and tracked with version control. Because the patches are versioned alongside the base, they should upgrade smoothly when the seedbed advances. Further updates should introduce the least friction. If a user changes a decision later and applies a different patch, that is not a big problem — the change only affects templates and future artifacts, not already-created ones; users migrate them on demand. The question is whether the upgrade path is genuinely smooth or carries recurring tax.

## Approach

Invert the design. This repo **is** the seedbed (`manifest.yaml` `seedbed.source: ""`, `framework_version: "0.2.0"`), so edit the seedbed directly into the concrete-default form and ship patches that *switch* to alternatives — instead of a base + remove-role + concretize stack.

- **Default users (the majority):** clone and use directly. Zero patches, zero upgrade tax.
- **Alternative users:** apply one switch-patch at init; re-apply on upgrade.

## Decisions

- **Default requirements-root type:** `prd`
- **Default plan type:** `plan`
- **Frontmatter field name:** `feature:` (stable). Only the *value* concretizes per decision (`feature: prd-{slug}` → `feature: fb-{slug}`). Renaming the field per decision would break the grep recipes in `reference/vault-queries.md` and inflate every switch-patch.
- **Template concretization (L1):** concrete. Seedbed templates say `feature: prd-{slug}`; switch-patches re-concretize L1 + L2. Full concreteness for agents; L1 patch is cheap and upgrade-resilient (frontmatter lines are stable).

## Change Surface

### Layer split

| Layer | What | Upgrade resilience |
|---|---|---|
| **L1 — token concretize** | `feature: {root-id}` → `feature: prd-{slug}`; `{root-folder}` → `prds`; example ids in queries | High — tokens are stable; surrounding drift doesn't break token-targeted hunks |
| **L2 — prose dereify** | remove "Roles & Alternatives"; collapse vocab entries; rewrite dep-graph cells/prose | Low — targets the most volatile files; expect manual resolution on upgrade |

### Step 1 — edit seedbed to concrete-prd-default (direct edit, not a patch)

| File | Change |
|---|---|
| `manifest.yaml` | `feature_type: feature-brief` → `feature_type: prd`; drop every `role:` line and `role:` comments. Keep all 5 req types + 3 plan types registered (alternatives stay *available*). |
| `reference/artifact-dep-graph.md` | Delete `## Roles & Alternatives` (lines 4-13); concretize phase table (19, 22), mermaid nodes (55, 68), dependency table (78, 86, 88) to `prd` / `plan`. |
| `reference/artifact-vocabulary.md` | Delete `role` (6) and `requirements-root` (7) entries; reframe 5 req entries (8-12) + `plan` entry (21) as concrete types, not "alternatives." |
| `reference/artifact-frontmatter.md` (31) | "whichever root type" → "the feature's PRD (`prd-`)." |
| `reference/folder-structure.md` (9-13, 23-25) | Drop "— requirements-root alt" / "— plan-role alt" annotations. |
| `reference/vault-queries.md` (4, 12-16, 18-19, 22) | Root/plan scan queries → single `type: prd` / `type: plan`; examples `fb-` → `prd-`. |
| `reference/coordination-decision-tree.md` (14, 24, 40) | `feature-brief` → `prd`. |
| `PROJECT.md` (21-28) | "Requirements Roots" → "PRDs" framing. |
| `handbook/setup.md` (62) | Default pattern `feature-brief` → `prd`. |
| 12 downstream templates (incl. 3 plan) | `feature: {root-id}` → `feature: prd-{slug}`; `{root-folder}` → `prds`; refs `{root-id}` → `prd-{slug}`. |
| `templates/work-breakdown-structure.md` (17) | Fix stale `feature-brief` → `prd` in body comment ("Tree: feature-brief → stories → tasks"). Bug missed by `0ee6615`. |
| `templates/implementation-plan.md` (21) | Fix stale `feature-brief` → `prd` in body comment ("the feature-brief's User Stories list"). Bug missed by `0ee6615`. |

After this, the seedbed is clean concrete-prd, no `role:` anywhere, no "Roles & Alternatives" section, no stale `feature-brief` references in plan templates.

### Step 2 — ship switch-patches for alternatives

`patches/switch-to-feature-brief.patch`, `switch-to-pitch.patch`, `switch-to-one-pager.patch`, `switch-to-press-release.patch`, `switch-to-wbs.patch`, `switch-to-implementation-plan.patch`.

**Req switch-patches** (4): re-concretize the req surface from `prd`/`prds/`/`prd-{slug}` to the alternative. Touches `feature:` values + `{root-folder}` + refs across **all 12 downstream templates** (including 3 plan templates — plan templates point at the feature root, so their `feature:` line belongs to the req decision, not the plan decision). Plus dep-graph req cells, vocab req entries, frontmatter prose, folder req annotations, vault-queries req scan, PROJECT.md, setup.md. Plus a `yq` one-liner for `manifest.yaml` `feature_type`.

**Plan switch-patches** (2): re-concretize the plan surface from `plan`/`plans/`/`plan-{slug}` to the alternative. Touches only the plan template's own identity (`id:`, `type:`, body structure) + dep-graph plan cells (line 22, 68, 88), vocab plan entry (line 21), folder plan annotations (23-25), vault-queries plan scan (15-16). Plus a `yq` one-liner for `manifest.yaml` `plan_type`. **Does not touch `feature:` lines** — those belong to the req decision.

This orthogonality means req and plan switch-patches can be applied in either order and never conflict on the plan templates: the req patch touches the `feature:` line, the plan patch touches the `id:`/`type:`/body lines.

### Step 3 — upgrade flow

| User | Upgrade action | Tax |
|---|---|---|
| Default (prd) — majority | `jj rebase`/pull upstream; artifacts untouched | Zero |
| Alternative (e.g. fb) | re-apply `switch-to-feature-brief.patch` onto new upstream base; resolve L2 hunks on dep-graph/vocab prose drift | L2 rebase, recurs, but patch is small and per-decision |

## Scope note

Patches/render touch only **scaffolding** (templates + reference docs). The user's actual artifacts (`prds/prd-foo.md`, `user-stories/story-bar.md`) live in separate folders and are untouched by either approach. "Re-render overwrites user work" applies only to user edits on scaffolding, which is rare.

## Verification status

- **Decision independence (concern #1):** verified for both req and plan sides. The two decisions are line-disjoint in ~90% of the surface. Genuine collisions are exactly 4 shared spots, all the role concept itself (dep-graph Roles section, vocab `role` entry, vault-queries prose, manifest `role:` lines). The inverted design removes these by editing the role concept out of the seedbed directly, so switch-patches never collide on it. **Plan-trio orthogonality confirmed:** req and plan switch-patches are line-disjoint on the plan templates themselves (req patch touches `feature:` line; plan patch touches `id:`/`type:`/body lines) and can be applied in either order.
- **Upgrade flow (concern #2):** partially verified. L1 (token concretization) is genuinely smooth. L2 (prose dereification) targets the most volatile files (`artifact-dep-graph.md`, `artifact-vocabulary.md`) and will need manual resolution on upgrade — recurs, but small and per-decision.
- **Re-render friction (point 1):** valid. Patches match the one-shot workflow; Jinja invites destructive re-rendering.
- **Agent version handling (point 2):** valid. Concrete markdown > Jinja conditionals for filling agents.
- **Role vocabulary confusion (point 3):** valid and confirmed by grep — "role" is overloaded across agent roles, artifact-type roles, and RBAC.
- **Plan-trio structure:** verified. The 3 plan templates share more structure than the 5 req templates — identical frontmatter shape, same `## References` footer, shared sections (Critical Path, Estimates vs Actuals, Risks). Divergence is in the core organizing section (Order vs Deliverable Hierarchy + Effort Rollup vs Story Queue + Task Lanes). This makes plan switch-patches more structurally patch-friendly than req switch-patches.
- **Stale `feature-brief` refs in plan templates:** found. `work-breakdown-structure.md` line 17 and `implementation-plan.md` line 21 still say `feature-brief` in body comments — bugs missed by commit `0ee6615`. Step 1 fixes these.

## Open items

- [ ] Execute Step 1 (seedbed edit)
- [ ] Prototype one switch-patch (`switch-to-feature-brief.patch`) and run `git apply --check` to confirm hunk shapes
- [ ] Decide patch storage location (`patches/` at root vs. elsewhere)
- [ ] Document the switch-patch workflow in `handbook/setup.md` or a new `handbook/customization.md`
