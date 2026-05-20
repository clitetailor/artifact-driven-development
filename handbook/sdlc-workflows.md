# SDLC Agent Workflow
> Full reference — large feature, medium, and small/change request tracks

---

## Actors

| Actor        | Role                                                                 |
|--------------|----------------------------------------------------------------------|
| User         | Initiates work, approves/refines/rejects at gates, natural language |
| Orchestrator | Routes tasks, enforces conventions, guides when needed, stamps PKM  |
| Agents       | Produce artifacts within their ownership domain                      |
| PKM          | Passive storage — status fields as state, filesystem as rollback     |

---

## Orchestrator Modes

| Mode       | When                              | Behavior                                          |
|------------|-----------------------------------|---------------------------------------------------|
| Direct     | User knows what they want         | Confirm understanding, execute                    |
| Guided     | User unsure of next step          | Propose next step, explain why, wait              |
| Convention | Before every phase transition     | Validate completeness, block or warn accordingly  |

---

## Convention Check Rules

```
Blocking  → must resolve before proceeding
  - Required artifact for this phase is completely missing
  - Frontmatter missing a required field
  - Refs link to non-existent document
  - Artifact type not in registry
  - Hard-dep does not exist in vault
  - Hard-dep exists but status is not accepted
  - Circular dependency detected in hard-dep chain

Warning   → create advisory, proceed
  - Soft-dep missing or still in draft
  - Related decision not yet accepted
  - Downstream artifact may conflict with unresolved item
```

On warning — orchestrator creates:
`/advisories/adv-{concern}.md`

Status blockers are enforced by default. The orchestrator may bypass a status-based blocker only when the user explicitly instructs the agent to skip, bypass, or proceed without waiting for the blocking status to change. Bypassing a blocker does not imply changing the artifact status automatically.

---

## Gate Outcomes

At every phase gate the user has four options:

| Outcome              | What happens                                                         |
|----------------------|----------------------------------------------------------------------|
| approve              | Artifacts → accepted. Orchestrator proposes next phase.              |
| refine [feedback]    | Agent revises in same session. Re-presents at same gate.             |
| reject + delete      | User deletes related files. Orchestrator detects, restarts phase.    |
| proceed with concern | Orchestrator warns, user proceeds. Advisory created in `/advisories/`.|

`proceed with concern` may be used to bypass a status-based blocker only on explicit user instruction. The orchestrator should record the bypass as a concern and continue without auto-promoting the blocking artifact.

### needs-review Re-Review Flow

Triggered when an already-accepted artifact's upstream hard-dep changes:

```
upstream artifact changes post-acceptance
  → orchestrator traverses forward through hard-dep graph
  → finds downstream accepted artifacts
  → marks them status: needs-review
  → stamps needs-review section in owning agent _state.md
  → surfaces at next session or gate:
      "adr-reset-token-strategy needs review —
       requirement-password-reset scope changed on 2026-05-03"

User decides:
  → re-review now  : agent checks consistency, re-submits for approval
  → defer          : stays needs-review, recorded as open item
                     surfaced again at final gate (Phase 5)
```

---

## Track Selection

```
User describes work in natural language
              │
              ▼
       Orchestrator identifies entry point artifact
       Traverses dependency graph — counts affected layers
              │
      ┌───────┼────────┐
      ▼       ▼        ▼
  1–2 layers  3–4    5+ layers
  affected    layers  affected
      │       affected    │
      ▼           │       ▼
  Small Track     ▼   Large Track
  (CR only,   Medium   (full SDLC)
   one gate)   Track
              (partial
               SDLC)
```

Track is determined by impact depth — not manual classification.
Orchestrator traverses the dep graph from the entry point artifact
and counts how many artifact layers are affected downstream.

| Impact depth | Track | Entry point |
|---|---|---|
| 1–2 layers | Small — CR only, one gate | Specific artifact (e.g. component-spec) |
| 3–4 layers | Medium — partial SDLC | Requirement or design artifact |
| 5+ layers | Large — full SDLC | Feature or requirement (new capability) |

---

## LARGE FEATURE TRACK

Full waterfall SDLC from discovery to deployment.
User triggers each phase explicitly and approves at every gate.

---

### INTAKE

