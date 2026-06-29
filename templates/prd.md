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
<!-- Market context and motivation -->

## Problem Statement
<!-- User friction or business need -->

## Objectives & Goals
<!-- Target outcomes -->

- **Goal 1:** {goal}
  - **Success Signal:** {signal}
  - **Target:** {target}

## Target Audience
<!-- Target personas -->

- **Persona 1:** {persona}
  - **Context:** {context}

## Success Metrics
<!-- Key success metrics -->

| Metric | Type | Target | Source |
|--------|------|--------|--------|
|        | primary \| guardrail |        |        |

## Scope

### In Scope
- 

### Out of Scope
<!-- Excluded scope -->
- 

## Functional Requirements
<!-- Core capabilities -->

1. 
2. 

## Non-Functional Requirements
<!-- System constraints (Perf, Security, etc.) -->

- **Performance:** {req}
- **Reliability:** {req}
- **Security & Compliance:** {req}
- **Accessibility:** {req}

## Dependencies & Risks
<!-- External dependencies and risks -->

- **Dependency:** {what we depend on}
- **Risk:** {risk} — **Mitigation:** {mitigation}

## User Stories
<!-- Mapped user stories -->

| Key Req | Story | Summary |
|---------|-------|---------|
| FR-1 | {story-id} | {one-line summary} |
| FR-2 | {story-id (first story)}, {story-id (second story)} | {one-line summary} |

## Open Questions

| # | Question | Status | Resolution | Blocks downstream? |
|---|----------|--------|------------|---------------------|
| 1 |          | open \| resolved |        | yes \| no           |

## Pipeline Next Steps
<!-- What the downstream pipeline expects to build from this root. -->
- [ ] Extract user-stories from Functional Requirements
- [ ] product-designer → user-flow (from this root)
- [ ] software-architect → system-architecture (from this root)

## References
- [{related-artifact-id}](../{folder}/{related-artifact-id}.md)
