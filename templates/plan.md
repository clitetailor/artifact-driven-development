---
id: plan-{slug}
type: plan
owner: project-manager
status: draft
version: 1.0
feature: {feature-id}
refs:
  - {feature-id}
  - {story-id}
  - {td-id}
---

# Plan: {title}

## Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to {feature-id} Success Metrics. -->

## Deliverable Hierarchy
<!-- Tree: {feature-id} → stories → tasks. Each node carries estimated-hours.
     Children are ordered by priority then depends-on — this IS the execution
     order; read top-to-bottom. Σ marks rolled-up sums.
     This is the structural + temporal source of truth. -->

- {feature-id} ({title}) — Σ {N}h
  - {story-id (P0 story)} — {title} — Σ {N}h [P0]
    - {task-id (be-task)} — {title} — {N}h
    - {task-id (fe-task)} — {title} — {N}h
  - {story-id (P1 story)} — {title} — Σ {N}h [P1]
    - {task-id (be-task)} — {title} — {N}h

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
| 1 | {story-id (story-1)} | P0 | — | {N}h | Unblocks story-2's fe-task |
| 2 | {story-id (story-2)} | P0 | {story-id (story-1)} | {N}h | Needs API from story-1 |
| 3 | {story-id (story-3)} | P1 | — | {N}h | Independent, can slip |
-->

<!-- OPTIONAL: Task Lanes — uncomment when:
     - team has ≥2 parallel roles (e.g. be + fe), OR
     - cross-task dependencies exist across roles within a story
     `→` = sequential; `∥` = parallel; `(blocked by X)` = wait gate.

## Task Lanes

### {story-id (P0 story)} — {title}
be: {task-id (be-task-1)} → {task-id (be-task-2)}
fe: {task-id (fe-task)} (blocked by be-2)

### {story-id (P1 story)} — {title}
be: {task-id (be-task)}
fe: {task-id (fe-task)} (parallel with be)
-->

<!-- OPTIONAL: Unparented Tasks — uncomment when:
     spike / change / defect / review tasks exist against this brief
     with no `story:` field. Slotted by depends-on + estimated-hours.

## Unparented Tasks
| Task | Type | Depends-on | Est. Hours |
|---|---|---|---|
| {task-id} | spike | — | {N}h |
-->

## Critical Path
<!-- Longest dependency chain through the tree, with summed hours = total elapsed estimate. -->

{story-id (root story)} → {task-id (be-task)} → {task-id (fe-task)} — {N}h elapsed

## Estimates vs Actuals
<!-- Filled incrementally as the coding agent completes tasks.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster.
     Agent Notes: what the agent did differently than the human plan assumed. -->

| Task | Estimated | Actual | Delta | Agent Notes |
|---|---|---|---|---|
| {task-id (be-task)} | {N}h | {N}h | {±N}h | |
| {task-id (fe-task)} | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Decomposition risks: under-specified stories, missing tasks, scope creep nodes.
     If Task Lanes present, also: cross-story task deps, API freeze dates,
     agent-context limits on long chains. -->

-

## References
- {feature-link}
- {story-link}
- {td-link}
