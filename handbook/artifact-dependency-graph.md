# Artifact Dependency Graph — Human Guide
> Narrative companion to `../reference/artifact-dep-graph.md`. Read this once to understand the model; refer to the reference file for lookups.

## Why grouped, not flat

A flat artifact-by-artifact DAG (16 nodes, ~20 edges) is technically accurate but visually noisy and obscures the intent. Artifacts cluster naturally by the **question they answer** and the **role that owns them**. The grouped graph trades artifact-level precision for clarity of purpose. Artifact-level precision still lives in the **creation-order table**; the graph's job is the mental model.

Note: iteration in SDLC means **re-entering** an upstream group via a change-request, not reversing dependency direction. The graph is still a DAG.

## The Groups

| Group | Purpose | Owner role |
|---|---|---|
| **Discovery** | Understand the user | Business Analyst |
| **Product Definition** | Define what to build | Business Analyst |
| **UX Design** | Design the experience | UX-UI Designer |
| **System Design** | Design the structure | Software Architect |
| **Quality** | Define and verify correctness | QA Engineer |
| **Implementation** | Build it | Backend / Frontend Engineer |
| **Operations** | Run it | DevOps Engineer |
| **Coordination** | Cross-cutting concerns | Orchestrator |

For agent ownership detail: `../reference/artifact-ownership.md`.

## How Groups Interact

Five interaction types capture how any two groups relate. Most pairs use **Produces** as the dominant interaction, plus one or two secondary types.

- **Produces** — A must exist before B. This is the classic dependency edge.
- **Refines** — Creating B exposes a gap or contradiction in A. A is revised, usually via a change-request. This is how feedback flows backward without reversing the DAG.
- **Constrains** — A bounds the valid shape of B without producing it. Example: a `quality-requirement` constrains all System Design choices without being their parent.
- **Validates** — B asserts A is correct, complete, or testable. Example: a `test-suite` validates an `api-contract`.
- **Co-evolves** — A and B are iterated in tandem. The clearest pair in this vault is **Quality ↔ Implementation** (TDD red-green-refactor). **UX Design ↔ System Design** *may* co-evolve when run in parallel, but Phase 2 sequencing is sequential by default — see `sdlc-workflows.md`.

Coordination artifacts (`change-request`, `advisory`, `milestone`) are an **overlay**: they touch any group from the side without sitting in the production flow. A CR is the formal vehicle for the "Refines" interaction.

For the full inter-group matrix: `../reference/artifact-dep-graph.md#inter-group-matrix`.

## Per-Group Notes

Practical guidance — why the typical order works.

### Discovery
- `research-note` is the root. Interview notes, surveys, observation logs.
- `persona` synthesizes one or more research notes. A persona without grounding research is a smell.

### Product Definition
- `feature` sketches a capability. Can exist early (before research is complete); a good feature references at least one persona.
- `requirement` scopes one feature with **embedded scenarios**. Scenarios live inside the requirement doc, not as separate artifacts.

### UX Design
- `user-flow → wireframe → component-spec` — each step refines the prior.
- May co-evolve with System Design when run in parallel (component-spec assumes an api-contract shape; api-contract may bend to fit UX needs). Default sequencing in Phase 2 is sequential.
- Body templates: `../templates/wireframe.md`, `../templates/user-flow.md`, `../templates/component-spec.md`.

### System Design
- `architecture-decision` is **optional** — only for significant technical choices that deserve a written record.
- `quality-requirement` captures NFRs (performance, security, reliability) and **constrains** the rest of System Design plus Operations.
- `api-contract` typically references relevant scenarios from the requirement.
- `data-model` is derived from api-contract shapes.

### Quality
- `test-plan` belongs in design — testing strategy decided alongside other design work.
- `test-spec` covers one scenario; `test-suite` groups specs.
- Co-evolves with Implementation via TDD. See `tdd-workflow.md`.

### Implementation
- `task-be` typically needs api-contract, data-model, requirement.
- `task-fe` typically needs component-spec, api-contract.
- Per-task body template (includes **Implementation Notes** section): `../templates/task.md`. For cross-task insights, file an ADR (durable decision), a convention doc, or an advisory.

### Operations
- `infra` is the terminal node. Typically waits until tasks are done.
- Constrained by `architecture-decision` and `quality-requirement` (Operations doesn't get to pick the database).

### Coordination
- `change-request` — file at any time against any artifact. The formal "Refines" vehicle. Body template: `../templates/change-request.md`. Routing rules: `sdlc-workflows.md#cr-routing-rules`.
- `advisory` — noted-for-future tracker. Written when an agent or human spots a concern worth remembering. Not auto-generated. Body template: `../templates/advisory.md`.
- `milestone` — optional timeline coordination. Tracks scenarios and tasks for a sprint or phase.

## How Agents Use This

When asked to produce artifact X:

1. Identify X's group; check the reference's intra-group diagram for upstream artifacts inside the same group.
2. Check the inter-group matrix for upstream groups whose artifacts X typically references.
3. Grep the vault for those upstream artifacts; read them.
4. Create X; list referenced artifacts in `refs`.
5. If an expected upstream doesn't exist, either create it first or note the gap to the user.

The graph is a **prompt**, not a **gate**. If the user explicitly says "skip the persona", proceed and note the omission as an advisory.

## Impact Queries

The `refs` field lets you trace links in either direction.

```bash
# What references this artifact?
grep -rl "refs:.*api-contract-auth-service" /vault

# What does this artifact reference?
grep -A 20 "^refs:" /vault/api-contracts/api-contract-auth-service.md
```

For the full query recipe set: `../reference/vault-queries.md`.
