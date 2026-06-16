---
id: task-{slug}-{be|fe}
type: task
owner: {software-architect | frontend-engineer}
status: open
version: 1.0
feature-brief: {fb-slug}
tech-design: td-{slug}
track: {backend | frontend}
priority: {tier-number}
story: story-{slug}
milestone: sprint-{N}
estimated-hours: {N}
depends-on:
  - task-{slug}-{be|fe}
refs:
  - api-{slug}
  - dd-{slug}
  - sa-{slug}
  - story-{slug}
  - ts-{slug}
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

## Execution Checklist (Sub-Tasks)
<!-- Agents: Check off these items as work is completed. -->

- [ ] {sub-task 1}
- [ ] {sub-task 2}
- [ ] {sub-task 3}

## Relevant Specs
<!-- Direct links to the specific sections of contracts / specs this task implements. -->

- api-{slug} → `{endpoint or section}`
- dd-{slug} → `{entity or section}`
- story-{slug} → {story-title}

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
- [api-{slug}](../api-specs/api-{slug}.md)
- [dd-{slug}](../data-designs/dd-{slug}.md)
- [sa-{slug}](../system-architectures/sa-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [ts-{slug}](../test-specs/ts-{slug}.md)
