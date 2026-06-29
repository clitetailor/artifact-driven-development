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

### In Scope
- 
- 

### Out of Scope
<!-- Explicitly state what is NOT part of this task to prevent scope creep. -->
- 

## Context
<!-- 2-4 lines: where this task sits in the system (module, seam, boundary). Defer design detail to the linked tech-design. -->

### Flow/Structure Diagram (Optional)
<!-- Only for tasks with non-trivial sequencing (state machines, multi-service calls). Skip for simple tasks. -->
```mermaid
graph TD
    %% Insert task-specific diagram here
```

## Acceptance Criteria
<!-- Pass/fail acceptance criteria -->

- [ ] 
- [ ] 

## Execution Checklist (Sub-Tasks)
<!-- Agents: Check off these items as work is completed. -->

- [ ] {sub-task 1}
- [ ] {sub-task 2}
- [ ] {sub-task 3}

## Structural Changes
<!-- Physical blueprint of the changes: files, signatures, contracts. Doubles as a hand-off contract for reviewers and downstream tasks. -->

| Target File | Component / Class / Function | Type of Change (Add/Modify/Delete) | Signatures / Contract / Schema Changes |
|---|---|---|---|
| `app/path/to/file.py` | `MyClass.my_function()` | Add | `def my_function(self, doc_id: str) -> dict:` |

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

### Verification Notes
<!-- Task-specific verification quirks only (e.g., "restart worker before running tests"). Full verification lives in test-spec / test-plan. -->

### Safe to Modify
<!-- What a future engineer should know before changing this. -->

## References
- {api-link}
- {dd-link}
- {sa-link}
- {story-link}
- {ts-link}
