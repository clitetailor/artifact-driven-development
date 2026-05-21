# Template Selection Guide

Use this guide to decide which templates to instantiate.

## Always Start With

- `feature.md` for a new capability
- `requirement.md` for scoped requirements

## Use When Needed

- `research-note.md` when discovery input is still raw
- `persona.md` when user archetypes materially affect design or scope
- `user-flow.md` when user journeys or branching paths matter
- `wireframe.md` when UI layout needs review before implementation
- `component-spec.md` when UI behavior or state detail matters
- `architecture-decision.md` for significant technical decisions
- `api-contract.md` when backend/frontend or service integration boundaries matter
- `data-model.md` when schema or persistence design matters
- `quality-requirement.md` for explicit performance, reliability, or security constraints
- `task.md` when work is ready for implementation planning
- `implementation-note.md` only for cross-cutting implementation knowledge
- `infra.md` when deployment, CI/CD, monitoring, or rollout planning is needed
- `change-request.md` when an existing artifact needs to change
- `advisory.md` when noting a deferred concern or future improvement worth remembering
- `milestone.md` for sprint or phase timeline coordination

## By Track

### Large Track

- feature
- requirement (with scenarios)
- user-flow
- wireframe
- component-spec
- optional architecture-decision
- api-contract
- data-model
- optional quality-requirement
- task
- optional infra

### Medium Track

- update existing requirement (add scenarios)
- generate only affected design artifacts
- generate only new tasks
- generate infra only if rollout changes

### Small Track

- change-request
- 0+ tasks listed in the CR's `refs`
