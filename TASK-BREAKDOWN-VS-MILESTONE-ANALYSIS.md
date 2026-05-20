# Task-Breakdown vs Milestone vs Scenarios Analysis

---

## Question

What are the differences between task-breakdown, milestone, and scenarios? Are there overlaps? Can we simplify?

---

## Side-by-Side Comparison

| Aspect | Scenarios (in Requirements) | Milestone | Task-Breakdown |
|--------|----------------------------|-----------|----------------|
| **Purpose** | Define user-facing functionality | Coordinate timeline & progress | Decompose CR-driven work |
| **Owner** | Business Analyst | Orchestrator | Orchestrator |
| **Trigger** | Feature needs definition | Sprint/phase planning | Change request applied |
| **Phase** | DEFINE (Phase 1) | BUILD (Phase 4) | Any phase (CR-driven) |
| **Scope** | User scenarios with AC | Multiple scenarios + tasks | CR-specific tasks only |
| **Timeline** | Hints at sprint/phase | Explicit start/end dates | No timeline |
| **Tasks** | Estimates task count | Lists actual tasks | Lists actual tasks |
| **Progress** | No tracking | Daily standup notes | No tracking |
| **Optional?** | No (required) | Yes (optional) | No (CR-required) |

---

## Detailed Analysis

### 1. Scenarios (in Requirements)

**Location:** `requirements/req-{slug}.md` (embedded)  
**Owner:** Business Analyst  
**Created:** Phase 1 (DEFINE)

**Purpose:**
- Define WHAT user functionality needs to be built
- Provide user narratives and acceptance criteria
- Give orchestration hints (priority, effort estimate, timeline)

**Content:**
```markdown
### Scenario 1: Successful Login
**Priority:** P0 (launch blocker)
**Estimated effort:** 3 tasks (14 hours)  ← ESTIMATE, not actual tasks
**Dependencies:** None
**Timeline:** Sprint 1  ← HINT, not binding

**Narrative:** As a registered user, I want to...

**Acceptance Criteria:**
- [ ] Given valid credentials, then redirect to dashboard
```

**Key characteristics:**
- ✅ Defines user-facing behavior
- ✅ Embedded in requirement document
- ✅ Written early (Phase 1)
- ✅ Provides planning estimates
- ❌ Does NOT list actual tasks
- ❌ Does NOT track progress
- ❌ Does NOT have start/end dates

---

### 2. Milestone

**Location:** `milestones/milestone-{name}.md` (separate file)  
**Owner:** Orchestrator  
**Created:** Phase 4 (BUILD) — optional

**Purpose:**
- Coordinate timeline across multiple scenarios and tasks
- Track progress during sprint/phase
- Provide high-level view for stakeholders
- Aggregate effort and manage risks

**Content:**
```markdown
# Milestone: Sprint 1 — Core Authentication

## Objective
Deliver core login functionality

## Scope
### Scenarios Included
| Scenario | Requirement | Priority | Status |
|----------|-------------|----------|--------|
| Scenario 1: Login | req-auth#scenario-1 | P0 | in-progress |

## Task Breakdown
### Backend Track
| Task ID | Title | Scenario | Tier | Est. Hours | Status |
|---------|-------|----------|------|------------|--------|
| task-login-be | Login validation | scenario-1 | 1 | 8 | open |

**Backend Total:** 14 hours

## Timeline
start-date: 2026-05-20
end-date: 2026-06-03

## Progress Tracking
**2026-05-20:** Backend started task-login-be
```

**Key characteristics:**
- ✅ Lists ACTUAL tasks (not estimates)
- ✅ Has explicit start/end dates
- ✅ Tracks progress (daily notes)
- ✅ Aggregates multiple scenarios
- ✅ Cross-cutting coordination
- ✅ **Optional** — only create when needed
- ❌ NOT triggered by CR

---

### 3. Task-Breakdown

**Location:** `tasks/tb-{slug}.md` (separate file)  
**Owner:** Orchestrator  
**Created:** After CR is applied (any phase)

**Purpose:**
- Decompose work triggered by a change request
- Coordinate phased implementation of CR-driven changes
- Manage tasks that arise from mid-flight changes

