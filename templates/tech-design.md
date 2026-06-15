---
id: td-{slug}
type: tech-design
owner: software-architect
status: draft
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
refs:
  - sa-{slug}
  - api-{slug}
  - dd-{slug}
  - prd-{charter}-{descriptor}
---

# Technical Design: {title}

## Overview
<!-- What this document covers and why it exists. One paragraph. -->

## Scope
<!-- What is and is not covered by this design. -->

## Architectural Context
<!-- References to system-architecture decisions that constrain this feature.
     No new architecture here — system-architecture owns that. -->

| System Architecture Decision | Impact on This Feature |
|---|---|
| sa-{slug}: {ADR title} | {how it constrains this feature} |

## Key Decisions
<!-- Implementation-level decisions (not architecture-level — those live in system-architecture).
     Feature-scoped decisions only. System-wide decisions belong in system-architecture ADRs. -->

| Decision | Choice | Reason | Constrained by |
|---|---|---|---|
|   |   |   | sa-{slug} |

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
- [prd-{charter}-{descriptor}](../prds/prd-{charter}-{descriptor}.md)
