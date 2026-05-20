# Artifact Dependency Graph
> How document dependencies encode and enforce the SDLC workflow

---

## Core Principle

The dependency graph is the SDLC encoded as data.
Phase gates emerge from dependency validation —
not from a separately maintained workflow engine.

```
Add a new artifact type with deps defined
  → orchestrator automatically knows where it fits
  → no additional phase configuration needed
```

---

## Dependency Notation

```
●  hard dependency — artifact cannot reach status: accepted
                     without this dep existing and accepted
○  soft dependency — recommended, generates warning if missing,
                     does not block acceptance
→  blocks          — this artifact must be accepted before
                     the downstream artifact can be accepted
```

---

## Full Dependency Graph

```
                  [research-note]
                        │
                        ▼
                    [persona]
                        │
                        ▼
                    [feature]
                        │
                        ▼
            [requirement (with scenarios)]
                        │
         ┌──────────────┼──────────────────────┐
         ▼              ▼                       ▼
  [user-flow]  [quality-requirement]        ○[test-plan]
         │              │                       │
         │              └──────┐               ○│ (soft)
         ▼                     ▼                ▼
    [wireframe]  [architecture-decision]   ○[test-spec]
         │                     │                │
         ▼               ┌─────┴─────┐         ○│ (soft)
  [component-spec]        ▼           ▼    ○[test-suite]
         │          [api-contract] [data-model]  │
         │                  │          │         │
         └─────┬────────────┴─────┬───┘         │
               ▼                  ▼◄─────────────┘ (soft)
           [task-fe]          [task-be]
               │                  │
               └──────────┬───────┘
                          ▼
               [task-breakdown]   ← coordinates phased CR task sets
                          │
                       [infra]
                          │
                          ▼
               [change-request]   ← can reference any artifact
               [advisory]         ← orchestrator concern, non-blocking
               [milestone]        ← optional timeline coordination
```

**TDD path notation:** `○` prefix indicates soft-dep participation.
Test artifacts (test-plan, test-spec, test-suite) are connected exclusively
via soft-deps — they provide traceability and generate warnings if missing,
but do not block any hard-dep acceptance chain.

---

## Dependency Rules Per Artifact

### Understand Layer

```
research-note
  hard-deps : none — root document, no upstream required
  soft-deps : none
  blocks    : persona

persona
  hard-deps : research-note (at least one)
  soft-deps : none
  blocks    : requirement, user-flow
```

### Define Layer

```
feature
  hard-deps : none — can exist before research is complete
  soft-deps : research-note, persona
  blocks    : requirement

requirement (with embedded scenarios)
  hard-deps : feature (exactly one)
  soft-deps : persona (at least one)
  blocks    : quality-requirement, user-flow, architecture-decision, api-contract, component-spec
  note      : scenarios are embedded within requirement doc, not separate artifacts
```

### Design Layer

```
quality-requirement
  hard-deps : requirement (at least one)
  soft-deps : none
  blocks    : architecture-decision, api-contract

architecture-decision
  hard-deps : requirement (at least one)
  soft-deps : quality-requirement (zero or more)
  blocks    : api-contract, data-model

user-flow
  hard-deps : requirement (at least one)
  soft-deps : persona (at least one)
  blocks    : wireframe
  note      : reads scenarios from requirement doc

wireframe
  hard-deps : user-flow (exactly one)
  soft-deps : none
  blocks    : component-spec

component-spec
  hard-deps : wireframe (at least one)
  soft-deps : none
  blocks    : task (frontend)

api-contract
  hard-deps : requirement (at least one)
  soft-deps : architecture-decision (zero or more)
              quality-requirement (at least one)
  blocks    : task (frontend), task (backend)
  note      : references specific scenarios from requirement doc

data-model
  hard-deps : api-contract (at least one)
  soft-deps : architecture-decision (zero or more)
  blocks    : task (backend)

test-plan  [DESIGN phase — TDD path]
  hard-deps : none
  soft-deps : requirement (at least one)
  blocks    : nothing — soft-dep only
  owner     : qa-engineer
  note      : created in Phase 2 alongside UX/Architect work
              defines testing strategy, scope, coverage targets
              lists test-specs to be written in Phase 3
```

