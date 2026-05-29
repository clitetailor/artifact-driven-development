---
id: uf-{slug}
type: user-flow
owner: ux-ui-designer
status: draft
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
refs:
  - req-{slug}
  - persona-{slug}
---

# User Flow: {title}

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
