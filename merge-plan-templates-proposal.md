# Proposal: Merge plan templates into one `templates/plan.md`

> Status: **Proposal — no files changed yet.** Review and decide before implementation.
>
> Scope: merge `templates/plan.md`, `templates/implementation-plan.md`, and
> `templates/work-breakdown-structure.md` into a single `templates/plan.md`, with WBS
> provided as a body-variant patch in `decisions/plan-type.md`.

---

## Decision summary (your answers so far)

| Question | Your choice |
|---|---|
| Frontmatter identity per alternative | **Collapse to `plan`** — merged template always uses `type: plan` / `id: plan-{slug}` / `plans/`. Variant is a body-shape only; type distinction is lost. |
| Default body of merged template | **Plan's current body as base** — but refined per the third answer. |
| Common-section naming | **Unify IP and plan structure and wordings; only WBS's differing parts become a patch.** IP and `plan` fuse into one canonical structure; WBS is the sole variant. |

Net shape: **IP + `plan` → one canonical body. WBS → the only patch.**

---

## What the three templates share vs. differ

**Common sections (same concept, sometimes renamed):**

| Concept | `plan` | `wbs` | `ip` |
|---|---|---|---|
| Goal | `## Goal` | (implicit in hierarchy) | `## Build Goal` |
| Sequencing | `## Order` (flat list, inline lanes) | `## Execution Order` (lightweight list) + `## Deliverable Hierarchy` (tree) | `## Story Queue` (table) + `## Task Lanes` (per-story blocks) |
| Unparented tasks | `## Unparented Tasks` (bullets) | (none — folded into tree) | `## Unparented Tasks` (table) |
| Effort rollup | (none) | `## Effort Rollup` (table) | (none) |
| Critical Path | `## Critical Path` | `## Critical Path` | `## Critical Path` |
| Estimates vs Actuals | `## Estimates vs Actuals` | `## Estimates vs Actuals` | `## Estimates vs Actuals` |
| Risks | `## Risks` | `## Risks & Open Questions` | `## Risks & Open Questions` |
| References | `## References` | `## References` | `## References` |

**Frontmatter identity (per template today):**

- `plan`: `id: plan-{slug}`, `type: plan`, folder `plans/`
- `wbs`: `id: wbs-{slug}`, `type: work-breakdown-structure`, folder `work-breakdown-structures/`
- `ip`: `id: ip-{slug}`, `type: implementation-plan`, folder `implementation-plans/`

---

## Proposed unified `plan` body (fuses `plan` + `ip`)

The IP template carries strictly more information than `plan` (Story Queue table vs flat
list; Task Lanes blocks vs inline; Unparented Tasks table vs bullets; richer column names).
So the unified body leans on IP's structure, with naming normalized to the cleaner forms.

```
---
id: plan-{slug}
type: plan
owner: project-manager
status: draft
version: 1.0
feature: prd-{slug}
refs:
  - prd-{slug}
  - story-{slug}
  - td-{slug}
---

# Plan: {title}

## Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to prd-{slug} Success Metrics. -->

## Story Queue
<!-- Ordered list. Order = priority (P0→P1→P2) then depends-on (story→story DAG).
     This is the normative rollout sequence — the prd-{slug}'s User Stories list is the
     human rollup, this is the executable one. -->

| # | Story | Priority | Depends-on | Est. Hours | Why this position |
|---|---|---|---|---|---|
| 1 | story-{slug} | P0 | — | {N}h | Unblocks story-2's fe-task |
| 2 | story-{slug} | P0 | story-{slug} | {N}h | Needs API from story-1 |
| 3 | story-{slug} | P1 | — | {N}h | Independent, can slip |

## Task Lanes
<!-- Per story: backend/frontend parallelism + cross-task depends-on.
     `→` = sequential; `∥` = parallel; `(blocked by X)` = wait gate. -->

### story-{slug} — {title}
```
be: task-{slug}-be-1 → task-{slug}-be-2
fe: task-{slug}-fe (blocked by be-2)
```

### story-{slug} — {title}
```
be: task-{slug}-be
fe: task-{slug}-fe (parallel with be)
```

## Unparented Tasks
<!-- spike / change / defect / review tasks filed against this brief with no `story:` field.
     Slotted by depends-on + estimated-hours, not by story queue position. -->

| Task | Type | Depends-on | Est. Hours |
|---|---|---|---|
| task-{slug} | spike | — | {N}h |

## Critical Path
<!-- Longest dependency chain across all stories + tasks, with summed hours = total elapsed estimate. -->

story-1.be-2 → story-2.fe → story-3.be — {N}h elapsed

## Estimates vs Actuals
<!-- The coding-agent comparison table. Updated as tasks complete.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster.
     Agent Notes: what the agent did differently than the human plan assumed. -->

| Task | Estimated | Actual | Delta | Agent Notes |
|---|---|---|---|---|
| task-{slug}-be-1 | {N}h | {N}h | {±N}h | agent reused existing util, saved {N}h |
| task-{slug}-be-2 | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Sequencing risks: cross-story task deps, API freeze dates, agent-context limits on long chains. -->

-

## References
- [prd-{slug}](../prds/prd-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
```

### Reconciliation choices (`plan` vs `ip`)