### Build Layer

```
test-spec  [BUILD phase — TDD path]
  hard-deps : none
  soft-deps : requirement (at least one)
              test-plan (zero or one)
  blocks    : nothing — soft-dep only
  owner     : qa-engineer
  metadata  : scenario (links to req-{slug}#scenario-N)
              test-level (unit | integration | e2e)
  note      : created in Phase 3 before task decomposition
              each spec covers one requirement scenario
              Given/When/Then format, edge and error cases

test-suite  [BUILD phase — TDD path]
  hard-deps : none
  soft-deps : test-spec (one or more)
              test-plan (zero or one)
  blocks    : nothing — soft-dep only
  owner     : qa-engineer
  note      : created in Phase 3 after related test-specs drafted
              groups test-specs, defines shared fixtures, run commands
              sets coverage targets (line / branch / function)

task (backend)
  hard-deps : api-contract (at least one)
              data-model (at least one)
              requirement (at least one)
  soft-deps : architecture-decision (zero or more)
              test-spec (zero or more)   ← tests this task must pass
  blocks    : infra
  metadata  : scenario (links to req-{slug}#scenario-N)
              milestone (optional sprint/phase assignment)
              estimated-hours (effort estimate)

task (frontend)
  hard-deps : component-spec (at least one)
              api-contract (at least one)
  soft-deps : requirement (zero or more)
              test-spec (zero or more)   ← tests this task must pass
  blocks    : infra
  metadata  : scenario (links to req-{slug}#scenario-N)
              milestone (optional sprint/phase assignment)
              estimated-hours (effort estimate)

task-breakdown
  hard-deps : change-request (must be status: applied)
  soft-deps : none
  blocks    : tasks within it
  metadata  : triggered-by (links to cr-{slug})
              created only for complex CRs (3+ tasks)

implementation-note (optional)
  hard-deps : task (at least one)
  soft-deps : none
  blocks    : nothing — informational only
```

### Operate Layer

```
infra
  hard-deps : task-backend (all status: done)
              task-frontend (all status: done)
              quality-requirement (at least one)
  soft-deps : architecture-decision (zero or more)
  blocks    : nothing — terminal node
```

### Protocol Layer

```
change-request
  hard-deps : target artifact (exactly one — artifact being modified)
  soft-deps : none
  blocks    : nothing — workflow artifact, not a knowledge artifact
  special   : can be created at any point in the graph
              does not gate progression by itself
              resolved CRs become permanent audit trail

advisory
  hard-deps : none
  soft-deps : concern artifact (the artifact triggering the warning)
  blocks    : nothing — orchestrator working note only

milestone (optional)
  hard-deps : none
  soft-deps : requirement (scenarios included in milestone)
              task (tasks assigned to milestone)
              change-request (CRs applied during milestone)
  blocks    : nothing — coordination artifact, informational only
  special   : optional timeline coordination for sprints/phases
              aggregates scenarios and tasks for progress tracking
              tracks both planned (scenario) and unplanned (CR) work
              does not gate progression
  metadata  : triggered-by (links to req-{slug}#scenario-N)
```

---

## Dependency Matrix

Rows = artifact type. Columns = upstream dependency.
`●` hard. `○` soft. Empty = no relationship.

```
                     rn   pers feat req  qr   adr  uf   wf   cs   api  dm   tp   ts   task
research-note
persona              ●
feature              ○    ○
requirement               ○    ●
quality-requirement                 ●
architecture-decision               ●    ○
user-flow                 ●         ●
wireframe                                     ●
component-spec                                     ●
api-contract                        ●    ○    ○
data-model                                              ●
test-plan                           ○
test-spec                           ○                             ○
test-suite                                                             ○
task (backend)                 ●                   ●    ●              ○
task (frontend)                ●                   ●    ●              ○
task-breakdown       ← depends on change-request (applied)
infra                                                             ●   ●
milestone (optional) ← soft-deps on requirement + tasks (informational)
```

