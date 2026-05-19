# Template Selection Guide

Use this guide to decide which templates to instantiate.

## Always Start With

- `feature.md` for a new capability
- `requirement.md` for scoped requirements

## Use When Needed

- `research-note.md` when discovery input is still raw
- `persona.md` when user archetypes materially affect design or scope
- `story.md` when scenario-level traceability is needed
- `user-flow.md` when user journeys or branching paths matter
- `wireframe.md` when UI layout needs review before implementation
- `component-spec.md` when UI behavior or state detail matters
- `architecture-decision.md` for significant technical decisions
- `api-contract.md` when backend/frontend or service integration boundaries matter
- `data-model.md` when schema or persistence design matters
- `quality-requirement.md` for explicit performance, reliability, or security constraints
- `task.md` when work is ready for implementation planning
- `task-breakdown.md` when change-request resolution expands into multiple implementation units
- `implementation-note.md` only for cross-cutting implementation knowledge
- `infra.md` when deployment, CI/CD, monitoring, or rollout planning is needed
- `change-request.md` when a downstream artifact needs an upstream artifact changed
- `advisory.md` when proceeding with a known non-blocking concern

## By Track

### Large Track

- feature
- requirement
- optional story
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

- update existing requirement or add story
- generate only affected design artifacts
- generate only new tasks
- generate infra only if rollout changes

### Small Track

- change-request
- optional task-breakdown if more work is created from the CR
