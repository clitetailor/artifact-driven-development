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

## Architectural Context
- **{adr-link}: {ADR title}** — <!-- How this ADR constrains this design/feature -->

## Architecture & Flow
<!-- Diagrams (such as mermaid), component boundaries, or data flow descriptions. -->

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
