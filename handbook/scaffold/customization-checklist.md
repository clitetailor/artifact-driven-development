# Customization Checklist

Use this after copying the scaffold into a new project.

## Repo Placeholders

- Replace `{docs-repo}`
- Replace `{frontend-repo}`
- Replace `{backend-repo}`
- Replace `{infra-repo}`
- Update any other project-name placeholders introduced during local adaptation

## Folder Decision

- Confirm the docs vault folder name
- Confirm whether the target project uses a single repo or sibling repos
- Confirm whether `infra/` is needed as a separate repo or only as a folder

## Convention Sources

- Read target `AGENTS.md` if present
- Read target `CLAUDE.md` if present
- Read target root `README.md`
- Read stack manifests and config files
- Decide whether to keep or rewrite `conventions/frontend-conventions.md`
- Decide whether to keep or rewrite `conventions/backend-api-structure.md`
- Decide whether to keep or rewrite `conventions/design-system.md`

## Registry Setup

- Update `_registry.md` `updated:` value
- Replace placeholder features with real feature slugs
- Replace placeholder modules with real module slugs
- Confirm artifact types and prefixes remain unchanged unless intentionally extending the system

## Product Context

- Update `handbook/scaffold/product-context.md`
- Capture primary users
- Capture core workflows
- Capture deployment and compliance constraints
- Capture product priorities

## Template Scope

- Decide which artifact types are needed now
- Do not generate every template by default
- Generate only what current feature scope requires

## Validation

- Check unresolved placeholders remain only where intended
- Check internal links still resolve
- Check stack-specific docs match the target project
