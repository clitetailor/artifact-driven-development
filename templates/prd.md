---
id: prd-{slug}
type: prd
owner: business-analyst
status: draft
version: 1.0
children: []
refs:
  - {related-artifact-id}
---

# PRD: {title}

## Background
<!-- Why now? Market context, customer signals, strategic alignment, or prior art that motivates this product investment. -->

## Problem Statement
<!-- The specific user friction or business need this product addresses. Frame from the customer's perspective. -->

## Objectives & Goals
<!-- What outcomes this product must achieve. Tie each to a measurable signal. -->

| Goal | Success Signal | Target |
|------|----------------|--------|
|      |                |        |

## Target Audience
<!-- Who this is for. Personas, segments, or specific customer cohorts. -->

| Persona | Segment / Context |
|---------|-------------------|
|        |                   |

## Success Metrics
<!-- How we know the product is successful post-launch. Distinguish primary from guardrail metrics. -->

| Metric | Type | Target | Measurement Source |
|--------|------|--------|--------------------|
|        | primary \| guardrail |        |                    |

## Scope

### In Scope
- 

### Out of Scope
<!-- Explicitly excluded to prevent scope creep. -->
- 

## Functional Requirements
<!-- Plain-English capabilities the product must have. Number for traceability. -->

1. 
2. 

## Non-Functional Requirements
<!-- Performance, reliability, security, compliance, accessibility, scalability constraints. -->

| Category | Requirement |
|----------|-------------|
| Performance |  |
| Reliability |  |
| Security & Compliance |  |
| Accessibility |  |

## Dependencies & Risks
<!-- Cross-team dependencies, external APIs, regulatory approvals, and key business/technical risks. -->

- **Dependencies:** 
- **Risks & Mitigations:** 

## User Stories
<!-- Stories extracted from this root. Maps functional requirements to spawned stories
     for coverage verification — every requirement should have at least one story. -->

| Requirement | Story | Summary |
|-------------|-------|---------|
| FR-1 | story-{slug} | {one-line summary} |
| FR-2 | story-{slug}, story-{slug} | {one-line summary} |

## Open Questions

| # | Question | Status | Resolution | Blocks downstream? |
|---|----------|--------|------------|---------------------|
| 1 |          | open \| resolved |        | yes \| no           |

## Pipeline Next Steps
<!-- What the downstream pipeline expects to build from this root. -->
- [ ] Extract user-stories from Functional Requirements
- [ ] product-designer → user-flow (from this root)
- [ ] software-architect → system-architecture (from this root)

## Definition of Done
<!-- The business-analyst agent checks these before flipping status to ready-for-review. -->
- [ ] Problem Statement frames pain from customer perspective
- [ ] ≥1 Objective with measurable Success Signal + Target
- [ ] Scope (In/Out) explicitly bounded
- [ ] ≥1 Functional Requirement numbered
- [ ] Open Questions reviewed; blockers flagged
- [ ] User Stories section populated (or explicitly "none yet — deferred")

## References
- [{related-artifact-id}](../{folder}/{related-artifact-id}.md)
