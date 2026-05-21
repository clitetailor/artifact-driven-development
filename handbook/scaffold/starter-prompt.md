# Starter Prompt

Use this prompt when the scaffold has been copied into a new project and the agent needs to begin onboarding and artifact generation.

## Prompt

```text
You are working in a project that contains a copied Artifact-Driven Development scaffold.

Your job is to onboard the vault to this specific project, then generate the minimum correct planning artifacts for the user's requested scope.

Follow this sequence strictly:

1. Read the local docs vault `AGENTS.md` first.
2. Read these workflow docs from the docs vault:
   - `handbook/scaffold/bootstrap.md`
   - `handbook/scaffold/onboarding.md`
   - `handbook/scaffold/repo-inspection-rules.md`
   - `handbook/scaffold/template-selection.md`
   - `handbook/scaffold/artifact-generation-rules.md`
   - `handbook/scaffold/customization-checklist.md`
3. Inspect the target workspace for existing guidance and conventions before asking broad questions:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `README.md`
   - stack manifests and infra files
4. Infer as much as possible from the repository structure, stack files, and existing docs.
5. Ask the user only for missing information that cannot be reliably inferred.
6. Confirm or update repo placeholders such as `{docs-repo}`, `{frontend-repo}`, `{backend-repo}`, and `{infra-repo}`.
7. Update `_registry.md` before creating any new feature or module artifacts.
8. Decide which SDLC track applies: large, medium, or small/change-request.
9. Select only the templates required for the current scope.
10. Generate artifacts in suggested creation order with correct frontmatter and `refs`.
11. Keep artifacts minimal, accurate, and tailored to the actual project.
12. Present the generated artifacts for review before treating them as accepted.
```

## Non-Negotiable Rules

- Do not invent product context, conventions, or architecture if the repo or user has not provided them.
- Do not generate every template by default.
- Prefer existing project conventions over scaffold example conventions.
- Rewrite scaffold example convention docs if they materially conflict with the target stack.
- Use change requests instead of silently mutating accepted upstream artifacts.

## Expected First Deliverable

Usually one of:

- a feature doc
- a requirement doc
- a change request

depending on the user's requested scope.

## Expected First Actions

1. Read `AGENTS.md`
2. Inspect repo guidance files
3. Ask targeted discovery questions only if needed
4. Update placeholders and registry
5. Generate the first planning artifact
