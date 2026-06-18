---
id: wbs-{slug}
type: work-breakdown-structure
owner: project-manager
status: draft
version: 1.0
feature-brief: fb-{slug}
refs:
  - fb-{slug}
  - story-{slug}
  - td-{slug}
---

# Work Breakdown Structure: {title}

## Deliverable Hierarchy
<!-- Tree: feature-brief → stories → tasks. Each node carries estimated-hours.
     Order children by priority then depends-on. Σ marks rolled-up sums. -->

- fb-{slug} ({title}) — Σ {N}h
  - story-{slug} — {title} — Σ {N}h [P0]
    - task-{slug}-be — {title} — {N}h
    - task-{slug}-fe — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P1]
    - task-{slug}-be — {title} — {N}h

## Effort Rollup
<!-- Sum by slice. The PMI reason for a WBS — answer "how big is this?" at a glance. -->

| Slice | Stories | Tasks | Estimated Hours |
|---|---|---|---|
| P0 (launch blocker) | {N} | {N} | {N}h |
| P1 (important) | {N} | {N} | {N}h |
| P2 (nice to have) | {N} | {N} | {N}h |
| **Total** | | | **{N}h** |

## Execution Order
<!-- Lightweight — WBS is structural, not temporal. One ordered list referencing the tree nodes. -->

1. story-{slug} (P0, no deps)
2. story-{slug} (P0, depends-on story-{slug})
3. story-{slug} (P1)

## Critical Path
<!-- Longest dependency chain through the tree, with summed hours = total elapsed estimate. -->

story-{slug} → task-{slug}-be → task-{slug}-fe — {N}h elapsed

## Estimates vs Actuals
<!-- Filled incrementally as the coding agent completes tasks.
     Purpose: compare agent actuals against human estimates to surface optimization patterns. -->

| Task | Estimated | Actual | Delta | Notes |
|---|---|---|---|---|
| task-{slug}-be | {N}h | {N}h | {±N}h | |
| task-{slug}-fe | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Decomposition risks: under-specified stories, missing tasks, scope creep nodes. -->

- 

## References
- [fb-{slug}](../feature-briefs/fb-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
