# Playbook: Plan Feature

Plan a new feature or an enhancement to an existing one.
Covers full SDLC (Q5=A), selected artifacts (Q5=B), and enhancements (Q1=C with Q5=A or B).

## Prerequisites

- ADD vault initialized (`handbook/playbooks/setup-new-repo.md` done)
- Answers available from `handbook/setup.md` Q&A:
  - Scope: new capability (Q4=A), enhancement (Q4=B), or correction routed here (Q1=C, Q5=A/B)
  - Planning depth: full SDLC (Q5=A) or selected artifacts (Q5=B)

If running standalone, collect scope and planning depth before starting.

For a targeted correction with no new planning artifacts, use `plan-change.md` instead.

---

## Step 1 — Determine entry point

**Agent:**
- If Q4=A (new capability): the entry point is a new `feature` artifact — continue to Step 2
- If Q4=B or C (enhancement / correction routed here): check whether a `feature` artifact already exists for this scope
  - If yes: that is the entry point — skip Step 2, proceed to Step 3
  - If no: create a feature artifact in Step 2 to anchor the new scope

---

## Step 2 — Register and create the feature artifact

**Agent:** Add the new feature slug to `_registry.md` under **Features**. Update `updated:` date.

**Agent:** Create `features/feat-{slug}.md` from `templates/feature.md`. Fill:
- `id`, `feature`, `status: draft`
- Summary, scope (in/out), success metrics, user context
- `refs` pointing to any existing persona or research-note artifacts

Present the feature artifact to the user for a quick sanity check before continuing.

---

## Step 3 — Determine planning depth

**If Q5=B (selected artifacts):**

**Agent:** Ask the user which artifact groups to generate. Present the groups:
- **A** — Requirements only (`requirement`)
- **B** — Requirements + UX design (`user-flow`, `wireframe`, `component-spec`)
- **C** — Requirements + system design (`api-contract`, `data-model`, `adr`, `quality-requirement`)
- **D** — Requirements + both UX and system design
- **E** — Any of the above + test plan
- **F** — Tasks only (implementation planning, skipping design)

Generate only the selected groups. Skip the unselected gates below.

**If Q5=A (full SDLC):** proceed through all gates.

---

## Phase 1 — Requirements

**Agent:** Create `requirements/req-{slug}.md` from `templates/requirement.md`.
- Reference `feat-{slug}` in `refs`
- Embed scenarios with acceptance criteria and priorities directly in the requirement doc
- Status: `draft`

**Gate 1 — present to user.**
Ask: approve / refine / reject. Do not proceed until the user approves or explicitly says to continue with noted concerns. Capture any noted concerns as `advisories/adv-{slug}.md`.

---

## Phase 2 — Design

Run design artifact generation based on the selected scope. For each artifact type below, check whether one already exists before creating a new one.

**Agent:** Create applicable design artifacts:

| Artifact | Template | When needed |
|---|---|---|
| `user-flow` | `templates/user-flow.md` | User journeys or branching paths matter |
| `wireframe` | `templates/wireframe.md` | UI layout needs review before implementation |
| `component-spec` | `templates/component-spec.md` | UI state or behavior detail matters |
| `architecture-decision` | `templates/architecture-decision.md` | Significant technical choice needs a written record |
| `api-contract` | `templates/api-contract.md` | Service integration boundaries matter |
| `data-model` | `templates/data-model.md` | Schema or persistence design matters |
| `quality-requirement` | `templates/quality-requirement.md` | Explicit NFRs (performance, security, reliability) needed |
| `test-plan` | `templates/test-plan.md` | Testing strategy should be defined before implementation |

Reference `req-{slug}` in `refs` for each artifact created.

**Gate 2 — present to user.**
Ask: approve / refine / reject. Capture concerns as advisories.

---

## Phase 3 — Test specs and tasks

**Agent:** For each scenario in `req-{slug}`:
- Create `test-specs/ts-{slug}-{scenario}.md` from `templates/test-spec.md`
- Group related specs into `test-suites/suite-{slug}.md` from `templates/test-suite.md`

**Agent:** Decompose into tasks:
- Create `tasks/task-be-{slug}-{n}.md` for backend work (references `api-contract`, `data-model`)
- Create `tasks/task-fe-{slug}-{n}.md` for frontend work (references `component-spec`, `api-contract`)
- Each task: status `open`, tier assigned, refs populated

**Gate 3 — present to user.**
Ask: approve task list / adjust scope / defer tasks. Deferred tasks stay as `open`; note the deferral in the task's body.

---

## Done

Planning artifacts are ready for implementation. Hand off by pointing the implementing agent to:
- The requirement doc and its scenarios
- The relevant design artifacts (api-contract, component-spec, data-model as applicable)
- The task list for this feature

For implementation: see `reference/artifact-ownership.md` for which agent role owns each artifact type.
