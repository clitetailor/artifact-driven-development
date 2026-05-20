# PKM Folder Structure
> Agent Knowledge Base — Zettelkasten-style document system

---

## Vault Structure

```
/vault
  ├── /research-notes        ← raw discovery notes, interview summaries
  ├── /personas              ← synthesized user archetypes
  ├── /features              ← feature-level scope and status documents
  ├── /requirements          ← PRDs — scoped feature requirements with scenarios
  ├── /user-flows            ← user journey diagrams (Mermaid embedded)
  ├── /wireframes            ← agent-generated ASCII wireframes
  ├── /component-specs       ← UI component specs (states, behavior, tokens)
  ├── /architecture-decisions ← ADRs — architecture decision records
  ├── /quality-requirements  ← NFRs — non-functional requirements
  ├── /api-contracts         ← endpoint specs, request/response shapes
  ├── /data-models           ← schemas, indexes, migration notes
  ├── /test-plans            ← testing strategy per feature              (tp-)
  ├── /test-specs            ← test specifications (unit/integration/e2e) (ts-)
  ├── /test-suites           ← grouped test specs with coverage targets  (suite-)
  ├── /tasks                 ← decomposed implementation units           (task-)
  ├── /implementation-notes  ← optional cross-cutting implementation notes
  ├── /infra                 ← IaC specs, CI/CD, monitoring, runbooks
  ├── /change-requests       ← inter-agent artifact modification requests
  ├── /advisories            ← non-blocking orchestrator warnings
  ├── /milestones            ← optional timeline coordination            (milestone-)
  ├── /agent-memory          ← private agent working state (not indexed)
  │     ├── /business-analyst
  │     ├── /ux-ui-designer
  │     ├── /software-architect
  │     ├── /qa-engineer
  │     ├── /backend-engineer
  │     ├── /frontend-engineer
  │     ├── /devops-engineer
  │     └── /orchestrator
  └── _registry.md           ← single source of valid types, features, modules
```

---

## Registry File

**Path:** `/vault/_registry.md`

```markdown
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

## Artifact Dependency Rules
- research-note         : hard-deps: none
- persona               : hard-deps: research-note
- feature               : hard-deps: none
- requirement           : hard-deps: feature
- quality-requirement   : hard-deps: requirement
- architecture-decision : hard-deps: requirement
- user-flow             : hard-deps: requirement
- wireframe             : hard-deps: user-flow
- component-spec        : hard-deps: wireframe
- api-contract          : hard-deps: requirement; soft-deps: architecture-decision, quality-requirement
- data-model            : hard-deps: api-contract; soft-deps: architecture-decision
- test-plan             : hard-deps: none; soft-deps: requirement
- test-spec             : hard-deps: none; soft-deps: requirement, test-plan
- test-suite            : hard-deps: none; soft-deps: test-spec
- task                  : hard-deps: api-contract or component-spec (by track); soft-deps: test-spec
- task-breakdown        : hard-deps: change-request (must be applied)
- implementation-note   : hard-deps: task
- infra                 : hard-deps: task (all done), quality-requirement
- change-request        : hard-deps: target artifact
- advisory              : hard-deps: none
- milestone             : hard-deps: none; soft-deps: requirement, task

## Features
- {feature-slug}

## Modules
- {feature-slug}/{module-slug}
```

> All artifact types, features, and modules must be registered here
> before any agent can write a document using them.
> The orchestrator pre-write hook validates against this file.

---

## Artifact Ownership (RACI)

| Artifact Type         | Owner (writes)       | Consumers (reads)                              |
|-----------------------|----------------------|------------------------------------------------|
| research-note         | business-analyst     | business-analyst                               |
| persona               | business-analyst     | ux-ui-designer, business-analyst               |
| feature               | business-analyst     | all agents                                     |
| requirement           | business-analyst     | all agents                                     |
| user-flow             | ux-ui-designer       | frontend-engineer, software-architect          |
| wireframe             | ux-ui-designer       | frontend-engineer                              |
| component-spec        | ux-ui-designer       | frontend-engineer                              |
| architecture-decision | software-architect   | backend-engineer, frontend-engineer, devops    |
| quality-requirement   | software-architect   | all agents                                     |
| api-contract          | software-architect   | backend-engineer, frontend-engineer, qa        |
| data-model            | software-architect   | backend-engineer, devops-engineer, qa          |
| test-plan             | qa-engineer          | backend-engineer, frontend-engineer            |
| test-spec             | qa-engineer          | backend-engineer, frontend-engineer            |
| test-suite            | qa-engineer          | backend-engineer, frontend-engineer, devops    |
| task                  | architect / agents   | backend-engineer, frontend-engineer            |
| task-breakdown        | orchestrator         | backend-engineer, frontend-engineer            |
| implementation-note   | any agent (optional) | all agents                                     |
| infra                 | devops-engineer      | all agents                                     |
| change-request        | any agent            | artifact owner                                 |
| advisory              | orchestrator         | orchestrator, user                             |
| milestone             | orchestrator         | all agents                                     |

