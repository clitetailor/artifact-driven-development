# Orchestration Comparison: Current vs Option A
> Visual comparison of orchestration mechanisms

---

## Current Approach (4-tier with standalone stories)

```
┌─────────────────────────────────────────────────────────────────┐
│ FEATURE                                                          │
│ - Vision & scope                                                 │
│ - Success metrics                                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ REQUIREMENT                                                      │
│ - Functional requirements table                                  │
│ - Constraints                                                    │
│ - Links to stories (refs)                                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ STORY (standalone artifacts)                    ← ORCHESTRATION │
│ ├─ story-successful-login.md                                    │
│ │  - Priority: P0                                               │
│ │  - User narrative                                             │
│ │  - Acceptance criteria                                        │
│ │  - Dependencies: none                                         │
│ │                                                               │
│ ├─ story-password-reset.md                                      │
│ │  - Priority: P1                                               │
│ │  - User narrative                                             │
│ │  - Acceptance criteria                                        │
│ │  - Dependencies: story-successful-login                       │
│ │                                                               │
│ └─ story-mfa-setup.md                                           │
│    - Priority: P2                                               │
│    - User narrative                                             │
│    - Acceptance criteria                                        │
│    - Dependencies: story-successful-login                       │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ TASKS (implementation units)                    ← ORCHESTRATION │
│                                                                  │
│ Backend Track:                                                   │
│ ├─ Tier 1 (no deps)                                             │
│ │  ├─ task-login-validation-be                                  │
│ │  │  - refs: story-successful-login                            │
│ │  │  - priority: 1                                             │
│ │  │  - status: open                                            │
│ │  │                                                             │
│ │  └─ task-session-mgmt-be                                      │
│ │     - refs: story-successful-login                            │
│ │     - priority: 1                                             │
│ │                                                                │
│ └─ Tier 2 (depends on tier 1)                                   │
│    └─ task-reset-token-be                                       │
│       - refs: story-password-reset                              │
│       - priority: 2                                             │
│       - depends-on: task-session-mgmt-be                        │
│                                                                  │
│ Frontend Track:                                                  │
│ ├─ Tier 1                                                        │
│ │  └─ task-login-form-fe                                        │
│ │     - refs: story-successful-login                            │
│ │     - priority: 1                                             │
│ │                                                                │
│ └─ Tier 2                                                        │
│    └─ task-reset-form-fe                                        │
│       - refs: story-password-reset                              │
│       - priority: 2                                             │
└──────────────────────────────────────────────────────────────────┘

ORCHESTRATION MECHANISMS:
✓ Story artifacts provide scenario-level coordination
✓ Task priority tiers provide implementation sequencing
✓ Task depends-on provides cross-task dependencies

PROBLEMS:
✗ Story AC duplicates requirement AC
✗ Task AC duplicates story AC
✗ 3 layers of acceptance criteria (req → story → task)
✗ Extra artifact type to maintain
✗ Longer dependency chains (5 levels)
```

---

## Option A (3-tier with embedded scenarios)

