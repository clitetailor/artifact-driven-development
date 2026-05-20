# Coordination Artifact Decision Tree
> Quick reference for when to create scenarios, CRs, task-breakdowns, and milestones

---

## Decision Flow

```
┌─────────────────────────────────────────────────────────┐
│  What are you trying to coordinate?                     │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
   User Value      Artifact Change    Sprint Timeline
   Definition      Request            Tracking
        │                 │                 │
        ▼                 ▼                 ▼
   SCENARIOS          CHANGE            MILESTONE
   (required)         REQUEST           (optional)
                      (when needed)
                          │
                          ▼
                  Does CR need
                  implementation?
                          │
                    ┌─────┴─────┐
                    ▼           ▼
                   Yes          No
                    │           │
                    ▼           └─> Done
              How many tasks?
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
      1 task     2 tasks     3+ tasks
        │           │           │
        ▼           ▼           ▼
    Create      Create      Create
    Task        Tasks       TASK-BREAKDOWN
                            then Tasks
```

---

## Quick Decision Matrix

| Situation | Create | Skip | Notes |
|---|---|---|---|
| **Defining new feature** | Scenarios | - | Always required, embedded in requirement |
| **Gap in artifact** | Change Request | - | File CR, route to owner |
| **CR needs 1 task** | Task | Task-Breakdown | Direct task creation |
| **CR needs 2 tasks** | Tasks | Task-Breakdown | Direct task creation |
| **CR needs 3+ tasks** | Task-Breakdown | - | Coordinates phased implementation |
| **CR is doc-only** | - | Task-Breakdown, Task | No implementation needed |
| **Complex sprint** | Milestone | - | Multiple scenarios, timeline critical |
| **Simple sprint** | - | Milestone | 1-2 tasks, no timeline pressure |

---

## Scenarios (Always)

### When to Create
✅ **Always** — embedded in every requirement document

### Purpose
- Define user-facing functionality
- Provide acceptance criteria
- Give orchestration hints (effort, timeline)

### Location
`requirements/req-{slug}.md` (embedded section)

### Example
```markdown
### Scenario 1: Successful Login
**Priority:** P0
**Estimated effort:** 3 tasks (14 hours)
**Timeline:** Sprint 1

**Narrative:** As a registered user, I want to log in...

**Acceptance Criteria:**
- [ ] Given valid credentials, then redirect to dashboard
```

---

## Change Request (When Needed)

### When to Create
✅ Gap found in existing artifact
✅ Artifact needs modification
✅ Filed by engineer or user

### Purpose
- Request modification to accepted artifact
- Track change rationale and impact
- Audit trail for all changes

### Location
`change-requests/cr-{slug}.md`

### Example
```yaml
---
id: cr-add-rate-limiting
type: change-request
status: applied
resulted-in:
  - tb-add-rate-limiting  # or [task-id] for simple CR
---
```

---

## Task-Breakdown (Conditional)

### When to Create
✅ Complex CR requiring **3+ coordinated tasks**
✅ Phased implementation needed
✅ Cross-track coordination (BE + FE)

### When to Skip
❌ Simple CR (1 task)
❌ Isolated change
❌ No coordination needed

### Purpose
- Coordinate phased CR implementation
- Organize tasks by tier and dependencies
- Link CR to resulting tasks

### Location
`tasks/tb-{slug}.md`

### Example
```yaml
---
id: tb-add-rate-limiting
type: task-breakdown
triggered-by:
  - cr-add-rate-limiting
hard-deps:
  - cr-add-rate-limiting
---

# Task Breakdown: Add Rate Limiting

## Backend Tasks
| ID | Title | Priority |
|----|-------|----------|
| task-rate-limit-middleware-be | Add middleware | 1 |
| task-rate-limit-config-be | Add config | 2 |
| task-rate-limit-tests-be | Add tests | 3 |
```

---

## Milestone (Optional)

### When to Create
✅ Complex feature (multiple scenarios)
✅ Timeline tracking critical
✅ Cross-team coordination needed
✅ Stakeholder visibility required

### When to Skip
❌ Simple feature (1-2 tasks)
❌ Single scenario
❌ No timeline pressure

### Purpose
- Coordinate sprint/phase progress
- Track both planned and unplanned work
- Aggregate scenarios and tasks
- Daily standup notes

### Location
`milestones/milestone-{slug}.md`

