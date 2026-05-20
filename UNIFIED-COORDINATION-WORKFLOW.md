# Unified Coordination Workflow
> Unifying CR, Scenario, Milestone, and Task-Breakdown workflows

---

## Executive Summary

**Question:** Can we unify the CR, scenario, milestone, and task-breakdown workflows?

**Answer:** **Yes, with clarifications** — these artifacts serve different coordination purposes but can be unified through a **single coordination pattern** with clear relationships.

---

## Current State Analysis

### Four Coordination Mechanisms

| Artifact | Purpose | Trigger | Timeline | Progress | Required |
|---|---|---|---|---|---|
| **Scenarios** | Define WHAT (user value) | Feature definition | Hint only | No | Yes |
| **CR** | Request artifact changes | Gap discovered | No | Resolution lifecycle | Yes (for changes) |
| **Task-Breakdown** | Coordinate CR tasks | CR applied | No | No | Yes (for CRs) |
| **Milestone** | Coordinate sprint work | Sprint planning | Yes (dates) | Yes (daily) | Optional |

### Overlap Points

1. **Scenarios + Milestone:** Both reference tasks
   - Scenarios provide **estimates** ("~3 tasks")
   - Milestones list **actual tasks** (task-login-be, task-session-be)

2. **Task-Breakdown + Milestone:** Both organize tasks
   - Task-breakdown coordinates **CR-driven** work (unplanned)
   - Milestone coordinates **scenario-driven** work (planned)

3. **CR + Task-Breakdown:** Direct dependency
   - CR triggers task-breakdown when multiple tasks needed
   - CR.resulted-in links to task-breakdown

---

## Unified Model

### Core Pattern: Coordination Hierarchy

```
[Scenarios] ────────┐
(user value)        │
                    ▼
              [Coordination]
                    │
         ┌──────────┼──────────┐
         ▼          ▼          ▼
    [Milestone] [Task-BD]  [Direct Tasks]
    (planned)   (CR-driven) (simple work)
         │          │          │
         └──────────┴──────────┘
                    ▼
                [Tasks]
```

### Unified Coordination Pattern

**All coordination artifacts follow the same structure:**

```yaml
---
id: {coord-type}-{slug}
type: {milestone | task-breakdown}
owner: orchestrator
status: draft
feature: {feature-slug}

# Source of work
triggered-by:
  - req-{slug}#scenario-N  # for milestones
  - cr-{slug}              # for task-breakdowns

# Timeline (optional)
start-date: {YYYY-MM-DD}
end-date: {YYYY-MM-DD}

# Dependencies
hard-deps: []
soft-deps: []
refs: []
---

# {Title}

## Objective
<!-- What this coordination unit delivers -->

## Scope
<!-- Scenarios or CRs included -->

## Task Breakdown
<!-- Backend + Frontend tracks with tiers -->

## Progress Tracking (optional)
<!-- Daily notes for milestones -->
```

---

## Unified Workflow

### 1. Planned Work (Scenario → Milestone → Tasks)

```
Phase 1: DEFINE
  └─ requirement (with scenarios)
       └─ scenario-1: "Login flow" (estimate: 3 tasks)

Phase 3: DECOMPOSE
  └─ tasks created
       ├─ task-login-be
       ├─ task-session-be
       └─ task-login-fe

Phase 4: BUILD (optional)
  └─ milestone-sprint-1
       ├─ triggered-by: [req-auth#scenario-1]
       ├─ tasks: [task-login-be, task-session-be, task-login-fe]
       ├─ start-date: 2026-05-20
       └─ progress: daily standup notes
```

**Key:** Milestone is **optional** — only create for complex features needing timeline coordination.

---

### 2. Simple CR (CR → Single Task)

```
During BUILD:
  └─ cr-fix-typo filed
       └─ CR applied
            └─ task-fix-typo-fe created
                 └─ cr-fix-typo.resulted-in = [task-fix-typo-fe]

Optional:
  └─ milestone-sprint-1 updated
       └─ tasks: [...existing..., task-fix-typo-fe]
```

**Key:** No task-breakdown needed for simple CRs (1 task).

---

### 3. Complex CR (CR → Task-Breakdown → Multiple Tasks)

```
During BUILD:
  └─ cr-add-rate-limiting filed
       └─ CR applied
            └─ tb-add-rate-limiting created
                 ├─ triggered-by: [cr-add-rate-limiting]
                 ├─ tasks: [task-rate-limit-middleware-be, task-rate-limit-config-be]
                 └─ cr-add-rate-limiting.resulted-in = [tb-add-rate-limiting]

Optional:
  └─ milestone-sprint-1 updated
       ├─ change-requests: [cr-add-rate-limiting]
       └─ tasks: [...existing..., task-rate-limit-middleware-be, task-rate-limit-config-be]
```

**Key:** Task-breakdown coordinates phased CR implementation.

---

## Decision Rules

### When to Create Each Artifact