```
┌─────────────────────────────────────────────────────────────────┐
│ FEATURE                                                          │
│ - Vision & scope                                                 │
│ - Success metrics                                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ REQUIREMENT (with embedded scenarios)           ← ORCHESTRATION │
│                                                                  │
│ Functional Requirements:                                         │
│ ├─ F1: User can log in with email/password                      │
│ ├─ F2: System validates credentials                             │
│ └─ F3: User can reset password via email                        │
│                                                                  │
│ ─────────────────────────────────────────────────────────────── │
│                                                                  │
│ Scenario 1: Successful Login                                    │
│ ├─ Priority: P0 (launch blocker)                                │
│ ├─ Estimated effort: 3 tasks (14 hours)                         │
│ ├─ Dependencies: none                                            │
│ ├─ Timeline: Sprint 1                                            │
│ ├─ Narrative: As a registered user, I want to...                │
│ └─ Acceptance Criteria:                                          │
│    ├─ [ ] Valid credentials → redirect to dashboard             │
│    ├─ [ ] Session token created                                 │
│    └─ [ ] Invalid credentials → error message                   │
│                                                                  │
│ Scenario 2: Password Reset Flow                                 │
│ ├─ Priority: P1 (important, not blocking)                       │
│ ├─ Estimated effort: 4 tasks (20 hours)                         │
│ ├─ Dependencies: Scenario 1 (email service)                     │
│ ├─ Timeline: Sprint 2                                            │
│ ├─ Narrative: As a user who forgot password, I want to...       │
│ └─ Acceptance Criteria:                                          │
│    ├─ [ ] Reset email sent                                      │
│    ├─ [ ] Valid token → reset form displayed                    │
│    └─ [ ] New password → updated and can log in                 │
│                                                                  │
│ Scenario 3: MFA Setup                                            │
│ ├─ Priority: P2 (nice to have)                                  │
│ ├─ Estimated effort: 5 tasks (24 hours)                         │
│ ├─ Dependencies: Scenario 1                                     │
│ └─ Timeline: Sprint 3                                            │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ TASKS (implementation units)                    ← ORCHESTRATION │
│                                                                  │
│ Backend Track:                                                   │
│ ├─ Tier 1 (Sprint 1)                                            │
│ │  ├─ task-login-validation-be                                  │
│ │  │  - scenario: req-user-auth#scenario-1                      │
│ │  │  - milestone: sprint-1                                     │
│ │  │  - estimated-hours: 8                                      │
│ │  │  - priority: 1                                             │
│ │  │  - status: open                                            │
│ │  │                                                             │
│ │  └─ task-session-mgmt-be                                      │
│ │     - scenario: req-user-auth#scenario-1                      │
│ │     - milestone: sprint-1                                     │
│ │     - estimated-hours: 6                                      │
│ │     - priority: 1                                             │
│ │                                                                │
│ └─ Tier 2 (Sprint 2)                                            │
│    └─ task-reset-token-be                                       │
│       - scenario: req-user-auth#scenario-2                      │
│       - milestone: sprint-2                                     │
│       - estimated-hours: 8                                      │
│       - priority: 2                                             │
│       - depends-on: task-session-mgmt-be                        │
│                                                                  │
│ Frontend Track:                                                  │
│ ├─ Tier 1 (Sprint 1)                                            │
│ │  └─ task-login-form-fe                                        │
│ │     - scenario: req-user-auth#scenario-1                      │
│ │     - milestone: sprint-1                                     │
│ │     - estimated-hours: 8                                      │
│ │     - priority: 1                                             │
│ │                                                                │
│ └─ Tier 2 (Sprint 2)                                            │
│    └─ task-reset-form-fe                                        │
│       - scenario: req-user-auth#scenario-2                      │
│       - milestone: sprint-2                                     │
│       - estimated-hours: 6                                      │
│       - priority: 2                                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼ (optional)
┌─────────────────────────────────────────────────────────────────┐
│ MILESTONE (optional coordination artifact)      ← ORCHESTRATION │
│                                                                  │
│ milestone-sprint-1.md                                            │
│ ├─ Objective: Deliver core login functionality                  │
│ ├─ Timeline: 2026-05-20 to 2026-06-03                           │
│ ├─ Scenarios: scenario-1 (Successful Login)                     │
│ ├─ Tasks: 3 tasks (14 hours total)                              │
│ ├─ Progress tracking: daily standup notes                       │
│ ├─ Risks & mitigations                                          │
│ └─ Success criteria                                             │
│                                                                  │
│ milestone-sprint-2.md                                            │
│ ├─ Objective: Add password reset flow                           │
│ ├─ Timeline: 2026-06-04 to 2026-06-17                           │
│ ├─ Scenarios: scenario-2 (Password Reset)                       │
│ ├─ Tasks: 4 tasks (20 hours total)                              │
│ └─ Dependencies: Sprint 1 completion                            │
└──────────────────────────────────────────────────────────────────┘

ORCHESTRATION MECHANISMS:
✓ Scenarios (embedded in requirements) provide scenario-level coordination
✓ Task scenario field links tasks to scenarios
✓ Task milestone field assigns tasks to sprints/phases
✓ Task priority tiers provide implementation sequencing
✓ Task depends-on provides cross-task dependencies
✓ Milestone artifacts (optional) provide high-level timeline view

BENEFITS:
✓ No story/requirement AC duplication
✓ 2 layers of AC instead of 3 (req scenarios → task)
✓ Scenarios stay close to requirements (better context)
✓ Shorter dependency chains (4 levels vs 5)
✓ Milestone artifact adds high-level orchestration when needed
✓ All orchestration capabilities preserved
```

---

## Orchestration Queries Comparison

### Current Approach

**Find all stories for a feature:**
```bash
rg -l "feature: user-authentication" stories/
# Returns: story-successful-login.md, story-password-reset.md, story-mfa-setup.md
```

**Find all tasks for a story:**
```bash
rg -l "story-successful-login" tasks/
# Returns: task-login-validation-be.md, task-session-mgmt-be.md, task-login-form-fe.md
```

**Calculate story completion:**
```bash
# Find tasks for story
rg -l "story-successful-login" tasks/

# Count done tasks
rg "status: done" tasks/task-*-login*.md | wc -l
```

---

### Option A

**Find all scenarios for a feature:**
```bash
rg -l "feature: user-authentication" requirements/
# Returns: req-user-authentication.md

# Read requirement doc to see all scenarios
cat requirements/req-user-authentication.md
# Shows: Scenario 1, Scenario 2, Scenario 3 (embedded)
```

**Find all tasks for a scenario:**
```bash
rg -l "scenario: req-user-authentication#scenario-1" tasks/
# Returns: task-login-validation-be.md, task-session-mgmt-be.md, task-login-form-fe.md
```

**Calculate scenario completion:**
```bash
# Find tasks for scenario
rg -l "scenario: req-user-authentication#scenario-1" tasks/

# Count done tasks
rg "status: done" tasks/task-*-scenario-1*.md | wc -l
```

**Find all tasks for a milestone:**
```bash
rg -l "milestone: sprint-1" tasks/
# Returns all tasks assigned to sprint 1
```