Column key:
```
rn   = research-note
pers = persona
feat = feature
req  = requirement (with embedded scenarios)
qr   = quality-requirement
adr  = architecture-decision
uf   = user-flow
wf   = wireframe
cs   = component-spec
api  = api-contract
dm   = data-model
tp   = test-plan
ts   = test-spec
task = task (backend or frontend)
```

---

## Frontmatter Schema — Dependency Fields

Two new fields added to every artifact:

```markdown
---
id: adr-reset-token-strategy
type: architecture-decision
purpose: design
owner: software-architect
status: accepted
version: 1.0
feature: password-reset
module: password-reset/reset-flow
hard-deps:
  - req-password-reset
soft-deps:
  - qr-auth-performance
refs:
  - req-password-reset
  - qr-auth-performance
  - api-password-reset-service
---
```

### Field Rules

**hard-deps**
- Subset of refs — every hard-dep must also appear in refs
- All must exist in vault before this artifact can be accepted
- All must have status: accepted before this artifact can be accepted
- Violation → block with specific missing dep named

**soft-deps**
- Subset of refs — every soft-dep should also appear in refs
- Missing soft-dep → warning only, does not block acceptance
- Keep minimal — if every artifact has five soft-deps,
  warnings become noise

**refs**
- All links: hard-deps + soft-deps + downstream consumers
- Bidirectional — when A refs B, B's backlink index includes A
- Used for impact analysis traversal

### Hard-dep vs Ref Distinction

```
refs contains ALL links from this document (superset)
hard-deps contains only blocking upstream dependencies (subset)

Example — api-contract-auth-service:
  refs:
    - adr-jwt-vs-session        ← hard-dep (decision)
    - req-user-authentication   ← hard-dep (requirement)
    - nfr-auth-performance      ← soft-dep (constraint)
    - task-token-generation-be  ← downstream consumer (not a dep)
    - task-login-form-fe        ← downstream consumer (not a dep)

  hard-deps:
    - adr-jwt-vs-session
    - req-user-authentication

  soft-deps:
    - nfr-auth-performance
```

Downstream consumers appear in refs but never in hard-deps.
A contract does not depend on its consumers — it is the
other direction.

---

## Status Lifecycle — Extended

The dependency graph requires one additional status:

```
draft
  → ready-for-review
      → accepted          ← only if all hard-deps satisfied
      → rejected          ← user rejects at gate
  → needs-review          ← upstream hard-dep changed after acceptance
      → accepted          ← re-reviewed, still consistent
      → draft             ← re-opened for revision
```

**Task breakdowns** use the standard artifact lifecycle. A task-breakdown cannot reach `accepted` until its source change request is `applied`.

**Change requests** use a separate resolution lifecycle — the artifact owner both reviews and enacts them:

| From     | To          | Condition                          |
|----------|-------------|------------------------------------|
| `open`   | `applied`   | artifact owner applies the change  |
| `open`   | `rejected`  | artifact owner rejects with reason |
| `open`   | `withdrawn` | filer cancels before owner acts    |

Rejection is terminal. If the filer disagrees, they file a new CR rather than re-opening the old one.

**Advisories** use a simple resolution lifecycle — non-blocking warnings written by the orchestrator:

| From    | To          | Condition                           |
|---------|-------------|-------------------------------------|
| `open`  | `resolved`  | the concern was addressed           |
| `open`  | `dismissed` | user consciously decides not to act |

Both are terminal. Advisories are never deleted — they remain as audit trail.

**All remaining artifact types** (persona, feature, requirement, quality-requirement, user-flow, wireframe, component-spec, api-contract, data-model, research-note, infra, test-plan, test-spec, test-suite) follow the standard artifact lifecycle. Research notes must reach `accepted` before a persona can be accepted. Infra is the terminal node — it reaches `accepted` when the deployment is approved. Test-specs reach `accepted` when the QA Engineer confirms all test cases pass in implementation (Phase 4). Test-suites reach `accepted` when all included test-specs are `accepted`.

