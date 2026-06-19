---
id: uf-{slug}
type: user-flow
owner: product-designer
status: draft
version: 1.0
feature: prd-{slug}
refs:
  - prd-{slug}
  - persona-{slug}
---

# User Flow: {title}

## Journey Overview
<!-- From user-journey-map: stages, emotions, pain points. High-level narrative of the end-to-end experience. -->

| Stage | User Action | Touchpoint | Emotion | Pain Point | Opportunity |
|-------|-------------|------------|---------|------------|-------------|
|       |             |            |         |            |             |

## Entry Points
<!-- Where the user can arrive at this flow from. -->

- 
- 

## Happy Path

```mermaid
flowchart TD
    A([Start]) --> B[{step}]
    B --> C{Decision?}
    C -- Yes --> D[{step}]
    C -- No --> E[{step}]
    D --> F([End])
    E --> F
```

## Error Paths

```mermaid
flowchart TD
    A[{trigger}] --> B{Error condition?}
    B -- Yes --> C[Show error state]
    C --> D[Recovery action]
    D --> E([Return to flow])
    B -- No --> F([Continue happy path])
```

## Exit Points
<!-- All the ways a user can leave this flow — success, abandon, error. -->

| Exit | Condition | Next State |
|------|-----------|------------|
|      |           |            |

## Screens in This Flow
<!-- One row per screen. Each should map to a wireframe. -->

| Screen | ID | Description |
|--------|----|-------------|
|        |    |             |

## Edge Cases
<!-- Scenarios outside the happy path that the flow must handle. -->

- 

## References
- [prd-{slug}](../prds/prd-{slug}.md)
- [persona-{slug}](../user-journey-maps/ujm-{slug}.md)
