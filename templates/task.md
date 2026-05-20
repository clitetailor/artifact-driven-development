---
id: task-{slug}-{be|fe}
type: task
owner: {software-architect | frontend-engineer}
status: open
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
track: {backend | frontend}
priority: {tier-number}
scenario: req-{slug}#scenario-{N}
milestone: sprint-{N}
estimated-hours: {N}
depends-on:
  - task-{slug}-{be|fe}
hard-deps:
soft-deps:
  - api-{slug}
  - dm-{slug}
  - adr-{slug}
refs:
  - api-{slug}
  - dm-{slug}
  - adr-{slug}
  - req-{slug}
---

# Task: {title}

## Scope

### Included
- 
- 

### Excluded
<!-- Explicitly state what is NOT part of this task to prevent scope creep. -->
- 

## Acceptance Criteria
<!-- Testable conditions. Each must be unambiguously pass/fail. -->

- [ ] 
- [ ] 

## Relevant Specs
<!-- Direct links to the specific sections of contracts / specs this task implements. -->

- api-{slug} → `{endpoint or section}`
- dm-{slug} → `{table or section}`
- req-{slug} → Scenario {N}: {scenario-title}

---

## Implementation Notes
<!-- Filled by the implementing agent on task completion. Leave blank until done. -->

### Approach Taken

### Deviations from Spec

### Known Gaps
<!-- Deferred items. File a CR if a gap requires upstream artifact changes. -->

### Safe to Modify
<!-- What a future engineer should know before changing this. -->