**Content:**
```markdown
# Task Breakdown: Add Rate Limiting

## Source Change Request
cr-api-missing-rate-limit  ← MUST reference applied CR

## Context
API contract was missing rate limiting spec. CR applied to add it.
Now need tasks to implement rate limiting.

## Backend Tasks
| ID | Title | Priority | Depends On |
|----|-------|----------|------------|
| task-rate-limit-middleware-be | Add rate limit middleware | 1 | - |
| task-rate-limit-config-be | Add rate limit config | 2 | task-rate-limit-middleware-be |

## Dependency Order
Tier 1: task-rate-limit-middleware-be
Tier 2: task-rate-limit-config-be
```

**Key characteristics:**
- ✅ Lists ACTUAL tasks (not estimates)
- ✅ **Triggered by CR** (hard requirement)
- ✅ Manages CR-driven work
- ❌ No start/end dates
- ❌ No progress tracking
- ❌ No scenario aggregation
- ❌ NOT optional (required for CRs)

---

## Overlap Analysis

### ❓ Scenarios vs Milestone: Task Lists

**Potential overlap:**
- Scenarios have "Estimated effort: 3 tasks"
- Milestones have "Task Breakdown" table

**Verdict: ❌ NO OVERLAP**

**Why:**
- **Scenarios:** Provide ESTIMATES for planning ("roughly 3 tasks")
- **Milestones:** List ACTUAL tasks after they're created

**Flow:**
```
1. BA writes scenario: "Estimated effort: 3 tasks (14 hours)"
2. Architect creates actual tasks: task-login-be, task-session-be, task-login-fe
3. Orchestrator creates milestone (optional) listing those 3 actual tasks
```

**Analogy:**
- Scenario = "We'll need about 3 people for this project"
- Milestone = "Alice, Bob, and Carol are assigned to this project"

---

### ❓ Scenarios vs Milestone: Timeline

**Potential overlap:**
- Scenarios have "Timeline: Sprint 1"
- Milestones have "start-date: 2026-05-20, end-date: 2026-06-03"

**Verdict: ❌ NO OVERLAP**

**Why:**
- **Scenarios:** Provide HINTS for planning ("probably Sprint 1")
- **Milestones:** Define ACTUAL dates for execution

**Flow:**
```
1. BA writes scenario: "Timeline: Sprint 1" (hint)
2. Orchestrator creates milestone: "start-date: 2026-05-20" (actual)
```

**Analogy:**
- Scenario = "We should do this in Q2"
- Milestone = "Start: May 20, End: June 3"

---

### ❓ Milestone vs Task-Breakdown: Task Lists

**Potential overlap:**
- Both list actual tasks in tables
- Both organize tasks by backend/frontend

**Verdict: ⚠️ SIMILAR FORMAT, DIFFERENT PURPOSE**

**Why:**
- **Milestone:** Coordinates PLANNED work (sprint/phase)
- **Task-Breakdown:** Coordinates CR-DRIVEN work (unplanned changes)

**When to use:**
- **Milestone:** "Sprint 1 will implement scenarios 1 and 2"
- **Task-Breakdown:** "CR-123 requires 3 new tasks to fix the gap"

**Key difference:**
- Milestone = proactive planning
- Task-breakdown = reactive coordination

---

## Use Case Comparison

### Use Case 1: New Feature (Planned Work)

**Scenario:**
You're building a new "User Authentication" feature from scratch.

**Artifacts created:**

1. **Requirement with Scenarios** (Phase 1)
   ```markdown
   ### Scenario 1: Successful Login
   **Estimated effort:** 3 tasks (14 hours)
   **Timeline:** Sprint 1
   ```

2. **Tasks** (Phase 3)
   - task-login-validation-be
   - task-session-mgmt-be
   - task-login-form-fe

3. **Milestone** (Phase 4, optional)
   ```markdown
   # Milestone: Sprint 1
   ## Scenarios Included
   - Scenario 1: Successful Login
   
   ## Task Breakdown
   - task-login-validation-be (8h)
   - task-session-mgmt-be (6h)
   - task-login-form-fe (8h)
   
   Total: 22 hours
   ```