```
┌─────────────────────────────────────────────────────────────────────┐
│  INTAKE                                                              │
└─────────────────────────────────────────────────────────────────────┘
│
├─[USER]  Describes feature in natural language
│         No commands or structure required
│
├─[ORCH]  Classifies intent → large feature track
│         Scans PKM for related personas, research, features
│         reads : /features, /research, /personas
│
├─[ORCH]  Confirms understanding with user
│           direct mode  → clear intent, reflects back, proceeds
│           guided mode  → ambiguous, asks one clarifying question
│         writes: /features/feature-{name}.md
│
▼
```

---

### PHASE 1 — Discovery & Requirements
**Agent:** Business Analyst

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 1 — Discovery & Requirements          [Business Analyst]      │
└─────────────────────────────────────────────────────────────────────┘
│
├─[ORCH]  Activates BA Agent
│         Loads context: /research-notes/*, /personas/*
│
├─[AGNT]  BA drafts requirement document
│         reads  : /research-notes/*, /personas/*
│         writes : /requirements/req-{name}.md
│           └── scope, out-of-scope, user context, success metrics
│
├─[AGNT]  BA writes stories when scenario-level decomposition is needed
│         reads  : /requirements/req-{name}.md
│         writes : /stories/story-{scenario}.md  (optional)
│           ├── default        → keep acceptance criteria in requirement doc
│           └── when needed    → create separate story files for scenarios that
│                                need extra traceability or independent review
│         each story contains:
│           └── user narrative (as a / I want / so that)
│               acceptance criteria (testable conditions)
│
├─[ORCH]  Convention check
│           ✓ frontmatter complete and registry-valid
│           ✓ all refs resolve
│           ✓ acceptance criteria present in requirement or story artifacts
│           ✓ scope and out-of-scope both defined
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE 1                                                             ║
║  Orchestrator presents: requirement summary + optional story list   ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼
```

---

### PHASE 2 — Design
**Agents:** UX-UI Designer + Software Architect
**Sequencing:** Sequential by default. Parallel on user request.

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 2 — Design              [UX-UI Designer + Architect]          │
└─────────────────────────────────────────────────────────────────────┘
│
├─[USER]  Chooses sequencing
│           sequential : UX completes → Architect uses UX output
│           parallel   : both start simultaneously (user-triggered)
│
│  ── UX-UI DESIGNER ──────────────────────────────────────────────
│
├─[AGNT]  UX — user flows
│         reads  : /requirements/*, /stories/*, /personas/*
│         writes : /user-flows/userflow-{name}.md
│           └── embedded Mermaid diagram
│               happy path + all error/edge paths
│               entry points, exit points
│
├─[AGNT]  UX — wireframes
│         reads  : /user-flows/*
│         writes : /wireframes/wireframe-{screen}.html
│           └── one self-contained HTML file per screen
│               human-previewable in any browser
│               no external tools required
│
├─[AGNT]  UX — component specs
│         reads  : /wireframes/*
│         writes : /component-specs/component-spec-{name}.md
│           └── states (default, hover, loading, error, disabled)
│               variants, behavior, design tokens, accessibility
│               refs wireframe and user flow
│
│  ── SOFTWARE ARCHITECT ──────────────────────────────────────────
│
├─[AGNT]  Architect — decisions (ADRs) when the technical choice is significant
│         reads  : /requirements/*, /quality-requirements/*
│         writes : /architecture-decisions/adr-{name}.md  (optional)
│           └── context, decision, alternatives rejected, consequences
│               one decision per file
│
├─[AGNT]  Architect — API contracts
│         reads  : /requirements/*, /stories/*, /architecture-decisions/*
│         writes : /api-contracts/api-contract-{name}.md
│           └── endpoints, request/response shapes, error codes
│               references relevant ADRs when they exist
│
├─[AGNT]  Architect — data models
│         reads  : /api-contracts/*, /architecture-decisions/*
│         writes : /data-models/schema-{name}.md
│           └── schema, indexes, migration notes
│
├─[AGNT]  Architect — constraints (NFRs)
│         reads  : /requirements/*
│         writes : /constraints/qr-{name}.md
│           └── latency targets, uptime SLAs
│               scalability limits, security requirements
│
├─[ORCH]  Convention check + warn
│           ✓ wireframe exists for each screen in user flow
│           ✓ component spec exists for each wireframe
│           ✓ ADRs exist for significant technical choices
│           ✓ API contract refs relevant ADRs when present
│           ✓ data model refs API contract
│           ✓ all refs resolve
│           ⚠ warnings → /advisories/adv-{x}.md
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE 2                                                             ║
║  Presents all UX artifacts + architecture artifacts                 ║
║  Warnings flagged clearly alongside artifacts                       ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼
```

---

### PHASE 3 — Task Decomposition
**Agents:** Architect + Backend Engineer + Frontend Engineer

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 3 — Task Decomposition  [Architect + Backend + Frontend]      │
└─────────────────────────────────────────────────────────────────────┘
│
├─[AGNT]  Architect decomposes backend tasks
│         reads  : /api-contracts/*, /data-models/*, /requirements/*, /stories/*
│         writes : /tasks/task-{name}-be.md  (one per task)
│           each task contains:
│             priority    : tier number (1 = first)
│             depends-on  : [task-id, ...]
│             scope       : what is included / excluded
│             criteria    : testable acceptance conditions
│
├─[AGNT]  Frontend decomposes frontend tasks
│         reads  : /component-specs/*, /api-contracts/*
│         writes : /tasks/task-{name}-fe.md  (one per task)
│           same structure as backend tasks
│
├─[ORCH]  Builds dependency graph from depends-on fields
│         Groups tasks into priority tiers per track:
│
│         Backend track:
│           tier 1 → [task-a, task-b]         ← no dependencies
│           tier 2 → [task-c, task-d]         ← depends on tier 1
│           tier 3 → [task-e]                 ← depends on tier 2
│
│         Frontend track:
│           tier 1 → [task-f, task-g, task-h] ← no dependencies
│           tier 2 → [task-i]                 ← depends on tier 1
│           tier 3 → [task-j]                 ← depends on tier 2
│
│         Same-tier tasks within a track can run in parallel
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE 3                                                             ║
║  Presents task board: backend + frontend tracks with tiers          ║
║  User may add, remove, or adjust tasks before approving             ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼
```

---

### PHASE 4 — Implementation
**Agents:** Backend Engineer + Frontend Engineer
**Sequencing:** Sequential by default. Parallel on user request.

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 4 — Implementation      [Backend Engineer + Frontend Eng.]    │
└─────────────────────────────────────────────────────────────────────┘
│
├─[USER]  Triggers implementation
│           sequential : backend → frontend  (default, lower token cost)
│           parallel   : both simultaneously (user-triggered)
│
│  ── BACKEND ENGINEER ────────────────────────────────────────────
│
├─[AGNT]  Implements backend tasks tier by tier
│         reads  : /tasks/*-be.md, /api-contracts/*
│                  /data-models/*, /architecture-decisions/*
│         writes : task status (open → in-progress → done)
│                  task implementation-notes section on completion
│           └── implementation-notes section covers:
│               approach taken, deviations from spec
│               known gaps, safe-to-modify notes
│
│  ── FRONTEND ENGINEER ───────────────────────────────────────────
│
├─[AGNT]  Implements frontend tasks tier by tier
│         reads  : /tasks/*-fe.md, /component-specs/*
│                  /api-contracts/*
│         writes : task status (open → in-progress → done)
│                  task implementation-notes section on completion
│
│  ── BOTH AGENTS ─────────────────────────────────────────────────
│
├─[AGNT]  Files CR when gap found in upstream artifact
│         writes : /change-requests/cr-{name}.md
│           ├── minor CR → proceed optimistically
│           │             owner notified, 24h to object
│           │             auto-applied if no response
│           └── major CR → hard block
│                          wait for artifact owner to resolve
│
├─[ORCH]  Convention check
│           ✓ all tasks status: done or explicitly deferred
│           ✓ open CRs resolved or status: deferred
│           ✓ deferred CRs have advisorys created
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE 4                                                             ║
║  Presents: tasks completed, open CRs, deferred items               ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼
```

---

### PHASE 5 — Deployment
**Agent:** DevOps Engineer

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 5 — Deployment                        [DevOps Engineer]       │
└─────────────────────────────────────────────────────────────────────┘
│
├─[AGNT]  DevOps reads system artifacts
│         reads  : /architecture-decisions/*, /quality-requirements/*, /tasks/*
│
├─[AGNT]  DevOps produces infra plan
│         writes : /infra/infra-{name}.md
│           └── IaC specification
│               CI/CD pipeline config
│               monitoring and alerting setup
│               rollout strategy (canary or direct)
│               runbook for on-call
│
├─[ORCH]  Surfaces all deferred open items before final gate
│         reads  : /change-requests/* (status: open or deferred)
│                  /advisories/* (status: open or resolved)
│         presents alongside infra plan so user has full picture
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE 5 — FINAL                                                     ║
║  Presents: infra plan + complete deferred items list                ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼

┌─────────────────────────────────────────────────────────────────────┐
│  COMPLETE                                                            │
│  /features/feature-{name}.md  → status: accepted                    │
│  All phase artifacts versioned and accepted in PKM                   │
│  Deferred items remain open in /change-requests                      │
│  Session resumable from last accepted phase                          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## MEDIUM TRACK

For improvements or additions to an existing feature.
Skips discovery and design phases — enters at requirements or task level.

```
┌─────────────────────────────────────────────────────────────────────┐
│  MEDIUM TRACK — Feature Improvement                                  │
└─────────────────────────────────────────────────────────────────────┘
│
├─[USER]  Describes improvement in natural language
│         e.g. "add SMS fallback to the password reset flow"
│
├─[ORCH]  Classifies as medium track
│         Identifies which existing feature is affected
│         reads : /features/*, /requirements/*, /stories/*
│
├─[ORCH]  Confirms scope with user
│         Determines entry point:
│           existing stories cover it → enter at task decomposition
│           new user scenario needed  → enter at requirements
│
│  ── IF NEW STORIES NEEDED ───────────────────────────────────────
│
├─[AGNT]  BA adds stories to existing requirement
│         reads  : /requirements/req-{name}.md
│         writes : /stories/story-{new-scenario}.md
│                  updates /requirements/req-{name}.md
│                  bumps version: 1.0 → 1.1
│
├─[ORCH]  Determines if design changes needed
│           UI changes     → UX agent updates affected specs/flows
│           API changes    → Architect updates contract (or CR)
│           no UI/API gap  → proceed to task decomposition
│
│  ── SELECTIVE DESIGN UPDATES (if needed) ────────────────────────
│
├─[AGNT]  UX updates affected user flows / wireframes / component specs
│         writes: updated files, version bumped
│
├─[AGNT]  Architect updates affected contracts / data models
│         writes: updated files, version bumped
│           └── or files CR to existing artifact if not owner
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE — Design changes review (if any changes were made)            ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
├─[AGNT]  Task decomposition for new work only
│         writes : /tasks/task-{name}-be.md or -fe.md
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE — Task list review                                            ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
├─[AGNT]  Implementation of new tasks only
│         same process as large track Phase 4
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE — Implementation review                                       ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
├─[AGNT]  DevOps updates infra if deployment changes needed
│         writes : updated /infra/infra-{name}.md (or no change)
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE — Final (if infra changed)                                    ║
║  → approve   → refine [feedback]   → reject + delete               ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼

┌─────────────────────────────────────────────────────────────────────┐
│  COMPLETE                                                            │
│  Affected artifacts versioned and accepted                           │
│  Feature document updated with new scope                            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## SMALL TRACK — Change Request

For targeted corrections to existing artifacts.
Single gate. No phase sequence.

```
┌─────────────────────────────────────────────────────────────────────┐
│  SMALL TRACK — Change Request                                        │
└─────────────────────────────────────────────────────────────────────┘
│
├─[USER]  Describes change in natural language
│         e.g. "the reset email subject line should say
│              'Reset your password' not 'Password Reset'"
│
│         Can be initiated by:
│           user directly    → describes change in chat
│           downstream agent → files CR automatically during impl
│
├─[ORCH]  Classifies as small track
│         Identifies target artifact and its owner
│         reads : /vault/* (locate artifact)
│                 /_registry.md (confirm owner)
│
├─[ORCH]  Creates change request document
│         writes : /change-requests/cr-{name}.md
│           └── target     : artifact being modified
│               also-affects: other impacted artifacts
│               triggered-by: task or event that found the gap
│               resulted-in : filled on resolution
│               from, to, priority, proposed change
│
├─[ORCH]  Routes to artifact owner agent
│         Loads artifact + CR into owner agent context
│
│  ── MINOR CR (non-breaking, additive) ───────────────────────────
│
├─[AGNT]  Owner agent applies change
│         writes : updated artifact, version bumped
│                  cr-{name}.md → status: applied
│
│  ── MAJOR CR (breaking, cross-cutting) ──────────────────────────
│
├─[ORCH]  Presents CR to user before applying
│         explains impact and downstream effects
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE (major CRs only)                                              ║
║  User reviews proposed change and impact                            ║
║  → approve   → refine [feedback]   → reject                        ║
╚═════════════════════════════════════════════════════════════════════╝
│
├─[AGNT]  Owner agent applies approved change
│         writes : updated artifact, version bumped
│                  cr-{name}.md → status: applied
│
├─[ORCH]  Evaluates CR complexity for task creation
│           simple CR (1 task):
│             → create single task
│             → stamp cr.resulted-in = [task-id]
│           
│           complex CR (3+ tasks):
│             → create task-breakdown
│             → stamp cr.resulted-in = [tb-id]
│             → task-breakdown creates tasks
│           
│           no implementation needed:
│             → cr.resulted-in remains empty
│
├─[ORCH]  Updates milestone if exists
│         reads  : /milestones/* (find active milestone)
│         writes : milestone updated with CR + new tasks
│                  milestone.refs includes cr-id + task-ids
│
╔═════════════════════════════════════════════════════════════════════╗
║  GATE — Final confirmation (all CRs)                                ║
║  Orchestrator confirms change applied, shows diff summary           ║
║  Shows task-breakdown or tasks created (if any)                     ║
║  → approve   → refine [feedback]                                   ║
╚═════════════════════════════════════════════════════════════════════╝
│
▼

┌─────────────────────────────────────────────────────────────────────┐
│  COMPLETE                                                            │
│  cr-{name}.md → status: applied                                      │
│  target artifact version bumped                                      │
│  also-affects artifacts → status: needs-review                       │
│  triggered-by task unblocked (if it was blocked-by this CR)          │
│  resulted-in: [tb-id] or [task-id] or [] (stamped)                   │
│  milestone updated with CR tasks (if milestone exists)               │
│  downstream agents notified via _state.md needs-review section       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Session Resume

When user returns after closing a session:

```
├─[USER]  "continue {feature name}"
│
├─[ORCH]  Reads agent _state.md files + feature document
│         Reconstructs:
│           last accepted phase
│           in-progress planning artifacts (status: draft or ready-for-review)
          in-progress tasks (task status: open or in-progress)
│           open CRs and advisorys
│           waiting-on and blocked-by from agent state
│           artifacts now status: needs-review (upstream changed)
│
├─[ORCH]  Presents resume summary:
│           "Feature {name} — Phase {N} in progress
│            Last completed: {phase}
│            In progress: {artifact list}
│            Open CRs: {CR list}
│            Needs review: {artifacts whose upstream changed}
│            Resume from Phase {N}?"
│
├─[USER]  Confirms or redirects to a different phase
│
└─[ORCH]  Reactivates relevant agents with cached context
```

---

## Deferred Items Handling

When user proceeds despite a warning:

```
├─[ORCH]  Creates advisory capturing concern
│         writes : /advisories/adv-{concern}.md
│           └── what was skipped, which artifact, suggested action
│
├─[ORCH]  Proceeds with user-directed work
│
│  At final gate (Phase 5) or on user request:
│
├─[ORCH]  Surfaces all advisorys and open CRs
│         Presents as deferred items list
│         User decides: resolve now or keep deferred
│
│  If user resolves deferred item:
│   └── routes to small track (CR flow) for targeted fix
│
│  If user keeps deferred:
│   └── advisory remains open
│       cr-{name}.md stays status: deferred
│       feature marked accepted with open items noted
```

---

## PKM Write Summary Per Phase

| Phase      | Artifact Types Written                                          |
|------------|-----------------------------------------------------------------|
| Intake     | feature                                                         |
| Phase 1    | requirement, optional story                                     |
| Phase 2    | user-flow, wireframe, component-spec, decision, api-contract, data-model, constraint |
| Phase 3    | task                                                            |
| Phase 4    | task (status + implementation-notes), change-request                      |
| Phase 5    | infra                                                           |
| Any phase  | draft (warnings), change-request (gaps)                         |