#### Scenarios (Always)
✅ **Always create** — embedded in requirements
- Defines user-facing functionality
- Provides orchestration hints (effort, timeline)
- Required for all features

#### Change Request (When Needed)
✅ **Create when:**
- Gap found in existing artifact
- Artifact needs modification
- Filed by engineer or user

#### Task-Breakdown (Conditional)
✅ **Create when CR requires:**
- Multiple coordinated tasks (3+)
- Phased implementation
- Cross-track coordination (BE + FE)

❌ **Skip when CR is simple:**
- Single task
- Isolated change
- No coordination needed

#### Milestone (Optional)
✅ **Create when:**
- Complex feature (multiple scenarios)
- Timeline tracking critical
- Cross-team coordination needed
- Stakeholder visibility required

❌ **Skip when:**
- Simple feature (1-2 tasks)
- Single scenario
- No timeline pressure

---

## Unified Frontmatter Fields

### Common Fields (All Coordination Artifacts)

```yaml
# Identity
id: {type}-{slug}
type: {milestone | task-breakdown}
owner: orchestrator
status: draft
version: 1.0
feature: {feature-slug}

# Source of work
triggered-by:
  - {scenario-id | cr-id}

# Timeline (optional for task-breakdown)
start-date: {YYYY-MM-DD}
end-date: {YYYY-MM-DD}

# Dependencies
hard-deps: []
soft-deps:
  - {requirement-id}  # for milestones
  - {cr-id}           # for task-breakdowns
refs:
  - {all-linked-artifacts}
```

### Milestone-Specific Fields

```yaml
# Scope
scenarios:
  - req-{slug}#scenario-1
  - req-{slug}#scenario-2

change-requests:  # NEW: track CR-driven work
  - cr-{slug}

# Progress tracking
progress-notes: []
```

### Task-Breakdown-Specific Fields

```yaml
# Source CR
source-cr: cr-{slug}

# No timeline fields
# No progress tracking
```

---

## Enhanced Templates

### Enhanced Milestone Template

```yaml
---
id: milestone-{name}
type: milestone
owner: orchestrator
status: draft
version: 1.0
feature: {feature-slug}
start-date: {YYYY-MM-DD}
end-date: {YYYY-MM-DD}

triggered-by:
  - req-{slug}#scenario-1
  - req-{slug}#scenario-2

hard-deps: []
soft-deps:
  - req-{slug}

refs:
  - req-{slug}
  - task-{slug}-be
  - task-{slug}-fe
  - cr-{slug}  # NEW: include CR-driven work
---

# Milestone: {title}

## Objective
<!-- What this milestone delivers -->

## Scope

### Planned Work (Scenarios)
| Scenario | Requirement | Priority | Status |
|----------|-------------|----------|--------|
| Scenario 1: {title} | req-{slug}#scenario-1 | P0 | pending |

### Unplanned Work (Change Requests)
| CR | Priority | Status | Tasks Created |
|----|----------|--------|---------------|
| cr-{slug} | minor | applied | 2 tasks |

## Task Breakdown

### Backend Track
| Task ID | Source | Tier | Est. Hours | Status |
|---------|--------|------|------------|--------|
| task-{slug}-be | scenario-1 | 1 | {N} | open |
| task-rate-limit-be | cr-{slug} | 2 | {N} | open |

### Frontend Track
| Task ID | Source | Tier | Est. Hours | Status |
|---------|--------|------|------------|--------|
| task-{slug}-fe | scenario-1 | 1 | {N} | open |

## Progress Tracking
**{YYYY-MM-DD}:**
- Backend: Started task-{slug}-be
- Frontend: Started task-{slug}-fe
- CR: Applied cr-{slug}, created 2 tasks
```

### Simplified Task-Breakdown Template

```yaml
---
id: tb-{slug}
type: task-breakdown
owner: orchestrator
status: draft
version: 1.0
feature: {feature-slug}

triggered-by:
  - cr-{slug}

hard-deps:
  - cr-{slug}  # CHANGED: hard-dep on CR (must be applied)

soft-deps: []

refs:
  - cr-{slug}
  - task-{slug}-be
  - task-{slug}-fe
---

# Task Breakdown: {title}

## Source Change Request
cr-{slug} (status: applied)

## Context
<!-- Why these tasks are needed -->

## Task Breakdown

### Backend Tasks
| ID | Title | Priority | Depends On |
|----|-------|----------|------------|
| task-{slug}-be | {title} | 1 | - |

### Frontend Tasks
| ID | Title | Priority | Depends On |
|----|-------|----------|------------|
| task-{slug}-fe | {title} | 1 | - |

## Dependency Order
Tier 1: task-{slug}-be
Tier 2: task-{slug}-fe (depends on tier 1)
```

---

## Orchestrator Logic Changes

### Current CR Resolution Flow

```
CR filed
  → CR applied
  → orchestrator creates tasks manually
  → no explicit link between CR and tasks
```

### Unified CR Resolution Flow

