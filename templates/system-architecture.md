---
id: sa-{slug}
type: system-architecture
owner: software-architect
status: draft
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
refs:
  - story-{slug}
---

# System Architecture: {title}

## Overview
<!-- What system this describes and the architectural style (monolith, microservices,
     event-driven, etc.). One paragraph. -->

## Context Diagram
<!-- The system as a black box: external actors, upstream/downstream systems,
     and the boundaries. Highest zoom level. -->

## Containers / Services
<!-- The deployable/runnable units that make up the system. -->

| Container | Responsibility | Tech | Communicates with |
|---|---|---|---|
|   |   |   |   |

## Component Breakdown
<!-- Internal building blocks within each container and their boundaries.
     Diagram + short notes. -->

## Data Flow
<!-- How data moves through the system for the primary scenarios.
     Sequence or flow diagram. -->

## Integration Points
<!-- External systems, third-party APIs, message brokers. -->

| Integration | Direction | Protocol | Owned contract |
|---|---|---|---|
|   |   |   | api-{slug} |

## Cross-Cutting Concerns
<!-- Auth, logging, observability, error handling, caching — how they apply
     system-wide rather than per-feature. -->

## Quality Attributes
<!-- How the architecture satisfies key non-functional requirements.
     Quality requirements (qr-) are derived downstream from this view —
     state the architecturally-relevant targets here, don't restate full NFRs. -->

| Attribute | Target | How the architecture addresses it |
|---|---|---|
| scalability |  |  |
| availability |  |  |
| security |  |  |

## Constraints & Assumptions
<!-- Hard constraints (budget, compliance, existing systems) and assumptions
     the architecture depends on. -->

## Related ADRs
<!-- ADRs that elaborate or refine this architecture (created downstream). -->
- [adr-{slug}](../architecture-decisions/adr-{slug}.md)

## Open Questions
- [ ] 

## References
- [story-{slug}](../user-stories/story-{slug}.md)