---

## Standard Frontmatter Schema

Every artifact note uses this frontmatter:

```markdown
---
id: {prefix}-{slug}               ← e.g. adr-jwt-vs-session, req-password-reset
type: {artifact-type}              ← must match registry
owner: {agent-slug}                ← write authority
status: {status}                   ← see lifecycle below
version: {major.minor}             ← e.g. 1.0
feature: {feature-slug}            ← must match registry
module: {feature}/{module}         ← must match registry
hard-deps:                         ← blocking upstream dependencies
  - {note-id}
soft-deps:                         ← recommended, non-blocking
  - {note-id}
refs:                              ← all links (superset of hard-deps + soft-deps)
  - {note-id}
---
```

### hard-deps vs soft-deps vs refs

```
refs      = all links from this document (superset)
hard-deps = blocking upstream deps (subset of refs)
            artifact cannot reach accepted without these existing and accepted
soft-deps = recommended upstream deps (subset of refs)
            missing soft-dep generates warning only, does not block acceptance

Every hard-dep and soft-dep must also appear in refs.
Downstream consumers appear in refs but never in hard-deps or soft-deps.
```

### Status Lifecycle

```
draft
  → ready-for-review
      → accepted          ← only if all hard-deps exist and are accepted
      → rejected          ← user rejects at gate
  → needs-review          ← upstream hard-dep changed after acceptance
      → accepted          ← re-reviewed, still consistent
      → draft             ← re-opened for revision
```

| Status           | Meaning                                                        |
|------------------|----------------------------------------------------------------|
| draft            | Agent actively working, not ready for review                   |
| ready-for-review | Agent complete, awaiting user approval                         |
| accepted         | User approved at phase gate, all hard-deps satisfied           |
| rejected         | User rejected — files may be deleted                           |
| superseded       | ADR replaced by a newer decision, kept for history             |
| deprecated       | ADR no longer applicable, kept for history                     |
| needs-review     | Upstream hard-dep changed post-acceptance, re-confirm needed   |
| published        | Implementation note complete — informational, no review needed |

**Task breakdowns** use the standard artifact lifecycle. A task-breakdown cannot reach `accepted` until its source change request is `applied`.

**Change requests** use a separate resolution lifecycle:

| Status      | Meaning                                        |
|-------------|------------------------------------------------|
| open        | Filed, awaiting artifact owner action          |
| applied     | Owner applied the change to the target         |
| rejected    | Owner rejected — reason recorded in Decision   |
| withdrawn   | Filer cancelled before owner acted             |

Rejection is terminal. If the filer disagrees, they file a new CR rather than re-opening the old one.

**Advisories** use a simple resolution lifecycle:

| Status      | Meaning                                        |
|-------------|------------------------------------------------|
| open        | Concern is active, not yet acted on            |
| resolved    | The concern was addressed                      |
| dismissed   | User consciously decided not to act            |

Both terminal states are kept as audit trail — advisories are never deleted.

**All remaining artifact types** (persona, feature, requirement, quality-requirement, user-flow, wireframe, component-spec, api-contract, data-model, research-note, infra, test-plan, test-spec, test-suite) follow the standard artifact lifecycle. Research notes must reach `accepted` before a persona can be accepted. Infra is the terminal node — it reaches `accepted` when the deployment is approved. Test-specs reach `accepted` when the QA Engineer confirms all test cases pass (Phase 4). Test-suites reach `accepted` when all included test-specs are `accepted`.

**Architecture decisions** follow the standard artifact lifecycle with two additional terminal states:

| Status      | Meaning                                        |
|-------------|------------------------------------------------|
| deprecated  | Decision no longer applicable                  |
| superseded  | Replaced by a newer ADR                        |

**Implementation notes** use a simplified lifecycle — they are optional, informational, and block nothing:

