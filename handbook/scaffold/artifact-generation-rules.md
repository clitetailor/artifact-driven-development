# Artifact Generation Rules

## General Rules

- Read `AGENTS.md` first.
- Update `_registry.md` before writing a new feature or module.
- Use the correct template for the artifact type.
- Place each artifact in the correct folder.
- Keep IDs lowercase and hyphen-separated.
- List all related artifacts in `refs`.

## Suggested Generation Order

1. Research notes and personas if needed
2. Feature
3. Requirement (with embedded scenarios)
4. Design artifacts
5. Tasks
6. Infra

## Dependency Guidance

- The order above is a suggestion, not a hard rule. See `../artifact-dependency-graph.md` for the full graph.
- Prefer to create upstream artifacts before downstream ones. If a needed upstream is missing, either create it first or ask the user whether to narrow scope.
- Use change requests instead of silently changing upstream accepted artifacts.

## When To Ask The User

- Scope is ambiguous
- Product context is missing and not discoverable
- Stack-specific conventions conflict with scaffold examples
- The agent cannot determine whether a design artifact is needed
- The user must choose planning depth or track

## Status Guidance

- New planning artifacts start as `draft`
- Move to `ready-for-review` only when complete enough for review
- Do not mark `accepted` without user approval

## Output Discipline

- Do not generate unused artifacts
- Do not invent product details without evidence or user confirmation
- Prefer minimal sufficient planning