**Architecture decisions** follow the standard artifact lifecycle with two additional terminal states:

| From       | To           | Condition                              |
|------------|--------------|----------------------------------------|
| `accepted` | `deprecated` | decision no longer applicable          |
| `accepted` | `superseded` | replaced by a newer ADR                |

**Implementation notes** use a simplified lifecycle — they are optional, informational, and block nothing:

| From    | To          | Condition                     |
|---------|-------------|-------------------------------|
| `draft` | `published` | author marks the note complete |

No formal review required.

---

### needs-review

Triggered automatically when an upstream hard-dep changes
after this artifact was already accepted.

The artifact is not rejected — it may still be valid.
The owning agent must confirm it remains consistent
with the changed upstream artifact.

```
Example:
  requirement-password-reset accepted ✓
  adr-reset-token-strategy accepted ✓ (hard-dep: requirement)

  → user refines requirement-password-reset (scope change)
  → orchestrator traverses forward from requirement
  → finds adr-reset-token-strategy in hard-dep chain
  → marks adr-reset-token-strategy: needs-review
  → notifies software-architect agent
```

---

## Enforcement Mechanisms

### Mechanism 1 — Pre-write Validation

Runs before any artifact status changes to accepted.

```
on status → accepted:
  1. read hard-deps list from frontmatter
  2. for each dep:
     a. check file exists in vault
        fail → block: "{dep-id} does not exist in vault"
     b. check dep status is accepted
        fail → block: "{dep-id} is {status}, must be accepted first"
  3. check soft-deps:
     a. if missing → warn: "{dep-id} recommended but not present"
  4. check acyclicity:
     a. traverse hard-dep graph from this artifact
     b. if cycle detected → block: "circular dependency detected"
  5. all pass → allow status: accepted
```

Default behavior is to enforce status-based blocking exactly as above. An agent may bypass a status-based blocker only on explicit user instruction to proceed without waiting for the blocking status transition. Such a bypass allows work to continue, but does not auto-change any artifact status to `accepted`.

### Mechanism 2 — Status Propagation

Runs after any accepted artifact is modified or versioned.

```
on accepted artifact updated:
  1. find all artifacts where this id appears in hard-deps
     (query: grep hard-deps across vault)
  2. for each downstream artifact with status: accepted:
     a. set status: needs-review
     b. add note: "upstream {artifact-id} changed on {date}"
     c. notify owning agent via _state.md
  3. batch notifications — one summary per agent,
     not one per affected artifact
```

### Mechanism 3 — Completeness Gates

Replaces hardcoded phase checklists.
Before entering a new layer, check all blocking deps are met.

```
on user requests phase transition:
  1. identify target artifact types for next layer
  2. for each type, check all hard-deps exist and are accepted
  3. if all satisfied → allow transition, activate agents
  4. if any missing → block: list specific gaps

Example — before build layer can begin:
  task-be hard-deps: api-contract ✓, data-model ✓, requirement ✓
  task-fe hard-deps: component-spec ✓, api-contract ✓
  → all satisfied → implementation can begin

Example — before build layer, gap found:
  task-fe hard-deps: component-spec ✗ (status: draft)
  → block: "component-spec-reset-form is still draft,
            cannot begin frontend implementation"
```

### Mechanism 4 — Track Routing via Impact Traversal

Graph traversal replaces manual track classification.

```
on user describes a change:
  1. orchestrator identifies entry point artifact
  2. traverse hard-dep graph backward (upstream impact)
     and forward (downstream affected)
  3. count affected artifact layers

  shallow impact (1-2 layers):
    → small track — CR only
    → example: fix error message copy in component-spec

  medium impact (3-4 layers):
    → medium track — partial SDLC
    → example: add new UI state to existing feature

  deep impact (5+ layers):
    → large track — full SDLC
    → example: new user scenario requiring new API surface
```

---

## Acyclicity Requirement

The dependency graph must be a DAG (directed acyclic graph).
Cycles would create unresolvable acceptance deadlocks.

