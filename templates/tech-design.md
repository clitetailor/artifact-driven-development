---
id: td-{slug}
type: tech-design
owner: software-architect
status: draft
version: 1.0
feature: {feature-id}
refs:
  - {sa-id}
  - {api-id}
  - {dd-id}
  - {feature-id}
---

# Technical Design: {title}

## Overview
<!-- Overview of the document -->

## Scope
<!-- In and out of scope -->

## Architectural Context
<!-- Relevant ADRs or architectural constraints -->

- **{adr-link}: {ADR title}**
  - **Impact:** {how it constrains this feature}

## Architecture & Flow
<!-- Architectural diagrams or flow descriptions -->

## Key Decisions
<!-- Feature-scoped implementation decisions -->

- **Decision 1:**
  - **Choice:** {choice}
  - **Reason:** {reason}
  - **Constrained by:** {sa-id}

## Observability & Instrumentation
<!-- Telemetry and metrics tracking -->
- **Events:** `event_name` (Properties: `prop1`, `prop2`)
- **Monitors/Alerts:** {What should page us if this feature breaks?}

## Deployment & Rollout Strategy
<!-- Rollout and feature flags -->
- **Feature Flag:** `flag-name` (default: false)
- **Rollout Plan:** {e.g., Enable for internal users -> 10% -> 100%}
- **Rollback Plan:** {How do we revert if it causes an incident?}

## Implementation Plan
<!-- Step-by-step task breakdown -->

### 1. {Step Title} — `task-{slug}`
- **Prerequisites:** {None, or dependent step/task IDs}
- **Inputs:** {Trigger conditions, inputs, configuration, or raw data shapes}
- **Outputs:** {Expected output, changes, DB state changes, or returned values}
- **Details:** {Specific classes, functions, or configurations to touch}

### 2. {Step Title} — `task-{slug}`
- **Prerequisites:**
- **Inputs:**
- **Outputs:**
- **Details:**

## Cross-Feature & System Impact
<!-- System-wide impact -->
- **Backward Compatibility:** {Does this introduce breaking changes to existing APIs, events, database schemas, or configurations?}
- **Downstream/Cross-Feature Effects:** {Which existing features, frontend views, event consumers, or offline jobs are impacted by these changes?}
- **Performance & Resource Impact:** {Any expected changes to database query load, API latency, memory/CPU footprint, or storage?}
- **Migration & Backfill Dependencies:** {Are there dependencies on existing data migration timelines or asynchronous backfills?}

## Edge Cases & Error Handling
<!-- Edge cases -->

## Open Questions
<!-- Unresolved blockers -->
- [ ] **Question 1:** {question}
  - **Status:** open | resolved
  - **Resolution:** {resolution}

## References
- {sa-link}
- {api-link}
- {dd-link}
- {feature-link}