**Task-breakdown:** ❌ NOT CREATED (no CR involved)

---

### Use Case 2: Mid-Flight Change (Unplanned Work)

**Scenario:**
During implementation, engineer discovers API contract is missing rate limiting spec.

**Artifacts created:**

1. **Change Request** (during Phase 4)
   ```markdown
   # CR: API Missing Rate Limit
   Target: api-user-authentication
   Proposed change: Add rate limiting spec
   ```

2. **Task-Breakdown** (after CR applied)
   ```markdown
   # Task Breakdown: Add Rate Limiting
   Source CR: cr-api-missing-rate-limit
   
   ## Backend Tasks
   - task-rate-limit-middleware-be
   - task-rate-limit-config-be
   ```

3. **Tasks** (created from task-breakdown)
   - task-rate-limit-middleware-be
   - task-rate-limit-config-be

**Milestone:** ❌ NOT UPDATED (or optionally updated to include new tasks)  
**Scenarios:** ❌ NOT CHANGED (scenarios don't track CR-driven work)

---

## When to Create Each Artifact

### Scenarios (in Requirements)
**When:** Always (Phase 1)  
**Who:** Business Analyst  
**Trigger:** Feature needs definition

**Create when:**
- ✅ Defining a new feature
- ✅ Adding functionality to existing feature
- ✅ Refining user requirements

**Skip when:**
- ❌ Never — scenarios are required in requirements

---

### Milestone
**When:** Optional (Phase 4)  
**Who:** Orchestrator  
**Trigger:** Sprint/phase planning

**Create when:**
- ✅ Complex feature with multiple sprints
- ✅ Cross-team coordination needed
- ✅ Timeline tracking is critical
- ✅ Stakeholder visibility required
- ✅ Multiple scenarios in one sprint

**Skip when:**
- ✅ Simple feature (1-2 tasks)
- ✅ Single scenario, single sprint
- ✅ No timeline pressure
- ✅ No stakeholder reporting needed

---

### Task-Breakdown
**When:** Required (when CR applied)  
**Who:** Orchestrator  
**Trigger:** Change request status: applied

**Create when:**
- ✅ CR requires new implementation work
- ✅ CR affects multiple tasks
- ✅ CR needs phased implementation

**Skip when:**
- ❌ Never — task-breakdown is required for CRs that need new tasks

---

## Simplification Recommendations

### ✅ **Keep All Three — No Simplification Needed**

**Rationale:**

1. **Scenarios are required** — Cannot be eliminated
   - Core to requirements definition
   - Provide user value and acceptance criteria
   - Used by all downstream artifacts

2. **Milestone is optional** — Already simplified
   - Only create when timeline coordination needed
   - Provides value for complex features
   - No overhead for simple features

3. **Task-breakdown serves unique purpose** — Cannot be merged
   - Handles CR-driven work (unplanned)
   - Different trigger than milestone (CR vs sprint)
   - Required for change management workflow

---

## Potential Confusion Points

### ❓ "Why not merge milestone and task-breakdown?"

**Answer:** Different triggers and purposes

| Aspect | Milestone | Task-Breakdown |
|--------|-----------|----------------|
| **Trigger** | Sprint planning | CR applied |
| **Work type** | Planned (scenarios) | Unplanned (changes) |
| **Timeline** | Yes (start/end dates) | No |
| **Progress** | Yes (daily notes) | No |
| **Optional** | Yes | No (for CRs) |

**Example:**
- Milestone coordinates Sprint 1 (planned scenarios 1-3)
- Task-breakdown coordinates CR-123 fix (unplanned rate limiting)

**They can coexist:**
- Sprint 1 milestone includes 10 planned tasks
- CR-123 task-breakdown adds 2 unplanned tasks
- Milestone can be updated to include CR tasks (optional)

---

### ❓ "Why do scenarios have 'Estimated effort' if milestone lists actual tasks?"

**Answer:** Different phases, different purposes

**Scenario estimates (Phase 1):**
- Help prioritize scenarios
- Inform sprint planning
- Rough sizing ("about 3 tasks")
- Written before tasks exist

**Milestone tasks (Phase 4):**
- Actual tasks created by engineers
- Precise effort ("8 hours")
- Written after tasks exist

**Flow:**
```
Phase 1: Scenario says "~3 tasks, ~14 hours"
Phase 3: Engineers create 3 actual tasks
Phase 4: Milestone lists those 3 tasks with actual hours
```

---

### ❓ "Can I skip milestones and just use task-breakdown?"

**Answer:** No — they serve different purposes

**Task-breakdown:**
- ❌ No timeline (start/end dates)
- ❌ No progress tracking
- ❌ Only for CR-driven work
- ❌ No scenario aggregation

**Milestone:**
- ✅ Has timeline
- ✅ Tracks progress
- ✅ Coordinates planned work
- ✅ Aggregates scenarios

**Use both when:**
- Sprint 1 milestone coordinates planned work
- CR task-breakdown coordinates unplanned fixes
- Milestone optionally includes CR tasks for full picture

---

## Dependency Graph Position

```
[requirement (with scenarios)]  ← Scenarios embedded here
        │
        ├─────────────────────┐
        ▼                     ▼
   [api-contract]      [component-spec]
        │                     │
        └──────┬──────────────┘
               ▼
           [task]
               │
        ┌──────┴──────┐
        ▼             ▼
  [milestone]   [task-breakdown]  ← Both coordinate tasks
  (optional,    (required for CRs,
   planned)      unplanned)
```

---

## Summary Table

| Artifact | Required? | Trigger | Purpose | Timeline | Progress | Tasks |
|----------|-----------|---------|---------|----------|----------|-------|
| **Scenarios** | ✅ Yes | Feature definition | Define WHAT | Hint | No | Estimate |
| **Milestone** | ❌ Optional | Sprint planning | Coordinate planned work | Yes | Yes | Actual |
| **Task-Breakdown** | ✅ Yes (for CRs) | CR applied | Coordinate CR work | No | No | Actual |

---

## Final Recommendation

### ✅ **Keep All Three — No Overlap, No Simplification Needed**

**Why:**

1. **Scenarios** = Required, define user functionality (Phase 1)
2. **Milestone** = Optional, coordinate timeline (Phase 4, planned work)
3. **Task-Breakdown** = Required for CRs, coordinate changes (any phase, unplanned work)

**They complement each other:**
- Scenarios provide estimates → Milestone uses actual tasks
- Milestone coordinates sprints → Task-breakdown coordinates CRs
- Both can coexist without conflict

**Best practices:**
- Always write scenarios in requirements
- Create milestones for complex features with timeline needs
- Create task-breakdowns when CRs require new implementation work
- Update milestones to include CR tasks if desired (optional)

---

## Example: Full Workflow

### Phase 1: Requirements
```markdown
## Scenarios
### Scenario 1: Successful Login
**Estimated effort:** 3 tasks (14 hours)  ← ESTIMATE
**Timeline:** Sprint 1  ← HINT
```

### Phase 3: Task Decomposition
Engineers create actual tasks:
- task-login-validation-be
- task-session-mgmt-be
- task-login-form-fe

### Phase 4: Implementation (Optional Milestone)
```markdown
# Milestone: Sprint 1
start-date: 2026-05-20
end-date: 2026-06-03

## Task Breakdown
- task-login-validation-be (8h) ← ACTUAL
- task-session-mgmt-be (6h)
- task-login-form-fe (8h)

Total: 22 hours (vs estimated 14 hours)
```

### During Implementation: CR Filed
```markdown
# CR: API Missing Rate Limit
Status: applied
```

### After CR Applied: Task-Breakdown
```markdown
# Task Breakdown: Add Rate Limiting
Source CR: cr-api-missing-rate-limit

## Backend Tasks
- task-rate-limit-middleware-be
- task-rate-limit-config-be
```

### Optional: Update Milestone
```markdown
# Milestone: Sprint 1 (updated)

## Task Breakdown
- task-login-validation-be (done)
- task-session-mgmt-be (done)
- task-login-form-fe (done)
- task-rate-limit-middleware-be (open) ← CR task added
- task-rate-limit-config-be (open)

Total: 30 hours (22 planned + 8 CR)
```

**All three artifacts work together without duplication.**