**Generate milestone progress report:**
```bash
# Read milestone doc
cat milestones/milestone-sprint-1.md

# Calculate completion
total_tasks=$(rg -l "milestone: sprint-1" tasks/ | wc -l)
done_tasks=$(rg -l "milestone: sprint-1" tasks/ | xargs rg -l "status: done" | wc -l)
echo "Progress: $done_tasks / $total_tasks tasks complete"
```

---

## Timeline Visualization Comparison

### Current Approach (Story-based)

```
Sprint 1:
  Story: Successful Login [P0]
    ├─ task-login-validation-be (tier 1)
    ├─ task-session-mgmt-be (tier 1)
    └─ task-login-form-fe (tier 1)

Sprint 2:
  Story: Password Reset [P1]
    ├─ task-reset-request-be (tier 1)
    ├─ task-reset-token-be (tier 2)
    ├─ task-reset-confirm-be (tier 2)
    └─ task-reset-form-fe (tier 1)

Sprint 3:
  Story: MFA Setup [P2]
    ├─ task-mfa-setup-be (tier 1)
    ├─ task-mfa-verify-be (tier 2)
    └─ task-mfa-ui-fe (tier 1)
```

**Orchestrator reads:**
1. Story artifacts (priority, dependencies)
2. Task artifacts (tier, depends-on, refs to stories)
3. Manual grouping by sprint (no explicit sprint field)

---

### Option A (Scenario + Milestone-based)

```
Sprint 1 (milestone-sprint-1.md):
  Scenario: Successful Login [P0] (req-user-auth#scenario-1)
    ├─ task-login-validation-be (tier 1, milestone: sprint-1, 8h)
    ├─ task-session-mgmt-be (tier 1, milestone: sprint-1, 6h)
    └─ task-login-form-fe (tier 1, milestone: sprint-1, 8h)
  Total: 3 tasks, 22 hours

Sprint 2 (milestone-sprint-2.md):
  Scenario: Password Reset [P1] (req-user-auth#scenario-2)
    ├─ task-reset-request-be (tier 1, milestone: sprint-2, 6h)
    ├─ task-reset-token-be (tier 2, milestone: sprint-2, 8h)
    ├─ task-reset-confirm-be (tier 2, milestone: sprint-2, 4h)
    └─ task-reset-form-fe (tier 1, milestone: sprint-2, 6h)
  Total: 4 tasks, 24 hours

Sprint 3 (milestone-sprint-3.md):
  Scenario: MFA Setup [P2] (req-user-auth#scenario-3)
    ├─ task-mfa-setup-be (tier 1, milestone: sprint-3, 8h)
    ├─ task-mfa-verify-be (tier 2, milestone: sprint-3, 10h)
    └─ task-mfa-ui-fe (tier 1, milestone: sprint-3, 6h)
  Total: 3 tasks, 24 hours
```

**Orchestrator reads:**
1. Requirement scenarios (priority, effort, dependencies, timeline)
2. Task artifacts (tier, depends-on, scenario, milestone, estimated-hours)
3. Milestone artifacts (optional, aggregates scenarios + tasks)

**Benefits:**
- Explicit sprint assignment (milestone field)
- Effort estimates per task (estimated-hours)
- Milestone artifact provides progress tracking
- Scenario metadata in requirement doc provides planning context

---

## Decision Matrix

| Capability | Current (Stories) | Option A (Scenarios + Milestones) |
|------------|-------------------|-----------------------------------|
| **Scenario-level coordination** | ✓ (story artifacts) | ✓ (embedded scenarios) |
| **Task-level coordination** | ✓ (priority tiers) | ✓ (priority tiers + milestone) |
| **Timeline assignment** | Manual (no explicit field) | ✓ (milestone field + artifact) |
| **Effort estimation** | No | ✓ (estimated-hours field) |
| **Progress tracking** | Manual (count task status) | ✓ (milestone artifact) |
| **Dependency management** | ✓ (story deps + task deps) | ✓ (scenario deps + task deps) |
| **Acceptance criteria layers** | 3 (req → story → task) | 2 (req scenario → task) |
| **Independent versioning** | ✓ (stories separate files) | ✗ (scenarios version with req) |
| **Context preservation** | ✗ (stories separate from req) | ✓ (scenarios in req doc) |
| **Artifact count** | Higher (separate stories) | Lower (embedded scenarios) |
| **Dependency chain length** | 5 levels | 4 levels |

---

## Recommendation

**Option A with orchestration enhancements** provides equivalent or better orchestration capabilities:

1. **Scenario-level:** Embedded scenarios with priority, effort, dependencies, timeline
2. **Task-level:** Enhanced tasks with scenario links, milestones, effort estimates
3. **Milestone-level:** Optional coordination artifact for cross-cutting timeline view

**Key advantages:**
- Eliminates story/requirement redundancy
- Maintains all orchestration capabilities
- Adds milestone artifact for high-level coordination
- Shorter dependency chains
- Better context (scenarios near requirements)

**Trade-off:**
- Scenarios not independently versionable (acceptable — version with requirement)