```
CR filed
  → CR applied
  → orchestrator evaluates complexity:
      
      Simple (1 task):
        → create single task
        → stamp CR.resulted-in = [task-id]
        → update milestone if exists
      
      Complex (3+ tasks):
        → create task-breakdown
        → stamp CR.resulted-in = [tb-id]
        → task-breakdown creates tasks
        → update milestone if exists
```

### Milestone Update Logic

```
When CR is applied:
  1. Check if milestone exists for current sprint
  2. If yes:
     a. Add CR to milestone.change-requests[]
     b. Add CR tasks to milestone task tables
     c. Update milestone.refs to include CR + tasks
     d. Bump milestone version
  3. If no:
     a. Tasks created but not tracked in milestone
     b. Optional: suggest creating milestone
```

---

## Benefits of Unified Model

### 1. Single Coordination Pattern
- All coordination artifacts follow same structure
- Easier to understand and maintain
- Consistent frontmatter fields

### 2. Clear Relationships
- `triggered-by` field shows source of work
- `resulted-in` field shows work created
- Bidirectional traceability

### 3. Flexible Granularity
- Simple work: CR → Task (no task-breakdown)
- Complex work: CR → Task-Breakdown → Tasks
- Optional: Milestone tracks both

### 4. Milestone as Single Source of Truth
- Tracks both planned and unplanned work
- Shows full sprint picture
- Enables accurate progress tracking

---

## Migration Path

### Phase 1: Enhance CR Template
✅ Already has `resulted-in` field
✅ No changes needed

### Phase 2: Update Task-Breakdown Template
✅ Change `soft-deps` to `hard-deps` for CR
✅ Add `triggered-by` field
✅ Already complete

### Phase 3: Enhance Milestone Template
✅ Add `change-requests` section
✅ Add `triggered-by` field
✅ Update task tables to show source (scenario vs CR)

### Phase 4: Update Orchestrator Logic
✅ Implement complexity evaluation for CRs
✅ Auto-create task-breakdown for complex CRs
✅ Auto-update milestones when CRs applied

---

## Examples

### Example 1: Sprint with Planned + Unplanned Work

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

# Milestone: Sprint 1 — Core Authentication

## Scope

### Planned Work
| Scenario | Status |
|----------|--------|
| req-auth#scenario-1 | done |
| req-auth#scenario-2 | in-progress |

### Unplanned Work (CRs)
| CR | Status | Tasks |
|----|--------|-------|
| cr-add-rate-limiting | applied | 2 tasks |
| cr-fix-session-typo | applied | 1 task |

## Task Breakdown

### Backend Track
| Task ID | Source | Status |
|---------|--------|--------|
| task-login-be | scenario-1 | done |
| task-session-be | scenario-1 | done |
| task-rate-limit-be | cr-add-rate-limiting | in-progress |
| task-session-typo-be | cr-fix-session-typo | done |

**Total:** 22 planned hours + 8 CR hours = 30 hours
```

### Example 2: Complex CR with Task-Breakdown

```yaml
---
id: cr-add-rate-limiting
type: change-request
status: applied
resulted-in:
  - tb-add-rate-limiting
---

# CR: Add Rate Limiting to API

## Decision
**Status:** applied
**Resulted in:** tb-add-rate-limiting (3 tasks created)
```

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

## Source Change Request
cr-add-rate-limiting (status: applied)

## Task Breakdown

### Backend Tasks
| ID | Title | Priority |
|----|-------|----------|
| task-rate-limit-middleware-be | Add rate limit middleware | 1 |
| task-rate-limit-config-be | Add rate limit config | 2 |
| task-rate-limit-tests-be | Add rate limit tests | 3 |
```

---

## Summary

### ✅ Unified Pattern Achieved

**Single coordination hierarchy:**
```
Scenarios (user value)
  ↓
Coordination Layer
  ├─ Milestone (planned work, optional)
  ├─ Task-Breakdown (CR work, conditional)
  └─ Direct Tasks (simple work)
  ↓
Tasks (implementation)
```

**Key principles:**
1. **Scenarios** define WHAT (always required)
2. **CRs** request changes (when needed)
3. **Task-Breakdown** coordinates complex CRs (conditional)
4. **Milestone** tracks sprint progress (optional)

**Relationships:**
- `triggered-by` shows source of work
- `resulted-in` shows work created
- Milestones absorb both planned and unplanned work

### ✅ No Artifact Deletion Required

All four artifacts serve distinct purposes:
- Keep scenarios in requirements
- Keep CRs for change management
- Keep task-breakdowns for complex CRs
- Keep milestones for sprint coordination

### ✅ Clarified Relationships

The unified model clarifies when to use each artifact and how they relate, eliminating confusion while preserving flexibility.

---

## Next Steps

1. ✅ Update milestone template to include CR tracking
2. ✅ Update task-breakdown to use hard-deps on CR
3. ✅ Update orchestrator logic for CR complexity evaluation
4. ✅ Document unified pattern in handbook
5. ✅ Update agent instructions to follow unified workflow
