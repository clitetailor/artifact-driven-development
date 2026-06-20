---
id: story-{slug}
type: user-story
owner: business-analyst
status: open | in-progress | done
version: 1.0
feature: prd-{slug}
priority: {P0 | P1 | P2}
estimated-hours: {N}  # provisional — set by BA without technical context; refined later by plan
depends-on:
  - story-{slug}
refs:
  - prd-{slug}
---

# User Story: {title}

## Narrative

As a **{persona or role}**,
I want to **{action or capability}**,
so that **{outcome or value}**.

## Preconditions
- 
- 

## Acceptance Criteria

- [ ] Given {context}, when {action}, then {outcome}
- [ ] Given {context}, when {action}, then {outcome}

## Error / Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
|          |                   |

## Notes
<!-- Orchestration hints: effort breakdown, cross-story dependencies, timeline constraints. -->

- **Priority:** P0 (launch blocker) | P1 (important) | P2 (nice to have)
- **Effort:** {N} tasks (~{N} hours)
- **Dependencies:** None | story-{slug}
- **Timeline:** Sprint {N} | Phase {N}

## References
- [prd-{slug}](../prds/prd-{slug}.md)
