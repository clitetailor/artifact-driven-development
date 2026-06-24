---
id: task-{slug}-{be|fe}
type: task
owner: {software-architect | frontend-engineer}
status: open
version: 1.0
feature: {feature-id}
tech-design: {td-id}
track: {backend | frontend}
priority: {tier-number}
story: {story-id}
milestone: sprint-{N}
estimated-hours: {N}
depends-on:
  - {task-id}
refs:
  - {api-id}
  - {dd-id}
  - {sa-id}
  - {story-id}
  - {ts-id}
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
<!-- Pass/fail acceptance criteria -->

- [ ] 
- [ ] 

## Execution Checklist (Sub-Tasks)
<!-- Agents: Check off these items as work is completed. -->

- [ ] {sub-task 1}
- [ ] {sub-task 2}
- [ ] {sub-task 3}

## Relevant Specs
<!-- Direct links to the specific sections of contracts / specs this task implements. -->

- {api-id} → `{endpoint or section}`
- {dd-id} → `{entity or section}`
- {story-id} → {story-title}

---

## Implementation Notes
<!-- Filled by the implementing agent on task completion. Leave blank until done. -->

### Approach Taken

### Deviations from Spec

### Known Gaps
<!-- Deferred items. File a CR if a gap requires upstream artifact changes. -->

### Safe to Modify
<!-- What a future engineer should know before changing this. -->

## References
- {api-link}
- {dd-link}
- {sa-link}
- {story-link}
- {ts-link}
