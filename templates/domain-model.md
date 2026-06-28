---
id: dm-{domain}
type: domain-model
owner: software-architect
contributor: business-analyst
status: draft
version: 1.0
domain: {domain-slug}
refs: []
---

# Domain Model: {Domain Name}

## Ubiquitous Language
<!-- Exact terms used in this domain. No synonyms. Both business and engineering must agree. -->

| Term | Definition |
|------|------------|
|      |            |

## Core Entities
<!-- Things with identity and lifecycle. Include allowed state transitions. -->

### `{EntityName}`
**Identity:** {what makes it unique}
**Lifecycle states:** {state1} → {state2} → {state3}
**Allowed transitions:**

| From | Event | To | Guard |
|------|-------|----|-------|
|      |       |    |       |

## Value Objects
<!-- Defined entirely by their attributes. No identity. Immutable. -->

### `{ValueObjectName}`
**Attributes:** {attr1}, {attr2}
**Invariants:** {rules that must hold}

## Business Rules & Invariants
<!-- Unbreakable laws. Written in Ubiquitous Language. Owned by business-analyst. -->
- 

## Domain Events
<!-- Significant happenings that other domains or systems may react to. -->

| Event | Trigger | Payload |
|-------|---------|---------|
|       |         |         |

## Open Questions
- [ ] 

## References
- 
