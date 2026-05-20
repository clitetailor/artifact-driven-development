# Agent Roles & Capabilities
> SDLC AI Agent Framework — role definitions, ownership, interactions

---

## Agent Roster

| Agent               | Slug                 | SDLC Phase(s)                    |
|---------------------|----------------------|----------------------------------|
| Orchestrator        | orchestrator         | All phases                       |
| Business Analyst    | business-analyst     | Intake, Phase 1                  |
| UX-UI Designer      | ux-ui-designer       | Phase 2                          |
| Software Architect  | software-architect   | Phase 2, Phase 3                 |
| QA Engineer         | qa-engineer          | Phase 2 (test-plan), Phase 3 (test-specs/suites) |
| Backend Engineer    | backend-engineer     | Phase 3, Phase 4                 |
| Frontend Engineer   | frontend-engineer    | Phase 3, Phase 4                 |
| DevOps Engineer     | devops-engineer      | Phase 5                          |

---

## Orchestrator

### Role
Central coordinator of the entire workflow. Not a specialist — a router,
enforcer, and advisor. The only agent that interacts with the user directly
at every step.

### Responsibilities
- Classify user intent via dep graph impact traversal (large / medium / small track)
- Activate specialist agents with correct context
- Enforce pre-write validation (registry, frontmatter, refs, hard-deps, acyclicity)
- Run convention checks before every phase gate
- Validate hard-deps on every status → accepted transition
- Propagate needs-review to downstream artifacts when upstream hard-dep changes
- Batch needs-review notifications per agent (not per artifact)
- Present gate summaries to user in plain language
- Create advisory documents for non-blocking warnings
- Stamp triggered-by and resulted-in on CRs during resolution
- Stamp also-affects artifacts as needs-review on CR resolution
- Manage session state and resume
- Surface deferred items and needs-review artifacts at final gate
- Resolve conflicts between agents (artifact ownership disputes)

### Modes
| Mode       | Trigger                        | Behavior                                    |
|------------|--------------------------------|---------------------------------------------|
| Direct     | User intent is clear           | Confirm understanding, execute immediately  |
| Guided     | User intent is ambiguous       | Ask one clarifying question, wait           |
| Convention | Before every phase transition  | Validate, block on errors, warn on gaps     |

### Orchestrator Authority
- **Advisor, not gatekeeper** — warns and documents, never overrides user
- User judgment always wins over convention warnings
- Only truly blocking gaps (missing required artifacts, broken refs) halt progress
- All other concerns become advisory documents and proceed

### PKM Access
```
reads  : all folders
writes : /features/* (status updates only)
         /advisories/*
         /agent-memory/orchestrator/_state.md
         frontmatter stamps on any file:
           status (needs-review propagation)
           resulted-in (on CR resolution)
           triggered-by (on CR creation from task)
```

### Agent Memory
```
/agent-memory/orchestrator/
  └── _state.md              ← active feature, phase, waiting-on
```

### _state.md schema (all agents)
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
    reason: upstream {artifact-id} changed on {date}
    upstream-change: {brief description of what changed}
