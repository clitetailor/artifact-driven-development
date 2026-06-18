---
id: plan-{slug}
type: plan
owner: project-manager
status: draft
version: 1.0
feature-brief: fb-{slug}
refs:
  - fb-{slug}
  - story-{slug}
  - td-{slug}
---

# Plan: {title}

## Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to fb-{slug} Success Metrics. -->

## Order
<!-- Flat ordered list — single sequence collapsing stories and their tasks.
     Notation: `→` sequential, `∥` parallel, `(blocked by X)` wait gate, `[Pn]` priority.
     Order = priority then depends-on. Lanes and deps inline; no separate task-lanes section. -->

1. story-{slug} [P0] — {N}h
   - task-{slug}-be → task-{slug}-fe (blocked by be)
2. story-{slug} [P0, depends-on story-{slug}] — {N}h
   - task-{slug}-be ∥ task-{slug}-fe (parallel)
3. story-{slug} [P1] — {N}h
   - task-{slug}-be

## Unparented Tasks
<!-- spike / change / defect / review tasks against this brief with no `story:` field. -->

- task-{slug} (spike) — {N}h

## Critical Path
<!-- Longest chain + summed hours = total elapsed estimate. -->

story-1.be → story-2.fe — {N}h elapsed

## Estimates vs Actuals
<!-- Coding-agent comparison. Updated as tasks complete.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster. -->

| Task | Est. | Actual | Δ | Notes |
|---|---|---|---|---|
| task-{slug}-be | {N}h | {N}h | {±N}h | |
| task-{slug}-fe | {N}h | — | — | in-progress |

## Risks
- 

## References
- [fb-{slug}](../feature-briefs/fb-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
