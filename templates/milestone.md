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
  - cr-{slug}
---

# Milestone: {title}

## Objective
<!-- What this milestone aims to deliver. One paragraph. -->

## Scope

### Scenarios Included
| Scenario | Requirement | Priority | Status |
|----------|-------------|----------|--------|
| Scenario 1: {title} | req-{slug}#scenario-1 | P0 | pending |
| Scenario 2: {title} | req-{slug}#scenario-2 | P1 | pending |

### Scenarios Deferred
| Scenario | Requirement | Reason | Target Milestone |
|----------|-------------|--------|------------------|
| Scenario 3: {title} | req-{slug}#scenario-3 | Not launch blocker | milestone-{name} |

### Change Requests (Unplanned Work)
<!-- CRs applied during this milestone that created additional tasks -->
| CR ID | Priority | Status | Tasks Created | Impact |
|-------|----------|--------|---------------|--------|
| cr-{slug} | minor | applied | 2 tasks | Added rate limiting |

---

## Task Breakdown

### Backend Track
| Task ID | Title | Source | Tier | Est. Hours | Status | Owner |
|---------|-------|--------|------|------------|--------|-------|
| task-{slug}-be | {title} | scenario-1 | 1 | {N} | open | backend-engineer |
| task-{slug}-be | {title} | scenario-1 | 2 | {N} | open | backend-engineer |
| task-{slug}-be | {title} | cr-{slug} | 2 | {N} | open | backend-engineer |

**Backend Total:** {N} hours

### Frontend Track
| Task ID | Title | Source | Tier | Est. Hours | Status | Owner |
|---------|-------|--------|------|------------|--------|-------|
| task-{slug}-fe | {title} | scenario-1 | 1 | {N} | open | frontend-engineer |
| task-{slug}-fe | {title} | scenario-2 | 1 | {N} | open | frontend-engineer |
| task-{slug}-fe | {title} | cr-{slug} | 1 | {N} | open | frontend-engineer |

**Frontend Total:** {N} hours

---

## Timeline

```mermaid
gantt
    title {Milestone Name} Timeline
    dateFormat YYYY-MM-DD
    section Backend
    Task 1       :task1, {start-date}, {duration}d
    Task 2       :task2, {start-date}, {duration}d
    section Frontend
    Task 3       :task3, {start-date}, {duration}d
    Task 4       :task4, {start-date}, {duration}d
```

---

## Dependencies

### Cross-Track Dependencies
<!-- Dependencies between backend and frontend tasks -->
- Frontend task-{slug}-fe depends on Backend task-{slug}-be (API contract)

### External Dependencies
<!-- Dependencies on external systems, services, or teams -->
- 

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
|      | High/Medium/Low |  |

---

## Success Criteria
- [ ] All P0 scenarios have passing acceptance criteria
- [ ] All tasks status: done
- [ ] No open CRs blocking deployment
- [ ] Test coverage >{N}%

---

## Progress Tracking

### Daily Standup Notes
**{YYYY-MM-DD}:**
- Backend: 
- Frontend: 

**{YYYY-MM-DD}:**
- Backend: 
- Frontend: 

---

## Retrospective
<!-- Filled at milestone completion -->

### What Went Well
- 

### What Could Improve
- 

### Action Items
- 