| Status      | Meaning                              |
|-------------|--------------------------------------|
| draft       | Being written                        |
| published   | Complete and readable — no review required |

---

## ID Naming Convention

```
{prefix}-{feature}-{descriptor}

Prefix map:
  rn-         research-note
  persona-    persona
  feat-       feature
  req-        requirement
  story-      story  # DEPRECATED
  milestone-  milestone
  uf-         user-flow
  wf-         wireframe
  cs-         component-spec
  adr-        architecture-decision
  api-        api-contract
  dm-         data-model
  qr-         quality-requirement
  tp-         test-plan
  ts-         test-spec
  suite-      test-suite
  task-       task
  tb-         task-breakdown
  in-         implementation-note
  infra-      infra
  cr-         change-request
  adv-        advisory

Examples:
  req-password-reset
  adr-jwt-vs-session
  task-token-generation-be
  tb-sms-fallback-implementation
  cr-api-contract-missing-rate-limit
  uf-password-reset
  wf-reset-request-screen
  cs-reset-request-form
  qr-auth-service-performance
  adv-adr-unresolved-before-contract
  tp-user-authentication
  ts-user-authentication-login
  ts-user-authentication-token-validation
  suite-user-authentication
  milestone-user-authentication-sprint-1
```

Rules:
- Lowercase, hyphen-separated only
- Prefix always first — matches registered prefix map
- No auto-incrementing integers
- No timestamps in IDs
- Descriptive enough to identify without opening the file

---

## Agent Memory Structure

Each agent has a private memory namespace not indexed by the vault.

```
/agent-memory/{agent}/
  ├── _state.md           ← current working state (1 file, overwritten each session)
  ├── _context-cache.md   ← digested summaries of consumed artifacts
  └── scratch-{task}.md   ← per-task reasoning scratchpad (deleted on task completion)

Agents:
  /agent-memory/orchestrator/
  /agent-memory/business-analyst/
  /agent-memory/ux-ui-designer/
  /agent-memory/software-architect/
  /agent-memory/qa-engineer/
  /agent-memory/backend-engineer/
  /agent-memory/frontend-engineer/
  /agent-memory/devops-engineer/
```

### _state.md fields
```markdown
---
agent: {agent-slug}
updated: {ISO datetime}
active-tasks: [{task-id}]
waiting-on: [{artifact-id}]
blocked-by: [{cr-id}]
recently-completed: [{artifact-id}]
needs-review:
  - artifact: {artifact-id}
    reason: {upstream artifact} changed on {date}
    upstream-change: {brief description}
---
```

`needs-review` is populated by the orchestrator when an upstream
hard-dep changes after this agent's artifact was already accepted.
Agent must re-confirm consistency before the artifact returns to accepted.

### scratch-{task}.md conventions
- `?`  — unresolved question, needs input before deciding
- `✗`  — option eliminated, reason preserved
- `→`  — decided direction, pending formalization

Scratch notes are never linked from artifact graph.
Deleted or archived when task completes.
Key reasoning promoted to artifact body on completion.

---

## Change Request Format

**Path:** `/vault/change-requests/cr-{name}.md`

```markdown
---
id: cr-{name}
type: change-request
status: open              ← open / applied / rejected / withdrawn
priority: minor           ← minor (non-breaking) / major (breaking)
from: {agent-slug}
to: {agent-slug}
feature: {feature-slug}
module: {feature}/{module}
created: {date}
resolved: ~

target:                   ← artifact(s) being modified (required, at least one)
  - {artifact-id}
also-affects:             ← other artifacts impacted, may move to needs-review (optional)
  - {artifact-id}
triggered-by:             ← task or artifact that discovered the gap (optional)
  - {artifact-id}
resulted-in:              ← tasks or artifacts created on resolution (filled on resolution)
  - {artifact-id}

refs:                     ← union of all typed fields above
  - {artifact-id}
---

# CR: {title}

## Problem
What is missing or incorrect in the target artifact.

## Proposed Change
Exact description of what should change.

## Justification
Which story, requirement, or constraint requires this change.

## Impact Assessment
- Breaking: yes/no
- Migration needed: yes/no
- Downstream affected: {list or none}

## Decision
<!-- filled by artifact owner on resolution -->
status: ~
reason: ~
alternative: ~
```

### Typed Relationship Fields

