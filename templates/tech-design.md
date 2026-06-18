---
id: td-{slug}
type: tech-design
owner: software-architect
status: draft
version: 1.0
feature: {root-id}
refs:
  - sa-{slug}
  - api-{slug}
  - dd-{slug}
  - {root-id}
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
| [adr-{slug}](../adrs/adr-{slug}.md): {ADR title} | {how it constrains this feature} |

## Key Decisions
<!-- Implementation-level decisions (not architecture-level — those live in system-architecture).
     Feature-scoped decisions only. System-wide decisions belong in system-architecture ADRs. -->

| Decision | Choice | Reason | Constrained by |
|---|---|---|---|
|   |   |   | sa-{slug} |

## Observability & Instrumentation
<!-- How are we tracking the Success Metrics defined in the Feature Brief? What logs/events are we emitting? -->
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

## References
- [sa-{slug}](../system-architectures/sa-{slug}.md)
- [api-{slug}](../api-specs/api-{slug}.md)
- [dd-{slug}](../data-designs/dd-{slug}.md)
- [{root-id}](../{root-folder}/{root-id}.md)
