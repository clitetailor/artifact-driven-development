# Replication Steps

## Goal

Copy this scaffold into a new project and turn it into that project's planning vault.

## Steps

1. Copy `artifact-driven-development/` into the target workspace.
2. Rename the copied folder to the target docs folder name if needed.
3. Keep the folder structure intact.
4. Update repo placeholders in `AGENTS.md`, `agents/`, and other support docs.
5. Review target-project guidance files such as `AGENTS.md`, `CLAUDE.md`, and `README.md`.
6. Review target stack manifests and infrastructure files.
7. Rewrite stack-specific convention docs if the target stack differs materially from the examples in this scaffold.
8. Update `_registry.md` with real features and modules before generating artifacts.
9. Run the onboarding workflow to ask the user discovery questions.
10. Generate artifacts from templates in dependency order.
11. Validate IDs, refs, hard-deps, and file placement.

## Copy Guidance

- Copy support docs and empty artifact folders.
- Do not copy feature-specific artifacts from another project.
- Treat `templates/` as the source for new artifacts.

## Minimum Validation

- `AGENTS.md` points to the correct repo layout
- `_registry.md` is updated
- Stack-specific conventions are either accepted or rewritten
- No stale placeholders remain unintentionally
