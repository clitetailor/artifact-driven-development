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

## Deliverable Hierarchy
<!-- Tree: prd-{slug} → stories → tasks. Each node carries estimated-hours.
     Children are ordered by priority then depends-on — this IS the execution
     order; read top-to-bottom. Σ marks rolled-up sums.
     This is the structural + temporal source of truth. -->

- prd-{slug} ({title}) — Σ {N}h
  - story-{slug} — {title} — Σ {N}h [P0]
    - task-{slug}-be — {title} — {N}h
    - task-{slug}-fe — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P1]
    - task-{slug}-be — {title} — {N}h

<!-- OPTIONAL: Effort Rollup — uncomment when:
     - stakeholder reporting needs a sizing summary, OR
     - ≥3 priority slices with significant effort
     Derived from the hierarchy's Σ marks — not independent data.

## Effort Rollup
| Slice | Stories | Tasks | Estimated Hours |
|---|---|---|---|
| P0 (launch blocker) | {N} | {N} | {N}h |
| P1 (important) | {N} | {N} | {N}h |
| P2 (nice to have) | {N} | {N} | {N}h |
| **Total** | | | **{N}h** |
-->

<!-- OPTIONAL: Sequencing Rationale — uncomment when:
     - ≥3 stories with cross-dependencies, OR
     - priority contention needs explicit "why this position" reasoning
     The hierarchy already provides the ordering; this section adds the WHY.

## Sequencing Rationale
| # | Story | Priority | Depends-on | Est. Hours | Why this position |
|---|---|---|---|---|---|
| 1 | story-{slug} | P0 | — | {N}h | Unblocks story-2's fe-task |
| 2 | story-{slug} | P0 | story-{slug} | {N}h | Needs API from story-1 |
| 3 | story-{slug} | P1 | — | {N}h | Independent, can slip |
-->

<!-- OPTIONAL: Task Lanes — uncomment when:
     - team has ≥2 parallel roles (e.g. be + fe), OR
     - cross-task dependencies exist across roles within a story
     `→` = sequential; `∥` = parallel; `(blocked by X)` = wait gate.

## Task Lanes

### story-{slug} — {title}
be: task-{slug}-be-1 → task-{slug}-be-2
fe: task-{slug}-fe (blocked by be-2)

### story-{slug} — {title}
be: task-{slug}-be
fe: task-{slug}-fe (parallel with be)
-->

<!-- OPTIONAL: Unparented Tasks — uncomment when:
     spike / change / defect / review tasks exist against this brief
     with no `story:` field. Slotted by depends-on + estimated-hours.

## Unparented Tasks
| Task | Type | Depends-on | Est. Hours |
|---|---|---|---|
| task-{slug} | spike | — | {N}h |
-->

## Critical Path
<!-- Longest dependency chain through the tree, with summed hours = total elapsed estimate. -->

story-{slug} → task-{slug}-be → task-{slug}-fe — {N}h elapsed

## Estimates vs Actuals
<!-- Filled incrementally as the coding agent completes tasks.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster.
     Agent Notes: what the agent did differently than the human plan assumed. -->

| Task | Estimated | Actual | Delta | Agent Notes |
|---|---|---|---|---|
| task-{slug}-be | {N}h | {N}h | {±N}h | |
| task-{slug}-fe | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Decomposition risks: under-specified stories, missing tasks, scope creep nodes.
     If Task Lanes present, also: cross-story task deps, API freeze dates,
     agent-context limits on long chains. -->

-

## References
- [prd-{slug}](../prds/prd-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
