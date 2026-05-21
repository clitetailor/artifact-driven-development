# Handoff To Implementation

Use this after planning artifacts are reviewed.

## Preconditions

- Required planning artifacts exist
- Artifact refs and dependencies are valid
- The user has reviewed the planning output
- Tasks exist if implementation should begin

## Handoff Inputs

- requirements
- stories if present
- user flows and wireframes if present
- component specs if present
- API contracts and data models if present
- ADRs and quality requirements if present
- tasks for the selected implementation scope

## Handoff Rules

- Implementation agents should read only the artifacts needed for their scope
- Frontend work should start from component specs, user flows, API contracts, and frontend tasks
- Backend work should start from API contracts, data models, ADRs, and backend tasks
- Infrastructure work should start from infra docs plus relevant constraints and tasks

## If Gaps Are Found

- File a `change-request`
- Update affected artifacts
- Mark downstream accepted artifacts `needs-review` when required
