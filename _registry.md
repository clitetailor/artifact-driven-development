---
type: registry
updated: YYYY-MM-DD
---

# Vault Registry

## Artifact Types

# UNDERSTAND
- research-note
- persona

# DEFINE
- feature
- requirement
- story  # DEPRECATED — use scenarios in requirements

# DESIGN
- user-flow
- wireframe
- component-spec
- architecture-decision
- api-contract
- data-model
- quality-requirement
- test-plan

# BUILD
- test-spec
- test-suite
- task
- task-breakdown
- implementation-note

# OPERATE
- infra

# WORKFLOW
- change-request
- advisory
- milestone  # optional timeline coordination

## ID Prefixes
- research-note          : rn-
- persona                : persona-
- feature                : feat-
- requirement            : req-
- story                  : story-  # DEPRECATED
- milestone              : milestone-
- user-flow              : uf-
- wireframe              : wf-
- component-spec         : cs-
- architecture-decision  : adr-
- api-contract           : api-
- data-model             : dm-
- quality-requirement    : qr-
- test-plan              : tp-
- test-spec              : ts-
- test-suite             : suite-
- task                   : task-
- task-breakdown         : tb-
- implementation-note    : in-
- infra                  : infra-
- change-request         : cr-
- advisory               : adv-

## Features
- {feature-slug}

## Modules
- {feature-slug}/{module-slug}

## Coordination Artifact Decision Rules

### Scenarios (in Requirements)
**When:** Always (required)
**Purpose:** Define user-facing functionality with acceptance criteria
**Location:** Embedded in `requirements/req-{slug}.md`

### Change Request
**When:** Gap found in existing artifact
**Purpose:** Request modification to accepted artifact
**Location:** `change-requests/cr-{slug}.md`

### Task-Breakdown
**When:** Complex CR requiring 3+ coordinated tasks
**Purpose:** Coordinate phased CR implementation
**Location:** `tasks/tb-{slug}.md`
**Skip when:** Simple CR (1 task) or no implementation needed

### Milestone
**When:** Optional — complex feature with timeline needs
**Purpose:** Coordinate sprint/phase progress tracking
**Location:** `milestones/milestone-{slug}.md`
**Skip when:** Simple feature (1-2 tasks) or no timeline pressure

### Unified Pattern
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
