---
id: req-{slug}
type: requirement
owner: business-analyst
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
refs:
  - feat-{slug}
  - persona-{slug}
---

# Requirement: {title}

## Problem Statement
<!-- What user or business problem this requirement addresses. One paragraph. -->

## Scope

### In Scope
- 
- 

### Out of Scope
- 
- 

## User Context
<!-- Which persona(s) this requirement serves. Link to persona docs. -->

- persona-{slug}

## Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| F1 |             | must     |
| F2 |             | should   |
| F3 |             | could    |

Priority: `must` (launch blocker) / `should` (important but not blocking) / `could` (nice to have)

---

## Scenarios

### Scenario 1: {scenario-title}
**Priority:** P0 (launch blocker) | P1 (important) | P2 (nice to have)  
**Estimated effort:** {N} tasks ({N} hours)  
**Dependencies:** None | Scenario N  
**Timeline:** Sprint N | Phase N

**Narrative:**
As a **{persona or role}**,
I want to **{action or capability}**,
so that **{outcome or value}**.

**Preconditions:**
- 
- 

**Acceptance Criteria:**
- [ ] Given {context}, when {action}, then {outcome}
- [ ] Given {context}, when {action}, then {outcome}

**Error / Edge Cases:**
| Scenario | Expected Behavior |
|----------|-------------------|
|          |                   |

---

### Scenario 2: {scenario-title}
**Priority:** P0 | P1 | P2  
**Estimated effort:** {N} tasks ({N} hours)  
**Dependencies:** Scenario 1  
**Timeline:** Sprint N

**Narrative:**
As a **{persona or role}**,
I want to **{action or capability}**,
so that **{outcome or value}**.

**Preconditions:**
- 
- 

**Acceptance Criteria:**
- [ ] Given {context}, when {action}, then {outcome}
- [ ] Given {context}, when {action}, then {outcome}

**Error / Edge Cases:**
| Scenario | Expected Behavior |
|----------|-------------------|
|          |                   |

---

## Success Metrics
<!-- Measurable outcomes. Inherits from feature doc; override or extend here if needed. -->

| Metric | Target |
|--------|--------|
|        |        |

## Constraints
<!-- Hard limits: regulatory, technical, business. Anything the design must not violate. -->

- 

## Open Questions
<!-- Unresolved items. Must be empty before status can reach accepted. -->

- 
