# Patch-Driven Decisions — Verification

> Verification of the three points raised against the patch-file proposal, the resulting verdict, and the updated plan.

The grep confirms point 3 concretely. Now I have everything to verify all three points and update the plan.

## Verification of your three points

### Point 1 — re-render friction: valid, with one nuance

True. Once a user has applied patches (or rendered Jinja) and then edited the concrete files, re-rendering Jinja is destructive — it regenerates from the template and overwrites their edits unless they re-merge variables into diverged files. Patches match the actual workflow better: apply once, then own the concrete file. Jinja's variable machinery implies a recurrent render step (that's why variables exist), which is a footgun in a one-shot workflow.

The nuance: this friction isn't unique to Jinja — re-applying a patch to a user-diverged scaffolding file also conflicts. The difference is workflow shape: patches don't invite re-application (they're init-time), while Jinja invites re-rendering (variables exist to be re-rendered). So patches are safer-by-default for the one-shot model. Your framing is correct.

One clarification that matters for the plan: both patches and render touch only scaffolding (templates + reference docs). The user's actual artifacts (`prds/prd-foo.md`, `user-stories/story-bar.md`) live in separate folders and are untouched by either approach. So "re-render overwrites user work" only applies to user edits on scaffolding, which is rare. The friction is real but narrower than it sounds.

### Point 2 — agents working with Jinja versions: valid

True. An agent filling a PRD from a Jinja template would see `# {{ title }}` and `{% if include_timeline %}## Timeline{% endif %}` — conditional branches mean multiple template versions coexist in one file, and the agent must pick. With patches applied, the agent reads one concrete markdown file with no syntax. The base version is what upstream maintains; patches derive alternatives; the agent never sees patch syntax because patches run at init, not use-time. This is a genuine agent-UX win and aligns with your "one base version for updating, patches updated later" model.

I can't empirically test agent confusion, but the a priori claim is sound: placeholders (`{title}`) are universally understood by agents; template directives (`{% if %}`) add parsing load and ambiguity about what's literal vs conditional.

### Point 3 — role vocabulary confusion: valid, and worse than I noted

Confirmed by grep. The word "role" is overloaded across three distinct concepts in this repo:

- **Agent roles** — `artifact-ownership.md` is titled `# Agent Roles & Artifact Ownership`; every `agents/*.md` has a `## Role` section; `api-conventions.md` has `### Role→permission map`.
- **Artifact type roles** — `manifest.yaml` `role: requirements-root` / `role: plan`; `artifact-dep-graph.md` `## Roles & Alternatives`.
- **Domain roles (RBAC)** — `api-conventions.md` `Role→permission map`.

An end-user sees `role: requirements-root` in manifest and `## Role` in an agent doc and `# Agent Roles` in ownership — three meanings of one word. Removing the artifact-type `role:` eliminates the middle layer and the collision between #1 and #2. This is a real legibility cost of the current model that I underweighted before.

## How this changes the verdict

Previously I leaned toward the hybrid (keep roles in docs, patch only L1 templates) to avoid L2 upgrade tax. Your three points shift the calculus: the role concept has costs beyond duplication — vocabulary collision (#3), workflow mismatch (#1), agent-UX friction (#2). Those costs justify removing the role abstraction entirely (L2 included) and accepting the L2 upgrade tax as the price. So: drop the hybrid recommendation; go full patch / concrete-default.

## Updated plan — invert the design

The key realization: this repo **is** the seedbed (`seedbed.source: ""`, `framework_version: "0.2.0"`). You maintain upstream. So you don't need a "base + remove-role patch + concretize patch" stack — you edit the seedbed directly into the concrete-prd-default form, and ship patches that switch to alternatives.

### Step 1 — edit the seedbed to concrete-prd-default (direct edit, not a patch)

| File | Change |
|---|---|
| `manifest.yaml` | `feature_type: feature-brief` → `feature_type: prd`; drop every `role:` line; drop the `role:` comments. Keep all 5 req types + 3 plan types registered (alternatives stay *available*). |
| `artifact-dep-graph.md` | Delete `## Roles & Alternatives` (lines 4-13); concretize phase table, mermaid nodes, dependency table to `prd` / `plan`. |
| `artifact-vocabulary.md` | Delete `role` and `requirements-root` entries; reframe the 5 req entries + `plan` entry as concrete types, not "alternatives." |
| `artifact-frontmatter.md` (line 31) | "whichever root type" → "the feature's PRD (`prd-`)." |
| `folder-structure.md` (9-13, 23-25) | Drop "— requirements-root alt" / "— plan-role alt" annotations. |
| `vault-queries.md` (4, 12-16, 18-19, 22) | Root/plan scan queries → single `type: prd` / `type: plan`; examples `fb-` → `prd-`. |
| `coordination-decision-tree.md` (14, 24, 40) | `feature-brief` → `prd`. |
| `PROJECT.md` (21-28) | "Requirements Roots" → "PRDs" framing. |
| `setup.md` (62) | Default pattern `feature-brief` → `prd`. |
| 12 downstream templates | `feature: {root-id}` → `feature: prd-{slug}`; `{root-folder}` → `prds`; refs `{root-id}` → `prd-{slug}`. |

After this, the seedbed is clean concrete-prd, no `role:` anywhere, no "Roles & Alternatives" section. Default users clone and use it directly — zero patches, zero upgrade tax.

### Step 2 — ship switch-patches for alternatives

`patches/switch-to-feature-brief.patch`, `patches/switch-to-pitch.patch`, `patches/switch-to-one-pager.patch`, `patches/switch-to-press-release.patch`, `patches/switch-to-wbs.patch`, `patches/switch-to-implementation-plan.patch`.

Each patch is the diff from prd-concrete-base to {alt}-concrete: re-concretize the same surface (dep-graph cells, vocab, frontmatter prose, folder annotations, vault-queries, PROJECT.md, setup.md, 12 downstream templates) from `prd`/`prds/`/`prd-{slug}` to the alternative. Plus a `yq` one-liner for `manifest.yaml` `feature_type`.

### Step 3 — upgrade flow (revised)

| User | Upgrade action | Tax |
|---|---|---|
| Default (prd) — the majority | `jj rebase`/pull upstream; artifacts untouched | Zero |
| Alternative (e.g. fb) | re-apply `switch-to-feature-brief.patch` onto new upstream base; resolve L2 hunks on dep-graph/vocab prose drift | L2 rebase, recurs, but patch is small and per-decision |

This is strictly better than my earlier plan: default users pay nothing (previously everyone paid via the base-remove-role patch), and alternative users pay only the switch surface (smaller than the full dereification surface).

## Two open decisions I need from you

1. **Field name** — your example wrote `feature-brief: fb-{slug}`, which looks like the field name changes per decision. The current field is `feature:` (stable). Renaming the field per decision breaks the grep recipes in `vault-queries.md` (`feature: fb-user-auth`) and means every switch-patch also renames the field across 12 templates. I strongly recommend keeping `feature:` stable and only concretizing the value (`feature: prd-{slug}` → `feature: fb-{slug}`). Confirm?

2. **Template placeholder concretization (L1)** — two sub-options:
   - **Plan B (concrete):** seedbed templates say `feature: prd-{slug}`; switch-patches re-concretize L1+L2. Full concreteness for agents; L1 patch is cheap and upgrade-resilient (frontmatter lines are stable). Matches your stated concreteness desire.
   - **Plan A (generic):** seedbed templates keep `feature: {root-id}`; switch-patches are L2-only (prose). Smaller patch surface; agents see a placeholder (still clean, no role machinery) instead of a concrete example.

   I lean **Plan B** since L1 is cheap and you explicitly want concrete files for agent clarity. But if you want to minimize the alternative-user patch surface, Plan A is the leaner option. Which?
