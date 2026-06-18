---
id: ip-{slug}
type: implementation-plan
owner: project-manager
status: draft
version: 1.0
feature-brief: fb-{slug}
refs:
  - fb-{slug}
  - story-{slug}
  - td-{slug}
---

# Implementation Plan: {title}

## Build Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to fb-{slug} Success Metrics. -->

## Story Queue
<!-- Ordered list. Order = priority (P0→P1→P2) then depends-on (story→story DAG).
     This is the normative rollout sequence — the feature-brief's User Stories list is the human rollup, this is the executable one. -->

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
- [fb-{slug}](../feature-briefs/fb-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
