---
id: sa-{slug}
type: system-architecture
owner: software-architect
status: draft
version: 1.0
feature: {prd-id}
refs:
  - {prd-id}
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

## Data Flow Overview
<!-- High-level: which services talk to which, integration points.
     Detailed data flows (state machines, pipelines, transformations) belong in data-design. -->

## Integration Points
<!-- External systems, third-party APIs, message brokers. -->

| Integration | Direction | Protocol | Owned contract |
|---|---|---|---|
|   |   |   | {api-id} |

## Cross-Cutting Concerns
<!-- Auth, logging, observability, error handling, caching — how they apply
     system-wide rather than per-feature. -->

## Quality Attributes
<!-- How the architecture satisfies key non-functional requirements.
     State the architecturally-relevant targets here, don't restate full NFRs. -->

| Attribute | Target | How the architecture addresses it |
|---|---|---|
| scalability |  |  |
| availability |  |  |
| security |  |  |

## Architectural Decisions
<!-- Links to accepted ADR artifacts that shaped this architecture.
     Each ADR is a standalone artifact (adr-{slug}.md) — do not embed decisions here.
     When a new decision is accepted, add it to this list and update the sections above to reflect the outcome. -->

| ADR | Decision Summary | Status |
|---|---|---|
| {adr-link} |  | accepted |

## Constraints & Assumptions
<!-- Hard constraints (budget, compliance, existing systems) and assumptions
     the architecture depends on. -->

## Related Artifacts
<!-- Downstream artifacts that elaborate or refine this architecture. -->
- ADRs: {adr-link}
- Data design: {dd-link}
- API spec: {api-link}

## Open Questions
- [ ] 

## References
- {prd-link}