```
Example cycle (invalid):
  decision hard-deps: api-contract
  api-contract hard-deps: decision
  → neither can ever reach accepted
  → orchestrator blocks at registration time

Valid direction always flows:
  understand → define → design → build → operate
```

Acyclicity is validated:
- When a new artifact type is added to the registry
- When hard-deps are declared in a new document
- Never assumed — always checked before write is accepted

---

## Impact Analysis Queries

The dep graph enables precise impact queries via frontmatter.

```bash
# what does this artifact block (downstream)
grep -rl "hard-deps:.*api-contract-auth-service" /vault

# what does this artifact depend on (upstream)
grep "hard-deps:" /vault/api-contracts/api-contract-auth-service.md

# all artifacts in needs-review state
grep -rl "status: needs-review" /vault

# all artifacts blocked by a specific draft dep
grep -rl "hard-deps:.*adr-reset-token-strategy" /vault \
  | xargs grep -l "status: accepted"
# → these are accepted artifacts whose dep is not yet accepted
#   (should not exist if enforcement is working — useful for audit)
```

---

## Organizational Principle Interaction

The dependency graph works with any organizational principle.
Folder structure determines navigation entry point.
Dependency graph determines write and acceptance rules.
They are independent axes.

```
By purpose   + dep graph → purpose is entry point, deps enforce order
By feature   + dep graph → feature is entry point, deps enforce order
By owner     + dep graph → owner is entry point, deps enforce order
By stage     + dep graph → stage is entry point, deps enforce order
```

The dep graph does not require any specific folder structure.
It operates entirely through frontmatter fields and
pre-write hook validation — folder-agnostic.

---

## Orchestrator Logic Summary

With dep graph enforcement, orchestrator phase logic simplifies:

```
Previous orchestrator logic (hardcoded phases):
  if phase == 1: check requirement + scenarios complete
  if phase == 2: check design artifacts complete
  if phase == 3: check tasks decomposed
  if phase == 4: check tasks done
  if phase == 5: check build complete

New orchestrator logic (graph-driven):
  on status change to accepted:
    → validate hard-deps (mechanism 1)
  on accepted artifact updated:
    → propagate needs-review (mechanism 2)
  on phase transition request:
    → check completeness of next layer deps (mechanism 3)
  on change described by user:
    → traverse graph for impact depth (mechanism 4)
    → route to appropriate track
```

Phase sequence becomes an emergent property of the graph.
No phase order needs to be hardcoded in the orchestrator.

---

## Limitations

### Circular dependencies
Cycles create unresolvable deadlocks.
Mitigation: validate acyclicity at registration and write time.

### Soft-dep warning noise
Too many soft-deps across all artifacts generates noise.
Mitigation: keep soft-deps minimal — only truly recommended,
not aspirational relationships.

### Graph traversal cost at scale
Impact analysis across hundreds of artifacts requires
traversing many edges. Can be slow if run on every write.
Mitigation: cache the graph in memory, recompute on write.
Run full traversal only at gate checkpoints.

### Cross-feature dep fan-out
A persona used by ten features creates ten hard-dep edges.
Changing persona triggers needs-review across all ten.
Mitigation: orchestrator batches notifications per agent,
not per affected artifact.

### Implicit vs explicit deps
Agents may write refs without declaring hard-deps,
creating a gap between what is linked and what is enforced.
Mitigation: pre-write hook warns when a ref to an upstream
artifact type is not reflected in hard-deps or soft-deps.

---

## Summary Table

| Mechanism | Trigger | Action | Result |
|---|---|---|---|
| Pre-write validation | status → accepted | check hard-deps exist and accepted | block or allow |
| Status propagation | accepted artifact updated | traverse forward, mark downstream | needs-review on affected |
| Completeness gate | phase transition request | check next layer hard-deps | block or allow transition |
| Track routing | user describes change | traverse impact depth | small / medium / large track |
| Acyclicity check | new dep declared | traverse for cycles | block if cycle detected |