### Example
```yaml
---
id: milestone-sprint-1
type: milestone
triggered-by:
  - req-auth#scenario-1
  - req-auth#scenario-2
start-date: 2026-05-20
end-date: 2026-06-03
---

# Milestone: Sprint 1

## Scope

### Planned Work (Scenarios)
| Scenario | Status |
|----------|--------|
| req-auth#scenario-1 | done |

### Unplanned Work (CRs)
| CR | Tasks |
|----|-------|
| cr-add-rate-limiting | 3 tasks |

## Progress Tracking
**2026-05-20:** Backend started task-login-be
```

---

## Workflow Examples

### Example 1: New Feature (Planned Work)

```
1. BA writes requirement with scenarios
   → req-user-authentication
      └─ scenario-1: Login
      └─ scenario-2: Logout

2. Architect creates tasks
   → task-login-be
   → task-session-be
   → task-login-fe

3. Orchestrator creates milestone (optional)
   → milestone-sprint-1
      ├─ triggered-by: [req-auth#scenario-1, req-auth#scenario-2]
      └─ tasks: [task-login-be, task-session-be, task-login-fe]
```

**Artifacts created:** Requirement (with scenarios), Tasks, Milestone (optional)

---

### Example 2: Simple CR (1 Task)

```
1. Engineer discovers typo in API response
   → cr-fix-session-typo filed

2. Orchestrator applies CR
   → cr-fix-session-typo: status = applied

3. Orchestrator creates single task
   → task-fix-session-typo-be
   → cr.resulted-in = [task-fix-session-typo-be]

4. Milestone updated (if exists)
   → milestone-sprint-1
      └─ change-requests: [cr-fix-session-typo]
```

**Artifacts created:** CR, Task (no task-breakdown)

---

### Example 3: Complex CR (3+ Tasks)

```
1. Engineer discovers missing rate limiting
   → cr-add-rate-limiting filed

2. Orchestrator applies CR
   → cr-add-rate-limiting: status = applied

3. Orchestrator creates task-breakdown
   → tb-add-rate-limiting
      ├─ triggered-by: [cr-add-rate-limiting]
      └─ hard-deps: [cr-add-rate-limiting]

4. Task-breakdown creates tasks
   → task-rate-limit-middleware-be
   → task-rate-limit-config-be
   → task-rate-limit-tests-be
   → cr.resulted-in = [tb-add-rate-limiting]

5. Milestone updated (if exists)
   → milestone-sprint-1
      ├─ change-requests: [cr-add-rate-limiting]
      └─ tasks: [...existing..., 3 new CR tasks]
```

**Artifacts created:** CR, Task-Breakdown, Tasks

---

## Frontmatter Fields Summary

### Common Coordination Fields

```yaml
# Shows source of work
triggered-by:
  - req-{slug}#scenario-N  # for milestones
  - cr-{slug}              # for task-breakdowns

# Shows work created (CRs only)
resulted-in:
  - tb-{slug}   # for complex CRs
  - task-{slug} # for simple CRs
  - []          # for doc-only CRs
```

### Milestone-Specific

```yaml
start-date: {YYYY-MM-DD}
end-date: {YYYY-MM-DD}
soft-deps:
  - req-{slug}
  - cr-{slug}  # tracks CR-driven work
```

### Task-Breakdown-Specific

```yaml
hard-deps:
  - cr-{slug}  # must be status: applied
```

---

## Orchestrator Logic

### CR Resolution Flow

```
CR filed
  ↓
CR applied
  ↓
Orchestrator evaluates complexity:
  
  Simple (1 task):
    → create single task
    → stamp cr.resulted-in = [task-id]
  
  Complex (3+ tasks):
    → create task-breakdown
    → stamp cr.resulted-in = [tb-id]
    → task-breakdown creates tasks
  
  Doc-only:
    → cr.resulted-in = []
  ↓
Update milestone if exists:
  → add CR to change-requests section
  → add tasks to task tables
  → update refs
```

---

## Summary

### Unified Coordination Pattern

```
Scenarios (user value definition)
  ↓
Coordination Layer
  ├─ Milestone (planned work, optional)
  ├─ Task-Breakdown (CR work, conditional)
  └─ Direct Tasks (simple work)
  ↓
Tasks (implementation)
```

### Key Principles

1. **Scenarios** = Always required (define WHAT)
2. **CRs** = When needed (request changes)
3. **Task-Breakdown** = Conditional (3+ tasks from CR)
4. **Milestone** = Optional (timeline coordination)

### Relationships

- `triggered-by` shows source of work
- `resulted-in` shows work created
- Milestones track both planned and unplanned work
- Task-breakdowns only for complex CRs
