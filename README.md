# Artifact-Driven Development Lifecycle

Reusable documentation vault scaffold for copying into another project.

## What This Scaffold Includes

- Vault folder structure
- Generic `AGENTS.md`
- Artifact templates (`templates/`)
- Agent role docs and repo mappings (`agents/`)
- Reference docs: vocabulary, lifecycle, ownership, SDLC phases, dep graph (`reference/`)
- Handbook: workflows and scaffold setup docs (`handbook/`)

## Intended Use

1. Copy `artifact-driven-development/` into a target workspace.
2. Rename it to the target docs repo or docs folder name if needed.
3. Replace placeholders like `{docs-repo}` and `{frontend-repo}`.
4. Run the onboarding workflow docs in `handbook/scaffold/`.
5. Let a coding agent inspect the target project, ask the user questions, and generate planning artifacts from the templates.

## Start Here

- Humans: `handbook/scaffold/replication-steps.md`, `handbook/scaffold/customization-checklist.md`
- Agents: `handbook/scaffold/starter-prompt.md`
- Ongoing vault operation: `handbook/scaffold/onboarding.md`

## Root Files

Only three files live at the root — everything else is in a folder.

| File | Purpose |
|---|---|
| `AGENTS.md` | Core operating instructions for the vault |
| `_registry.md` | Source of truth for artifact types, features, and modules |
| `README.md` | Entry point for humans and agents |

## Folder Map

| Folder | Purpose |
|---|---|
| `handbook/` | Human-readable workflow guides (SDLC, TDD, role processes, dep graph, coordination examples) |
| `handbook/scaffold/` | Setup and onboarding docs for the scaffold itself |
| `reference/` | AI-friendly, on-demand reference docs (see `reference/README.md` for index) |
| `templates/` | Artifact doc templates |
| `agents/` | Agent design docs and repo/skill mappings |
| `conventions/` | Enforced project conventions |
| `personas/`, `features/`, `requirements/`, … | Vault artifacts (created during onboarding) |

## Key Rule

Do not copy project-specific feature artifacts from another project. Use the templates in `templates/` to generate new artifacts for the target project.