| Section | `plan` had | `ip` had | Unified picks | Rationale |
|---|---|---|---|---|
| Goal | `## Goal` | `## Build Goal` | `## Goal` | "Build" is redundant under `# Plan:` |
| Sequencing | `## Order` (flat list, inline lanes) | `## Story Queue` (table) + `## Task Lanes` (per-story blocks) | `ip`'s split | Table carries priority/depends-on/why explicitly; lanes separate story-DAG from task-DAG |
| Unparented Tasks | bullets | table | `ip`'s table | Table carries Type + Depends-on |
| Estimates vs Actuals cols | `Est./Actual/Δ/Notes` | `Estimated/Actual/Delta/Agent Notes` | `ip`'s cols | Self-documenting column names |
| Risks | `## Risks` | `## Risks & Open Questions` | `ip`/`wbs` name | "Open Questions" is a useful prompt |
| Critical Path, References | same | same | unchanged | — |

**What's dropped from `plan`:** the `## Order` flat-list notation (`→`, `∥`, `[Pn]`
inline). It's superseded by the Story Queue table + Task Lanes blocks, which encode the
same info more explicitly. If you want to preserve the flat-list style as a third variant,
say so — but per your answer, IP and `plan` unify, so the richer form wins.

---

## WBS patch (the only variant)

WBS differs structurally — it's a **deliverable hierarchy**, not a temporal sequence. The
patch swaps the sequencing sections and reframes the Risks comment.

**Sections removed by the patch:**

- `## Story Queue` (table)
- `## Task Lanes` (per-story blocks)

**Sections added by the patch** (inserted where Story Queue + Task Lanes were):

- `## Deliverable Hierarchy` (tree: prd → stories → tasks, with `Σ` rollup marks)
- `## Effort Rollup` (table by priority slice)
- `## Execution Order` (lightweight ordered list referencing tree nodes)

**Sections adjusted by the patch:**

- `## Risks & Open Questions` comment → WBS framing: "Decomposition risks: under-specified
  stories, missing tasks, scope creep nodes."

**Sections unchanged by the patch:**

- `## Goal`, `## Critical Path`, `## Estimates vs Actuals`, `## References`

So the patch is a contiguous body-swap of the sequencing block (Story Queue + Task Lanes →
Deliverable Hierarchy + Effort Rollup + Execution Order) plus a one-line comment edit in
Risks. Everything else stays.

---

## Implications to confirm before implementation

Since you chose **"Collapse to `plan`"** for frontmatter identity, the merge ripples beyond
`templates/`:

1. **`manifest.yaml` `types:` list** — remove the `work-breakdown-structure` and
   `implementation-plan` entries; keep only `plan`. The `plan_type:` field becomes a
   single-value field (or gets renamed `plan_variant:` to reflect that it now selects a
   body shape, not a type). **Open: drop the field, or rename it `plan_variant:`?**

2. **Folders** — `work-breakdown-structures/` and `implementation-plans/` folders and their
   `reference/folder-structure.md` entries go away. Existing artifacts in those folders
   would need migration (rename to `plan-*.md`, move to `plans/`, update `id:`/`type:`).
   The current decision file says "already-created artifacts are not touched — migrate on
   demand." **Keep that policy?**

3. **`decisions/plan-type.md`** — shrinks from 3 alternatives to 2 (`plan` default,
   `work-breakdown-structure` patch). It now **does** touch `templates/plan.md`'s body —
   breaking the old invariant "plan decisions don't touch templates." The `FORMAT.md`
   L1/L2 split (token concretize vs prose dereify) doesn't cleanly describe a body-section
   swap; this becomes a new "L1.5 — body patch" flavor. **Acceptable, or extend
   `FORMAT.md` with a new patch-flavor section?**

4. **Reference docs** — `reference/artifact-vocabulary.md`, `artifact-dep-graph.md`,
   `vault-queries.md`, `folder-structure.md`, and `README.md` all currently list three plan
   types. They'd collapse to one type (`plan`) with WBS described as a "body variant"
   rather than a separate type. The `decisions/plan-type.md` L2 section gets rewritten
   accordingly.

5. **`templates/implementation-plan.md` and `templates/work-breakdown-structure.md`** —
   deleted. Their content lives in the unified `templates/plan.md` (for IP) and in the WBS
   patch section of `decisions/plan-type.md` (for WBS).

---

## Open questions to resolve before implementation

1. **`manifest.yaml` `plan_type:` field** — drop it, or rename to `plan_variant:`?
2. **WBS patch representation in `decisions/plan-type.md`** — carry the full final state of
   the swapped sections inline (consistent with current `FORMAT.md` "full final state for
   complete rewrites"), or reference `templates/plan.md` regions by anchor and say
   "replace the Story Queue + Task Lanes block with the following"? Inline is self-contained
   but duplicates content; anchor-reference is DRY but requires the agent to locate regions
   reliably. Given `FORMAT.md` principle #4 leans toward "full final state for complete
   rewrites," the default would be **inline** — confirm?
3. **Existing artifacts in `work-breakdown-structures/` and `implementation-plans/`** —
   keep the "migrate on demand" policy, or write a one-time migration script?
4. **`FORMAT.md` extension** — accept a new "L1.5 — body patch" flavor, or force the WBS
   patch into the existing L1 (token concretize) framing even though it's a section swap?
