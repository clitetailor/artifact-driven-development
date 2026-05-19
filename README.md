# Artifact-Driven Development Lifecycle

Reusable documentation vault scaffold for copying into another project.

## What This Scaffold Includes

- Vault folder structure
- Generic `AGENTS.md`
- Artifact templates
- Agent role docs and repo mappings
- Reference, convention, and handbook docs
- Replication and onboarding workflow docs

## Intended Use

1. Copy `artifact-driven-development/` into a target workspace.
2. Rename it to the target docs repo or docs folder name if needed.
3. Replace placeholders like `{docs-repo}` and `{frontend-repo}`.
4. Run the onboarding workflow docs in this folder.
5. Let a coding agent inspect the target project, ask the user questions, and generate planning artifacts from the templates.

## Start Here

- Humans: `REPLICATION-STEPS.md`, `CUSTOMIZATION-CHECKLIST.md`
- Agents: `STARTER-PROMPT.md`
- Ongoing vault operation: `AGENT-ONBOARDING-WORKFLOW.md`

## After Copy Retention

| File | Status After Copy | Notes |
|---|---|---|
| `AGENTS.md` | keep | Core operating instructions for the vault |
| `_registry.md` | keep | Required source of truth for types, features, and modules |
| `README.md` | keep | Entry point for humans and agents |
| `CUSTOMIZATION-CHECKLIST.md` | keep | Useful for setup and future reconfiguration |
| `AGENT-ONBOARDING-WORKFLOW.md` | keep | Ongoing onboarding guidance for future sessions |
| `TARGET-PROJECT-DISCOVERY-QUESTIONNAIRE.md` | keep | Reusable for future planning work |
| `TEMPLATE-SELECTION-GUIDE.md` | keep | Helps limit artifact generation to needed scope |
| `ARTIFACT-GENERATION-RULES.md` | keep | Ongoing artifact creation rules |
| `REPO-INSPECTION-RULES.md` | keep | Ongoing repo inspection guidance |
| `BOOTSTRAP-SEQUENCE.md` | keep | Useful restart sequence for future onboarding |
| `HANDOFF-TO-IMPLEMENTATION.md` | keep | Reusable planning-to-implementation handoff guidance |
| `STARTER-PROMPT.md` | keep | Reusable kickoff prompt for coding agents |
| `REPLICATION-STEPS.md` | optional | Most useful during initial adoption; keep if the scaffold may be reused again |

## Remove After Copy

Remove only files that exist solely to maintain or distribute the scaffold itself.

Examples:

- `BUNDLE-MAINTENANCE.md`
- `EXPORT-INSTRUCTIONS.md`
- `SOURCE-OF-BUNDLE.md`

These do not exist in the current scaffold.

## Practical Policy

1. Keep all current files on first copy.
2. Finish placeholder replacement and initial onboarding.
3. Decide whether to archive or delete `REPLICATION-STEPS.md`.
4. Keep the remaining files as part of the target project's operating docs.

## Simple Rule

- If a file helps an agent work inside the target project, keep it.
- If a file only explains how to package or distribute the scaffold, remove it after copy.

## Key Rule

Do not copy project-specific feature artifacts from another project. Use the templates in `templates/` to generate new artifacts for the target project.
