# Artifact Creation Order
> A guide for which artifacts an agent typically creates before which others. Not enforced — just suggested order.

## How to Read This

Arrows point from an artifact to artifacts that usually reference it. When an agent is about to create artifact X, the graph tells them which artifacts likely already exist (and should be linked via `refs`).

For the raw creation-order table, see `../reference/artifact-dep-graph.md`.

---

## The Graph

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
  [user-flow]  [quality-requirement]        [test-plan]
         │              │                       │
         │              └──────┐                │
         ▼                     ▼                ▼
    [wireframe]  [architecture-decision]   [test-spec]
         │                     │                │
         ▼               ┌─────┴─────┐         ▼
  [component-spec]        ▼           ▼    [test-suite]
         │          [api-contract] [data-model]
         │                  │          │
         └─────┬────────────┴─────┬───┘
               ▼                  ▼
           [task-fe]          [task-be]
                          │
                          ▼
                       [infra]

  Cross-cutting (any time):
    [change-request]   ← documents a request to change an existing artifact
    [advisory]         ← notes a future concern or improvement
    [milestone]        ← optional timeline coordination
```

---

## Per-Layer Notes

These are guidance — why the order makes sense in practice. Agents and humans can deviate if the situation warrants.

### Understand Layer

- **research-note** is the root document. Interview notes, surveys, observation logs.
- **persona** synthesizes one or more research notes. Creating a persona without grounding research is a smell.

### Define Layer

- **feature** sketches a product capability. Can exist early (before research is complete), but a good feature references at least one persona.
- **requirement** scopes one feature with embedded scenarios. Scenarios live inside the requirement doc — they are not separate artifacts.

### Design Layer

- **quality-requirement** captures performance/security/reliability constraints. Useful before committing to api-contracts.
- **architecture-decision** is *optional*. Create one only for significant technical choices that deserve a written record.
- **user-flow → wireframe → component-spec** is the UX chain. Each step refines the prior.
- **api-contract** typically references specific scenarios from the requirement. Useful to know ADRs and quality-requirements first, but not required.
- **data-model** is derived from api-contract shapes.
- **test-plan** belongs in design (Phase 2) so testing strategy is decided alongside other design work.

### Build Layer

- **test-spec** covers one scenario; **test-suite** groups specs. These are TDD support artifacts.
- **task (backend)** typically needs api-contract, data-model, and the requirement at hand.
- **task (frontend)** typically needs component-spec and api-contract.
- **implementation-note** is optional — write one only for cross-cutting insights spanning multiple tasks.

### Operate Layer

- **infra** is the terminal node. It typically waits until tasks are done.

### Cross-Cutting

- **change-request** can be filed at any point against any artifact. Use when an existing artifact needs to change.
- **advisory** is a noted-for-future tracker — agent or human writes when they spot a concern, deferred improvement, or limitation worth remembering. Not auto-generated; just exists until resolved or deleted.
- **milestone** is optional timeline coordination. Tracks scenarios and tasks for a sprint or phase.

---

## How Agents Use This

When asked to produce artifact X:
1. Check the graph for what X typically references.
2. Grep the vault for those upstream artifacts; read them.
3. Create X, listing the referenced artifacts in `refs`.
4. If an expected upstream doesn't exist, either create it first or note the gap to the user.

The graph is a *prompt*, not a *gate*. If the user explicitly says "skip the persona", an agent should proceed and note the omission.

---

## Impact Queries

The `refs` field lets you trace links in either direction.

```bash
# What references this artifact?
grep -rl "refs:.*api-contract-auth-service" /vault

# What does this artifact reference?
grep -A 20 "^refs:" /vault/api-contracts/api-contract-auth-service.md
```

For the full query recipe set, see `../reference/vault-queries.md`.
