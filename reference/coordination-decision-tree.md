# Coordination Decision Tree
> When to create user-stories or tasks and how to structure work.

---

## Decision Matrix

| Situation | Create | Skip |
|---|---|---|
| New user-facing capability | `user-story` | — |
| Technical chore or infrastructure work | `task` | — |
| Modify existing spec artifacts | `task` (change type) | — |
| Fix inconsistency or error in specs | `task` (defect type) | — |
| Research before committing to changes | Add investigation notes to `prd` | — |
| Time-boxed exploration | `task` with spike label | — |
| Simple change owner can apply directly | — | Direct edit, no new artifact needed |
| Re-verify accepted artifacts after upstream shift | Create review `task` | — |

---

## Work Types

### `user-story`
New user-facing capability. Derived from PRD. Format: "As a [role], I want [goal], so that [benefit]". Includes Given/When/Then acceptance criteria and an execution checklist for sub-tasks.

### `task`
Agent-sized implementation unit. Types:
- **feature**: Building new capability
- **change**: Modifying existing artifacts  
- **defect**: Fixing errors or inconsistencies
- **spike**: Time-boxed exploration
- **review**: Re-verification after upstream changes

---

## User-Story–Task Relationship

- **User Story** = product value (what the user gets, acceptance criteria, sub-task checklist)
- **Task** = technical implementation (how to build it, acceptance criteria, implementation notes)
- Both link to `prd` as the Epic-level grouping
- `task` frontmatter includes `story: story-{slug}` when derived from a user story
- Granular execution steps (sub-tasks) live as checklists inside the parent artifact

---

## Task Frontmatter

```yaml
---
id: task-{slug}
type: task
owner: {agent-slug}
status: open | in-progress | done
version: 1.0
feature: prd-{slug}
tech-design: td-{slug}
story: story-{slug}  # optional, if derived from user story
priority: {tier-number}
estimated-hours: {N}
depends-on:
  - task-{slug}
refs:
  - api-{slug}
---
```

---

## Execution Pattern

```
PRD (Epic level — what and why)
  ↓
Tech Design (how — architectural context)
  ↓
User Stories (user value) ─────┐
  ↓                              │
Tasks (implementation) ←─────────┘
  ↓
Execution Checklist (sub-tasks inside task/story)
```

Work is filed as tasks or user-stories at any time. Sub-tasks are tracked via Markdown checklists, not separate artifacts.
