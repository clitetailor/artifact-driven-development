---
id: sa-{slug}
type: system-architecture
owner: software-architect
status: draft
version: 1.0
feature-brief: {fb-slug}
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

## Data Flow Overview
<!-- High-level: which services talk to which, integration points.
     Detailed data flows (state machines, pipelines, transformations) belong in data-design. -->

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

## Architecture Decision Records
<!-- ADRs absorbed as subsections. Each with context/decision/consequences. -->

### ADR: {title}

**Status:** proposed | accepted | deprecated | superseded

**Context:**
<!-- The problem or constraint that forced a decision. -->

**Decision:**
<!-- The choice made. One clear sentence, then elaboration. -->

**Consequences:**
- Positive: 
- Negative / Trade-offs: 

---

## Constraints & Assumptions
<!-- Hard constraints (budget, compliance, existing systems) and assumptions
     the architecture depends on. -->

## Related Artifacts
<!-- Downstream artifacts that elaborate or refine this architecture. -->
- Data design: [dd-{slug}](../data-designs/dd-{slug}.md)
- API spec: [api-{slug}](../api-specs/api-{slug}.md)

## Open Questions
- [ ] 

## References
- [story-{slug}](../user-stories/story-{slug}.md)
