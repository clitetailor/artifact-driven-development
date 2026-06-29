---
id: td-{slug}
type: tech-design
owner: software-architect
status: draft
version: 1.0
feature: {feature-id}
refs:
  - adr-{slug}
  - {sa-id}
  - {api-id}
  - {dd-id}
  - {feature-id}
---

# Technical Design: {title}

## Overview
<!-- What this document covers and why it exists. One paragraph. -->

## Scope

### In Scope
- 
- 

### Out of Scope
- 
- 

## Architecture Context
<!-- Scoped "as-was" snapshot of the system-architecture area this feature touches.
     Include only the relevant C4 level (context/container/component) — not the full system.
     This is the baseline the Proposed Changes diff against. If touching multiple levels,
     include a context pair at each relevant level. -->

### Constraining ADRs
- **{adr-link}: {ADR title}** — <!-- How this ADR constrains this design/feature -->

### Architecture Snapshot
```mermaid
%% Use graph with subgraph to express the relevant zoom level (context/container/component).
%% Match the structure used in Proposed Changes so the delta is visually obvious.
graph LR
    %% Insert scoped snapshot of the touched area here
```

## Proposed Changes
<!-- "To-be" architecture: new/modified nodes highlighted vs. the context above.
     Use the same graph structure as Architecture Snapshot so the delta is visually obvious.
     Style: green = new, orange = modified, grey = unchanged. -->
```mermaid
%% Use the same graph structure as Architecture Snapshot
graph TD
    %% Insert proposed architecture with classDef styling (green=new, orange=modified)
```

## Feature Flow
<!-- The feature's control flow: decisions, branches, retries, parallel paths.
     Default to a flowchart (graph TD). Use sequenceDiagram instead only when
     the key point is message ordering across multiple actors/services
     (e.g., cross-service request/response chains, sync/async boundaries). -->
```mermaid
graph TD
    %% Insert feature flowchart here
```

## State Machine (Optional)
<!-- Only when this feature introduces/changes state (e.g., order status, workflow stages).
     Skip otherwise. -->
```mermaid
stateDiagram-v2
    %% Insert state transitions here
```

## Key Decisions
<!-- Implementation-level decisions. Reference constraining ADRs/architectures with their IDs. -->

| Decision | Choice | Reason |
|---|---|---|
|   |   |   |

## Implementation Plan
<!-- Ordered steps or phases. Each step should map 1:1 to a task artifact. -->

### 1. {Step Title} — `task-{slug}`
<!-- Concise summary of files to modify, signatures to add, or schema changes. -->

### 2. {Step Title} — `task-{slug}`

## Operational & System Impact (Optional)
<!-- Document only when non-trivial/applicable to the feature. -->
- **Backward Compatibility & Migrations:** <!-- Does this introduce breaking changes or database backfills? -->
- **Observability & Telemetry:** <!-- Key events tracked, alerting, or metrics. -->
- **Deployment & Rollout:** <!-- Feature flags, gradual rollout, rollback triggers. -->

## Migrations
<!-- Per-feature schema migrations. Frozen post-ship as historical record. -->

### Migration: {migration-name}
**Sequence:** {N}
**Reversible:** yes / no

```sql
-- up
{sql}

-- down
{sql}
```

**Notes:** {anything a future engineer needs to know before running or rolling back}

## Edge Cases & Error Handling
<!-- Known edge cases and how they are handled. -->

## Open Questions
<!-- Unresolved items that must be answered before tasks can start. -->

- [ ] **Question 1:** {question}
  - **Resolution:** {resolution}
  - **Blocks downstream?** yes | no

## References
- **{sa-link}** (System Architecture)
- **{api-link}** (API Specification)
- **{dd-link}** (Data Design)
- **{feature-link}** (Feature Brief)
