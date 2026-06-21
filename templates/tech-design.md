---
id: td-{slug}
type: tech-design
owner: software-architect
status: draft
version: 1.0
feature: {prd-id}
refs:
  - {sa-id}
  - {api-id}
  - {dd-id}
  - {prd-id}
---

# Technical Design: {title}

## Overview
<!-- What this document covers and why it exists. One paragraph. -->

## Scope
<!-- What is and is not covered by this design. -->

## Architectural Context
<!-- References to ADR artifacts that constrain this feature.
     No new architecture here — system-architecture and adr own that.
     If this feature requires a new system-wide decision, author an adr-{slug}.md first,
     get it accepted, then reference it here. -->

| ADR | Impact on This Feature |
|---|---|
| {adr-link}: {ADR title} | {how it constrains this feature} |

## Key Decisions
<!-- Implementation-level decisions (not architecture-level — those live in system-architecture).
     Feature-scoped decisions only. System-wide decisions belong in system-architecture ADRs. -->

| Decision | Choice | Reason | Constrained by |
|---|---|---|---|
|   |   |   | {sa-id} |

## Observability & Instrumentation
<!-- How are we tracking the Success Metrics defined in the PRD? What logs/events are we emitting? -->
- **Events:** `event_name` (Properties: `prop1`, `prop2`)
- **Monitors/Alerts:** {What should page us if this feature breaks?}

## Deployment & Rollout Strategy
<!-- Feature flags, environment variables, dark launches, and migration steps. -->
- **Feature Flag:** `flag-name` (default: false)
- **Rollout Plan:** {e.g., Enable for internal users -> 10% -> 100%}
- **Rollback Plan:** {How do we revert if it causes an incident?}

## Implementation Plan
<!-- Ordered steps or phases. Each step should map 1:1 to a task artifact. -->

1. 
2. 

## Edge Cases & Error Handling
<!-- Known edge cases and how they are handled. -->

## Open Questions
<!-- Unresolved items that must be answered before tasks can start. -->
- [ ] 

## Definition of Done
<!-- The software-architect agent checks these before flipping status to ready-for-review. -->
- [ ] Architectural Context references accepted ADRs only
- [ ] Key Decisions are feature-scoped (system-wide decisions belong in ADRs)
- [ ] Implementation Plan steps map 1:1 to task artifacts
- [ ] Affected user-stories flagged as needs-review if acceptance criteria or inter-story dependencies must change

## References
- {sa-link}
- {api-link}
- {dd-link}
- {prd-link}