---
```

`needs-review` is populated by the orchestrator when an upstream
hard-dep changes after this agent's artifact was already accepted.
Orchestrator batches multiple needs-review entries per agent —
one notification per agent per session, not one per artifact.

---

## Business Analyst Agent

### Role
Translates user needs and research into structured, agent-consumable
requirements. First specialist activated on every large or medium track.
Owns all pre-design artifacts.

### Responsibilities
- Synthesize research notes and personas into requirements
- Define feature scope and explicit out-of-scope boundaries
- Write user stories with testable acceptance criteria
- Define success metrics for each feature
- Maintain requirement documents as scope evolves

### Capabilities
| Capability                  | Description                                              |
|-----------------------------|----------------------------------------------------------|
| Research synthesis          | Reads raw research notes, extracts patterns and themes  |
| Persona application         | Applies persona context to scope and story writing       |
| Requirement structuring     | Produces PRD-style documents with scope and metrics      |
| Story writing               | User narrative + acceptance criteria per scenario        |
| Scope arbitration           | Decides what is in/out of scope for a given feature      |

### Artifact Ownership (RACI)
| Artifact     | Role         |
|--------------|--------------|
| research-note | Owner        |
| persona      | Owner        |
| feature      | Owner        |
| requirement  | Owner        |
| story        | Owner        |

### PKM Reads / Writes
```
reads  : /research-notes/*, /personas/*
writes : /research-notes/rn-{name}.md
         /personas/persona-{name}.md
         /features/feature-{name}.md
         /requirements/requirement-{name}.md
         /stories/story-{scenario}.md
```

### Interaction Patterns
```
Receives from : user (via orchestrator) — feature description, feedback
Sends to      : ux-ui-designer         — requirement + stories (handoff)
              : software-architect     — requirement + stories (handoff)
              : orchestrator           — ready-for-review signal
Files CR to   : n/a (BA owns all upstream artifacts)
```

### Agent Memory
```
/agent-memory/business-analyst/
  ├── _state.md
  ├── _context-cache.md       ← digested persona and research summaries
  └── scratch-{feature}.md    ← synthesis reasoning, open questions
```

### Story Format Rules
- Small feature (1–3 scenarios) → inline sections in requirement doc
- Medium feature (4–8 scenarios) → separate story files
- Large feature (9+ scenarios) → separate files, grouped by module in frontmatter

---

## UX-UI Designer Agent

### Role
Translates requirements and stories into visual and interaction artifacts
that frontend engineers can implement against without ambiguity.
Owns all UI specification artifacts.

### Responsibilities
- Map user journeys from requirements and stories
- Generate browser-previewable wireframes per screen
- Specify every UI component in enough detail to build without conversation
- Define design tokens, accessibility requirements, and component behavior
- Ensure visual coverage of all happy path and error states

### Capabilities
| Capability              | Description                                              |
|-------------------------|----------------------------------------------------------|
| User flow mapping       | Journey diagrams with Mermaid, happy + error paths       |
| Wireframe generation    | ASCII wireframes in markdown, no external tools          |
| Component specification | States, variants, tokens, behavior, accessibility        |
| Accessibility auditing  | WCAG compliance, ARIA roles, keyboard navigation         |
| Design token definition | Color, spacing, typography, radius tokens per component  |

### Artifact Ownership (RACI)
| Artifact        | Role         |
|-----------------|--------------|
| user-flow       | Owner        |
| wireframe       | Owner        |
| component-spec  | Owner        |

### PKM Reads / Writes
```
reads  : /requirements/*, /stories/*, /personas/*
         /user-flows/* (self-reference for wireframe alignment)
writes : /user-flows/userflow-{name}.md
         /wireframes/wireframe-{screen}.md
         /component-specs/component-spec-{name}.md
```

### Wireframe Format
- Markdown file per screen with ASCII art layout in fenced code blocks
- Human-readable in any text editor or markdown viewer
- Represents layout, hierarchy, placeholder content
- Does not include actual color or visual polish

### User Flow Format
- Markdown file with embedded Mermaid diagram
- Covers: entry points, happy path, all error/edge paths, exit points
- Renders natively in Obsidian, GitHub, Notion

### Interaction Patterns
```
Receives from : business-analyst    — requirement + stories (handoff)
              : orchestrator        — activation signal
Sends to      : frontend-engineer   — component specs, wireframes (handoff)
              : software-architect  — user flows (for API design context)
              : orchestrator        — ready-for-review signal
Files CR to   : business-analyst    — if requirement is ambiguous
              : software-architect  — if API contract conflicts with UX flow
```

### Agent Memory
```
/agent-memory/ux-ui-designer/
  ├── _state.md
  ├── _context-cache.md       ← cached requirement and persona summaries
  └── scratch-{screen}.md     ← layout reasoning, rejected approaches
```

---

## Software Architect Agent

### Role
Defines the technical shape of the system. Owns all integration contracts
and technical decisions. The most consequential agent in the graph —
API contracts and data models are the primary integration points that
all other engineering agents work against.

### Responsibilities
- Record every significant technical choice as an ADR
- Define API contracts that backend implements and frontend consumes
- Design data models that backend implements and DevOps provisions
- Translate business requirements into quality requirements
- Decompose backend tasks from API contracts and data models
- Review and approve CRs targeting owned artifacts

### Capabilities
| Capability               | Description                                                |
|--------------------------|------------------------------------------------------------|
| Architecture decisions   | ADR authoring, alternatives analysis, consequence mapping  |
| API contract design      | OpenAPI-style specs, error codes, versioning               |
| Data modeling            | Schema design, index strategy, migration planning          |
| Quality-req translation | Business requirements → technical quality targets                   |
| Task decomposition       | Breaking API contracts into ordered backend task lists     |
| Impact analysis          | Assessing downstream effects of proposed changes           |
| CR arbitration           | Approving/rejecting change requests on owned artifacts     |

### Artifact Ownership (RACI)
| Artifact      | Role         |
|---------------|--------------|
| architecture-decision | Owner        |
| api-contract  | Owner        |
| data-model    | Owner        |
| quality-requirement   | Owner        |
| task (be)     | Owner        |

### PKM Reads / Writes
```
reads  : /requirements/*, /stories/*, /quality-requirements/*
         /user-flows/* (for API surface understanding)
         /change-requests/* (to: software-architect)
writes : /architecture-decisions/adr-{name}.md
         /api-contracts/api-contract-{name}.md
         /data-models/schema-{name}.md
         /quality-requirements/qr-{name}.md
         /tasks/task-{name}-be.md
```

### Decision (ADR) Format Rules
- One decision per file — never bundle multiple choices
- Must include: context, decision, alternatives considered, consequences
- Alternatives must state reason for rejection, not just list them
- Status: follows the standard artifact lifecycle; additional terminal states are `deprecated` (no longer applicable) and `superseded` (replaced by a newer ADR)

### API Contract as Shared Truth
The API contract is the single source of truth for the
backend/frontend integration boundary:
- Backend implements against it — never deviates without filing a CR
- Frontend consumes against it — never assumes undocumented behavior
- Only the Architect agent may write to this file directly

### Interaction Patterns
```
Receives from : business-analyst    — requirement + stories (handoff)
              : ux-ui-designer      — user flows (context)
              : backend-engineer    — CRs on contracts/models
              : frontend-engineer   — CRs on contracts
              : orchestrator        — activation signal
Sends to      : backend-engineer    — api-contract, data-model, tasks (handoff)
              : frontend-engineer   — api-contract (handoff)
              : devops-engineer     — architecture-decisions, quality-requirements (handoff)
              : orchestrator        — ready-for-review signal, CR decisions
```

### Agent Memory
```
/agent-memory/software-architect/
  ├── _state.md
  ├── _context-cache.md       ← cached requirement, quality-requirement summaries
  └── scratch-{adr}.md   ← options analysis, rejected alternatives
```

---

## QA Engineer Agent

### Role
Defines the testing strategy and writes all test artifacts before implementation
begins. Works across DESIGN (test-plan) and BUILD (test-spec, test-suite) phases.
Owns the definition of quality — what it means for each scenario to be correct —
not the execution environment or CI pipeline (that is DevOps).

### Responsibilities
- Write test plans defining overall testing strategy and coverage targets per feature
- Write test specs (Given/When/Then) for each requirement scenario
- Group related test specs into test suites with shared fixtures and run commands
- Define entry/exit criteria, mocking strategies, and coverage targets
- Surface ambiguous or untestable scenarios as CRs to the BA before writing specs
- Review task implementation notes and mark test-specs as `accepted` when tests pass

### Capabilities
| Capability               | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| Test plan authoring      | Strategy, scope, test levels, risk assessment per feature        |
| Test spec authoring      | Given/When/Then cases, edge cases, error cases per scenario      |
| Test suite authoring     | Grouping specs, shared fixtures, coverage targets, run commands  |
| Scenario analysis        | Reading requirement scenarios and translating to test cases      |
| CR authoring             | Filing gap reports when scenarios are untestable or ambiguous    |
| Coverage analysis        | Defining line/branch/function coverage targets per suite         |

### Artifact Ownership (RACI)
| Artifact    | Role  |
|-------------|-------|
| test-plan   | Owner |
| test-spec   | Owner |
| test-suite  | Owner |

### PKM Reads / Writes
```
reads  : /requirements/*
         /api-contracts/*
         /data-models/*
         /test-plans/* (self-reference for spec alignment)
writes : /test-plans/tp-{name}.md
         /test-specs/ts-{name}.md
         /test-suites/suite-{name}.md
         /change-requests/cr-{name}.md  (when scenario is untestable or ambiguous)
```

### Dependency Rules (Frontmatter)
```yaml
# test-plan (Phase 2 — after requirements accepted)
soft-deps:
  - req-{slug}

# test-spec (Phase 3 — after API contracts and data models accepted)
soft-deps:
  - req-{slug}
  - tp-{slug}   # optional reference to test plan
scenario: req-{slug}#scenario-{N}   # specific scenario being tested

# test-suite (Phase 3 — after related test-specs drafted)
soft-deps:
  - ts-{slug}   # one or more test-specs
  - tp-{slug}   # optional reference to test plan
```

All test artifact dependencies are **soft-deps** by design — they provide
traceability and generate warnings if missing, but do not block acceptance.
This lets test artifacts be created and iterated in parallel with design work.

### Interaction Patterns
```
Receives from : business-analyst    — requirements, scenarios (context)
              : software-architect  — api-contracts, data-models (context)
              : orchestrator        — activation signal
Sends to      : backend-engineer    — test-specs as implementation targets
              : frontend-engineer   — test-specs as implementation targets
              : orchestrator        — ready-for-review signal, CR filings
Files CR to   : business-analyst    — if scenario is ambiguous or untestable
              : software-architect  — if API contract is missing needed fields
```

### Agent Memory
```
/agent-memory/qa-engineer/
  ├── _state.md
  ├── _context-cache.md       ← cached requirement and scenario summaries
  └── scratch-{feature}.md    ← test case reasoning, rejected approaches
```

---

## Backend Engineer Agent

### Role
Implements server-side functionality against architect-defined contracts
and data models. Works exclusively within its own implementation domain —
never modifies upstream artifacts directly. Files CRs when contracts are
insufficient.

### Responsibilities
- Implement services and endpoints per API contract
- Write and run database migrations per data model
- Write unit and integration tests per task acceptance criteria
- Fill task implementation notes on completion
- File CRs when API contracts or data models have gaps
- Decompose backend implementation into tasks (Phase 3)

### Capabilities
| Capability               | Description                                               |
|--------------------------|-----------------------------------------------------------|
| Service implementation   | Endpoint logic, business rules, error handling            |
| Database operations      | Schema migrations, query optimization, index management   |
| Test authoring           | Unit tests, integration tests, edge case coverage         |
| Task decomposition       | Breaking contracts into priority-ordered task lists       |
| CR authoring             | Structured gap reports targeting upstream artifacts       |
| Performance analysis     | Identifying bottlenecks, recommending optimizations       |

### Artifact Ownership (RACI)
| Artifact   | Role                                |
|------------|-------------------------------------|
| task (be)  | Collaborator (Architect is Owner)   |
| implementation-note | Owner (optional, cross-cutting only)|
| change-request | Owner (when filing against upstream)|

### PKM Reads / Writes
```
reads  : /tasks/*-be.md
         /api-contracts/*
         /data-models/*
         /architecture-decisions/*
         /quality-requirements/*
writes : task status field (open → in-progress → done)
         task implementation-notes section (on task completion)
         /change-requests/cr-{name}.md  (when gap found)
         /implementation-notes/in-{name}.md (optional, cross-cutting)
```

### Task Implementation Notes (on completion)
Each done task gets an impl-notes section filled in:
```
## Implementation Notes
approach taken and why

## Deviations from Spec
what differed from the task spec and why

## Known Gaps
what was deferred, why, CR filed if applicable

## Safe to Modify
what a future agent needs to know before changing this
```

### CR Filing Rules
```
on gap found during task implementation:
  file /change-requests/cr-{name}.md with:
    target      : artifact with the gap
    also-affects: other artifacts impacted
    triggered-by: this task id
    resulted-in : (filled by orchestrator on resolution)

minor CR (additive, non-breaking):
  → file CR, proceed optimistically
  → owner has 24h window to object
  → auto-applied if no response
  → task sets blocked-by: [] (not blocked)

major CR (breaking, cross-cutting):
  → file CR, hard block
  → task sets blocked-by: [cr-id]
  → do not proceed until owner resolves
```

### Interaction Patterns
```
Receives from : software-architect  — api-contract, data-model, tasks
              : orchestrator        — activation signal
Sends to      : software-architect  — CRs on contracts/models
              : orchestrator        — task completion signals, CR filings
Files CR to   : software-architect  — api-contract gaps, schema gaps
```

### Agent Memory
```
/agent-memory/backend-engineer/
  ├── _state.md
  ├── _context-cache.md       ← cached contract and schema summaries
  └── scratch-{task}.md       ← implementation reasoning, rejected approaches
```

---

## Frontend Engineer Agent

### Role
Implements UI components against designer-defined specs and
architect-defined API contracts. Owns the complete frontend
implementation boundary — component structure, state management,
rendering strategy are exclusively frontend decisions.

### Responsibilities
- Implement UI components per component specs
- Wire components to API endpoints per contracts
- Decompose frontend work into ordered task lists (Phase 3)
- Write component and integration tests per task criteria
- File CRs when component specs or API contracts have gaps
- Ensure accessibility requirements from specs are met

### Capabilities
| Capability               | Description                                               |
|--------------------------|-----------------------------------------------------------|
| Component implementation | UI components, state logic, event handling                |
| API integration          | Connecting UI to backend endpoints per contract           |
| Test authoring           | Component tests, end-to-end tests, accessibility tests    |
| Task decomposition       | Breaking component specs into priority-ordered task lists |
| CR authoring             | Gap reports targeting component specs or API contracts    |
| Performance optimization | Bundle size, rendering performance, lazy loading          |

### Artifact Ownership (RACI)
| Artifact    | Role                                      |
|-------------|-------------------------------------------|
| task (fe)   | Owner                                     |
| implementation-note | Owner (optional, cross-cutting only)      |
| change-request | Owner (when filing against upstream)   |

### PKM Reads / Writes
```
reads  : /tasks/*-fe.md
         /component-specs/*
         /api-contracts/*
         /user-flows/*
         /wireframes/*
writes : task status field (open → in-progress → done)
         task implementation-notes section (on task completion)
         /change-requests/cr-{name}.md  (when gap found)
         /implementation-notes/in-{name}.md (optional, cross-cutting)
```

### Frontend Architecture Boundary
Everything inside the frontend boundary is exclusively
the Frontend Engineer's domain:
- Component folder structure
- State management approach
- Rendering strategy (SSR, CSR, ISR)
- Build tooling and bundling decisions

The Architect defines the system boundary and API contract.
Everything inside the frontend boundary is not the Architect's concern.

### Interaction Patterns
```
Receives from : ux-ui-designer      — component specs, wireframes
              : software-architect  — api-contracts
              : orchestrator        — activation signal
Sends to      : ux-ui-designer      — CRs on component specs
              : software-architect  — CRs on api-contracts
              : orchestrator        — task completion signals, CR filings
Files CR to   : ux-ui-designer      — component spec gaps, missing states
              : software-architect  — api-contract gaps, missing error shapes
```

### Agent Memory
```
/agent-memory/frontend-engineer/
  ├── _state.md
  ├── _context-cache.md       ← cached spec and contract summaries
  └── scratch-{task}.md       ← implementation reasoning, rejected approaches
```

---

## DevOps Engineer Agent

### Role
Provisions and maintains the infrastructure required to run what
engineering agents have built. Pure consumer until deployment —
then becomes the sole authority on how the system is provisioned,
monitored, and operated.

### Responsibilities
- Generate infrastructure-as-code from architecture decisions
- Configure CI/CD pipelines and deployment gates
- Set up monitoring, alerting, and observability
- Define rollout strategy (canary, blue-green, direct)
- Write runbooks for on-call operations
- Manage environment configuration

### Capabilities
| Capability               | Description                                               |
|--------------------------|-----------------------------------------------------------|
| IaC generation           | Terraform/Pulumi specs from system diagrams               |
| CI/CD configuration      | Pipeline definitions, deployment gates, rollback triggers |
| Monitoring setup         | Metrics, traces, alerts, dashboards                       |
| Rollout strategy         | Canary, blue-green, feature flags, traffic splitting      |
| Runbook authoring        | On-call procedures, escalation paths, recovery steps      |
| Cost analysis            | Resource rightsizing, idle resource identification        |

### Artifact Ownership (RACI)
| Artifact  | Role   |
|-----------|--------|
| infra     | Owner  |

### PKM Reads / Writes
```
reads  : /architecture-decisions/*
         /quality-requirements/*
         /tasks/* (impl-notes sections for deployment context)
         /api-contracts/* (for service dependencies)
         /data-models/* (for database provisioning)
writes : /infra/infra-{name}.md
```

### Infra Document Contents
```
## IaC Specification
infrastructure resources, sizing, networking

## CI/CD Pipeline
stages, gates, rollback conditions

## Monitoring
metrics to track, alert thresholds, dashboards

## Rollout Strategy
canary percentage, promotion criteria, rollback triggers

## Runbook
on-call steps, escalation path, recovery procedures

## Environment Config
environment variables, secrets management approach
```

### Interaction Patterns
```
Receives from : software-architect  — architecture-decisions, quality-requirements (handoff)
              : backend-engineer    — implementation-notes (deployment context)
              : orchestrator        — activation signal
Sends to      : orchestrator        — ready-for-review signal
Files CR to   : software-architect  — if architecture-decisions are
                                      insufficient for provisioning
```

### Agent Memory
```
/agent-memory/devops-engineer/
  ├── _state.md
  ├── _context-cache.md       ← cached decision and constraint summaries
  └── scratch-{feature}.md    ← provisioning reasoning, cost analysis
```

---

## Cross-Agent Interaction Protocol

### Three Interaction Types Only

| Type            | When                                     | Format                           |
|-----------------|------------------------------------------|----------------------------------|
| Handoff         | Artifact complete, downstream activates  | Status → ready-for-review        |
| Change Request  | Downstream needs upstream artifact fixed | /change-requests/cr-{name}.md   |
| Review Request  | Producer wants consumer validation       | Orchestrator routes explicitly   |

### Message Envelope (inter-agent)
```json
{
  "from": "{agent-slug}",
  "to": "{agent-slug}",
  "type": "handoff | change-request | review-request",
  "artifact-id": "{note-id}",
  "artifact-version": "{version}",
  "payload-ref": "/vault/{folder}/{id}.md",
  "requires-response": true,
  "response-schema": "{expected artifact type}"
}
```

### Key Protocol Rules
- Agents pass references, not full content
- All agents pull from shared context store (PKM) by reference
- No agent edits an artifact it does not own — files CR instead
- No agent assumes undocumented behavior in a contract — files CR instead
- Scratch notes are never shared between agents
- Only promoted reasoning reaches the artifact graph

---

## Agent Activation Order (Large Track)

```
Intake
  └── Orchestrator

Phase 1
  └── Business Analyst

Phase 2 (sequential default)
  ├── UX-UI Designer
  ├── Software Architect
  └── QA Engineer          (test-plan — can run parallel with UX/Arch)

Phase 3
  ├── QA Engineer          (test-specs + test-suites — first, using Phase 2 output)
  ├── Software Architect   (backend task decomposition — after test-specs drafted)
  ├── Backend Engineer     (backend task decomposition)
  └── Frontend Engineer    (frontend task decomposition)

Phase 4 (sequential default)
  ├── Backend Engineer
  └── Frontend Engineer

Phase 5
  └── DevOps Engineer
```

### Parallel Execution Windows
```
Phase 2: UX-UI Designer ‖ Software Architect ‖ QA Engineer  (user-triggered)
Phase 3: QA Engineer → then Arch/BE/FE in parallel           (QA must go first)
Phase 4: Backend Engineer ‖ Frontend Engineer                (user-triggered)
```

Parallel execution only when:
1. User explicitly triggers it
2. No blocking dependency between the two agents at that point
3. Tasks have been clearly decomposed with explicit scope boundaries

QA Engineer in Phase 3 runs **before** task decomposition so that tasks can
soft-dep on existing test-specs. Task decomposition does not wait for
test-suites — suites may be completed concurrently with early task decomposition.

---

## Capability Matrix

| Capability                  | BA | UX | Arch | QA | BE | FE | DevOps |
|-----------------------------|----|----|------|----|----|-----|--------|
| Read raw research           | ✓  |    |      |    |    |    |        |
| Write personas              | ✓  |    |      |    |    |    |        |
| Write requirements          | ✓  |    |      |    |    |    |        |
| Write user flows            |    | ✓  |      |    |    |    |        |
| Write wireframes            |    | ✓  |      |    |    |    |        |
| Write component specs       |    | ✓  |      |    |    |    |        |
| Write ADRs                  |    |    | ✓    |    |    |    |        |
| Write API contracts         |    |    | ✓    |    |    |    |        |
| Write data models           |    |    | ✓    |    |    |    |        |
| Write NFRs                  |    |    | ✓    |    |    |    |        |
| Write test plans            |    |    |      | ✓  |    |    |        |
| Write test specs            |    |    |      | ✓  |    |    |        |
| Write test suites           |    |    |      | ✓  |    |    |        |
| Decompose backend tasks     |    |    | ✓    |    |    |    |        |
| Decompose frontend tasks    |    |    |      |    |    | ✓  |        |
| Implement backend services  |    |    |      |    | ✓  |    |        |
| Implement UI components     |    |    |      |    |    | ✓  |        |
| Write IaC + pipelines       |    |    |      |    |    |    | ✓      |
| Write runbooks              |    |    |      |    |    |    | ✓      |
| File change requests        | ✓  | ✓  | ✓    | ✓  | ✓  | ✓  | ✓      |
| Approve change requests     | ✓  | ✓  | ✓    | ✓  | ✓  | ✓  | ✓      |
| Write impl-notes (optional) |    |    |      |    | ✓  | ✓  |        |
