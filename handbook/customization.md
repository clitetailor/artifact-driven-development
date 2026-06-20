# Customizing Artifact Decisions

> How to switch the default artifact types for requirements-root and plan alternatives.

---

## Decisions

The vault ships with concrete defaults:

| Decision | Default | Alternatives |
|---|---|---|
| Requirements-root type | `prd` | `feature-brief`, `pitch`, `one-pager`, `press-release` |
| Plan type | `plan` | `work-breakdown-structure`, `implementation-plan` |

Each alternative is realized by a **switch-patch** in `../patches/`. A switch-patch rewrites the scaffolding (templates + reference docs + `manifest.yaml` defaults) from the default type to the alternative. It does **not** touch already-created artifacts — those are migrated on demand.

## Applying a Switch-Patch

Switch-patches are unified diffs. Apply them with `git apply --3way`, which falls back to a 3-way merge when context lines don't match exactly (e.g. after an upstream upgrade introduced nearby changes):

```bash
# From the vault root:
git apply --3way patches/switch-to-feature-brief.patch

# Update manifest.yaml's feature_type (or plan_type) via yq:
yq -i '.feature_type = "feature-brief"' manifest.yaml
```

To check whether a patch will apply cleanly without writing changes:

```bash
git apply --check patches/switch-to-feature-brief.patch
```

If `--check` fails but `--3way` succeeds, the patch had context drift but the actual changed lines were intact — `--3way` resolved it via the embedded blob IDs.

## What a Switch-Patch Touches

| Layer | Files | What changes |
|---|---|---|
| **L1 — token concretize** | 12 downstream templates | `feature: prd-{slug}` → `feature: {alt}-{slug}`; `../prds/` → `../{alt-folder}/`; refs |
| **L2 — prose dereify** | dep-graph, vocabulary, frontmatter, folder-structure, vault-queries, coordination-decision-tree, PROJECT.md, playbooks/setup.md | Type names, default/alternative labels, example IDs, scan queries |
| **manifest.yaml** | 1 line | `feature_type:` (or `plan_type:`) — handled via `yq`, not the patch |

Plan switch-patches are smaller — they touch only the plan template's own identity and plan-specific reference doc lines, not the `feature:` field (that belongs to the requirements-root decision).

## Combining Decisions

Requirements-root and plan switch-patches are **orthogonal** — they touch disjoint lines. Apply both in either order:

```bash
git apply --3way patches/switch-to-feature-brief.patch
git apply --3way patches/switch-to-wbs.patch
yq -i '.feature_type = "feature-brief"' manifest.yaml
yq -i '.plan_type = "work-breakdown-structure"' manifest.yaml
```

## Upgrade Flow

When the seedbed advances and you pull upstream:

| User | Action | Tax |
|---|---|---|
| **Default (prd/plan)** | Pull upstream; artifacts untouched | Zero |
| **Alternative** | Re-apply your switch-patch with `--3way` onto the new base | Small, per-decision |

`--3way` handles context drift automatically via 3-way merge. If the exact changed line itself was reworded upstream, the merge will produce a conflict you resolve by hand — but this is rare and limited to the specific lines the patch changes.

L1 (token concretization) is the most upgrade-resilient — frontmatter lines are stable. L2 (prose) targets the most volatile files and may occasionally need manual conflict resolution.

## Changing a Decision Later

Switching from one alternative to another (e.g. `feature-brief` → `pitch`):

1. Revert to the default base: `git checkout -- .` (restores prd-default)
2. Apply the new patch: `git apply --3way patches/switch-to-pitch.patch`
3. Update manifest: `yq -i '.feature_type = "pitch"' manifest.yaml`

Already-created artifacts are unaffected — only templates and reference docs change. Migrate existing artifacts on demand by renaming files and updating their `id:`/`type:`/`feature:` fields.

## Available Switch-Patches

| Patch | Switches to |
|---|---|
| `switch-to-feature-brief.patch` | `feature-brief` (fb-) |
| `switch-to-pitch.patch` | `pitch` (pitch-) |
| `switch-to-one-pager.patch` | `one-pager` (op-) |
| `switch-to-press-release.patch` | `press-release` (pr-) |
| `switch-to-work-breakdown-structure.patch` | `work-breakdown-structure` (wbs-) |
| `switch-to-implementation-plan.patch` | `implementation-plan` (ip-) |

## Ask-Threshold Switch-Patches

These patches switch the active ask-threshold policy enforced in `AGENTS.md`. Unlike the artifact-type patches above, they touch only `AGENTS.md` (the `## Communication` and `## Output Style` bullets) — no templates, reference docs, or `manifest.yaml` changes.

| Patch | Switches to |
|---|---|
| `switch-to-approach-changing-only.patch` | Ask only when the answer would change the approach/scope; infer trivial details and state the assumption |
| `switch-to-read-then-confirm.patch` | Read the directly-relevant artifact, then state understood intent in one line and ask confirmation before output |

Apply the same way as artifact-type patches:

```bash
git apply --3way patches/switch-to-approach-changing-only.patch
```

No `yq` step — `manifest.yaml` is not involved. To revert, `git apply -R patches/<patch>` restores the default "always ask first" threshold.
