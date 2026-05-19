---
id: tb-{slug}
type: task-breakdown
owner: orchestrator
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
hard-deps:
soft-deps:
  - cr-{slug}
refs:
  - cr-{slug}
---

# Task Breakdown: {title}

## Source Change Request
<!-- The CR that triggered this breakdown. Must be status: applied before this can be accepted. -->
cr-{slug}

## Context
<!-- Why new tasks are needed. What the CR changed that requires additional implementation work. -->

---

## Backend Tasks

| ID | Title | Priority | Depends On |
|----|-------|----------|------------|
|    |       |          |            |

## Frontend Tasks

| ID | Title | Priority | Depends On |
|----|-------|----------|------------|
|    |       |          |            |

---

## Dependency Order

```
Tier 1 (no deps):
  - task-{slug}-be
  - task-{slug}-fe

Tier 2 (depends on tier 1):
  - task-{slug}-be
```

## Notes
<!-- Anything the implementing agents need before starting. -->
