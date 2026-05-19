# Agent Onboarding Workflow

Use this workflow after the scaffold has been copied into a new project.

## Objective

Help a coding agent inspect the target project, ask the user the right questions, decide which templates apply, and generate the correct planning artifacts.

## Workflow

1. Read the copied vault `AGENTS.md` first.
2. Inspect the target workspace for existing guidance:
   - `AGENTS.md`
   - `CLAUDE.md`
   - root `README.md`
   - repo-specific README files
3. Inspect stack and tooling manifests to infer the project shape.
4. Ask the user focused discovery questions only for missing context.
5. Determine the scope of work:
   - new feature
   - existing feature enhancement
   - targeted correction
6. Decide which SDLC track applies:
   - large
   - medium
   - small / change-request
7. Update `_registry.md` before creating any new feature or module artifacts.
8. Select the required templates.
9. Generate artifacts in dependency order.
10. Validate refs, hard-deps, ownership, and naming.
11. Present artifacts for review.

## Inspection Priorities

- Existing planning docs already in the project
- Existing conventions and architecture docs
- Existing API specs and data models
- Existing CI/CD and deployment docs

## Questioning Rules

- Ask short, targeted questions
- Do not ask the user for information already discoverable in the repo
- Ask before inventing conventions, architecture, or product assumptions
- Ask which feature or initiative should be planned first if scope is broad

## Output Rule

Generate only the artifacts required by the selected track and current scope.
