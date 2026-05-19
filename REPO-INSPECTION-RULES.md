# Repo Inspection Rules

Use these rules before asking the user broad project questions.

## Read First If Present

- `AGENTS.md`
- `CLAUDE.md`
- root `README.md`
- repo-local README files

## Inspect For Stack And Boundaries

- `package.json`
- `pnpm-workspace.yaml`
- `turbo.json`
- `go.mod`
- `pyproject.toml`
- `Cargo.toml`
- `Dockerfile`
- `docker-compose.yml` or `compose.yml`
- CI config under `.github/`, `.gitlab/`, or similar

## Infer From Structure

- frontend repo or folder
- backend repo or folder
- infra repo or folder
- shared libraries
- existing docs or architecture folders

## Conventions Rule

- Reuse existing project conventions when they exist
- Use scaffold conventions only where the target project has no stronger source of truth
- Rewrite scaffold example conventions when they conflict with the target stack

## Question Avoidance Rule

Do not ask the user for information that can be reliably inferred from inspected repo files.