| Field | Required | Filled when | Purpose |
|---|---|---|---|
| `target` | Yes | CR creation | Artifact(s) being modified |
| `also-affects` | No | CR creation | Other artifacts impacted by this change |
| `triggered-by` | No | CR creation | Task or artifact that discovered the gap |
| `resulted-in` | No | CR resolution | Tasks or artifacts produced as result |
| `refs` | Yes | CR creation | Union of all typed fields — bidirectional link graph |

### target vs also-affects

```
target       → artifact owner must update this directly
also-affects → orchestrator marks these needs-review on CR resolution
               consuming agents re-confirm consistency
```

### Two-tier resolution rule

| Priority | Behavior |
|---|---|
| minor | Downstream agent proceeds optimistically. Owner has 24h window to object. Auto-applied if no response. |
| major | Hard block. Downstream agent waits for explicit owner approval. |

CRs are **never deleted** — they are permanent audit trail.

---

## Querying the Vault

All navigation is frontmatter queries — no maintained index files.

```bash
# All artifacts for a feature
grep -rl "feature: user-authentication" /vault

# All artifacts for a specific module
grep -rl "module: user-authentication/auth-service" /vault

# All architecture decisions
grep -rl "type: architecture-decision" /vault/architecture-decisions

# All draft artifacts
grep -rl "status: draft" /vault

# All artifacts in needs-review
grep -rl "status: needs-review" /vault

# All open change requests
grep -rl "status: open" /vault/change-requests

# Artifacts owned by architect for a feature
grep -rl "feature: user-authentication" /vault \
  | xargs grep -l "owner: software-architect"

# Everything tagged to a specific module
grep -rl "module: user-authentication/auth-service" /vault \
  | xargs grep -l "type: decision"

# CR queries — typed relationship fields
grep "target:" /vault/change-requests/cr-{name}.md
grep "also-affects:" /vault/change-requests/cr-{name}.md
grep "triggered-by:" /vault/change-requests/cr-{name}.md
grep "resulted-in:" /vault/change-requests/cr-{name}.md

# All CRs targeting a specific artifact
grep -rl "target:.*api-contract-auth-service" /vault/change-requests

# All CRs affecting a specific artifact (target or also-affects)
grep -rl "api-contract-auth-service" /vault/change-requests

# All tasks triggered by a specific CR
grep -rl "triggered-by:.*{cr-id}" /vault

# All tasks blocked by a specific CR
grep -rl "blocked-by:.*{cr-id}" /vault

# Full impact of a CR (all touched artifacts)
grep -E "target:|also-affects:" /vault/change-requests/cr-{name}.md

# Dep graph — what blocks this artifact from being accepted
grep "hard-deps:" /vault/architecture-decisions/adr-jwt-vs-session.md

# Dep graph — what artifacts does this one block
grep -rl "hard-deps:.*{artifact-id}" /vault

# All artifacts with unmet hard-deps (should not exist if enforcement working)
grep -rl "status: accepted" /vault \
  | xargs grep "hard-deps:" \
  | grep -v "status: accepted"
```

---

## Pre-Write Validation Hook

Before any agent writes a file, orchestrator validates:

```
On every write:
1. type       exists in _registry.md → Artifact Types
2. feature    exists in _registry.md → Features
3. module     exists in _registry.md → Modules
4. module     is scoped under correct feature (feature/module format)
5. all refs   point to existing documents
6. id         follows naming convention (type-slug format)
7. every hard-dep and soft-dep also appears in refs

On status → accepted:
8. all hard-deps exist in vault
9. all hard-deps have status: accepted
10. acyclicity — no circular hard-dep chains detected

Soft-deps missing → warn only, proceed
On failure (1–10) → reject write, surface gap to user in plain language
```

---

## Wireframe Format

Agent-generated wireframes are markdown files with ASCII art layouts.

- One file per screen
- Stored in `/wireframes/`
- Human-readable in any text editor or markdown viewer
- ASCII layout drawn inside fenced code blocks
- Referenced from component specs via `refs` link
- Not stored in Figma or external tools

## User Flow Format

User flows are markdown files with embedded Mermaid diagrams.

- Stored in `/user-flows/`
- Mermaid renders natively in Obsidian, GitHub, Notion
- Covers happy path, error paths, exit points
- Referenced by component specs and stories

## Impl Notes (Optional)

Impl notes are **not required** per task.
Tasks carry their own implementation notes section (filled on completion).
Impl notes are only created for **cross-cutting insights** spanning multiple tasks.
