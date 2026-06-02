# Artifact-Driven Development — Agent Instructions

**Before doing anything else, read this file in full.**

---

<!-- USER:BEGIN -->
## Project Role

Planning docs and implementation artifacts for a software project.
Code lives in sibling repos (`{frontend-repo}`, `{backend-repo}`).
All design artifacts are stored in this repo (`{docs-repo}`) as a PKM vault.

## Sibling Repos

| Directory | Purpose |
|---|---|
| `../{frontend-repo}/` | Frontend application |
| `../{backend-repo}/` | Backend API |
| `../{infra-repo}/` | Infrastructure / deployment repo |
| `../{docs-repo}/` | Documentation vault — plans, SDLC artifacts |
<!-- USER:END -->

---

## File Ownership (for upgrades)

When this vault is upgraded via `handbook/playbooks/upgrade-framework.md`, files fall into three classes:

- **Framework-owned** (overwritten on upgrade): `handbook/`, `reference/`, `agents/`, `_sources/`, `README.md`. Do not edit these for project-specific customization — fork into a user-owned location instead.
- **3-way merged** on upgrade: `AGENTS.md` (base cached at `.add/cache/AGENTS.md`). Content between `<!-- USER:BEGIN -->` and `<!-- USER:END -->` is always preserved as-is — the script reports what upstream wanted there but never overwrites it. Framework sections outside those markers merge normally and may produce conflict markers.
- **User-owned** (never touched on upgrade): `registry.yaml`, `templates/`, `conventions/`, and all vault artifact folders.

`registry.yaml` stores repo name values (docs-repo, frontend-repo, etc.) under `repos`; these are re-applied as placeholders in `reference/` and `agents/` on upgrade.

`FRAMEWORK_VERSION` records the upstream version this vault was last synced to.

---

## Where to Look

- **Artifact types, prefixes, agent roster, skills, statuses, repo names** → `registry.yaml` (source of truth)
- **Reference docs** (vocabulary, lifecycle, ownership, dep graph, frontmatter, queries, folder structure, SDLC phases, coordination tree) → `reference/README.md`
- **Project setup, playbooks, customization guide** → `handbook/setup.md` (entry point), `handbook/playbooks/`, `handbook/guide/`
- **Human workflow guides + diagrams** → `handbook/`
- **Source material** (real-world process docs the framework was synthesized from) → `_sources/`. Do not load unless explicitly asked — uses off-framework vocabulary on purpose.

Load reference docs only when the task requires them. Never load `handbook/` or `_sources/` docs unless explicitly directed.

---

## Committing

Use `jj commit` (not `git commit`). Format:

```
jj commit -m "Short imperative summary

- Bullet detail 1
- Bullet detail 2"
```

For a sibling repo specifically: `jj -R ../{repo-name} commit -m "..."`.
Bare `jj commit` always lands in `{docs-repo}` (default CWD).

---

## Token Efficiency Rules

- **Ask before acting on ambiguity.** If a task or requirement is unclear, ask first.
- **Think before acting.** Read all relevant artifact and conventions docs before writing any agent prompt.
- **Only read what the task requires.** Read the target artifact and its direct upstream references (from the `refs` field). Do not read artifacts owned by other agents unless explicitly referenced by the task.
- **Do not re-read files already read in this session** unless the file may have changed.
- **Use `offset`/`limit` on Read for large files.** When only a specific section is needed (e.g. frontmatter, a single entity definition), read only that portion — not the whole file.
- **One read is enough as a pattern.** When applying the same structural change to multiple similar files, read one file to confirm the pattern, then edit the rest without re-reading each.
- **Prefer editing over rewriting.** Use Edit for targeted changes; Write for new files or full rewrites.
- **Batch edits to the same file efficiently.** Combine clustered changes into a single Edit or Write; for large files with sparse changes, use one targeted Edit per changed section.
- **Keep agent prompts concise.** No preamble, no restating context the agent doesn't need.
- **Pass paths, not content.** Standards docs and vault artifacts are stable — give the path.
- **Load reference docs on demand.** Read them only when the task requires resolving a status transition, ownership question, or unfamiliar term.
- **Skip historical coordination artifacts; read live ones in scope.** Do not read `change-requests/cr-*`, `advisories/adv-*`, or `architecture-decisions/adr-*` files for orientation by default. Read them when any of these apply:
    - The task's `refs` explicitly point to the artifact.
    - A CR has `status: open` and its `refs` include any artifact in your task's upstream chain (the contract may be mid-change).
    - An ADR lives in your task's feature/module scope (ADRs encode durable constraints; violating one is still wrong even if the task doesn't name it).
    Skip applied/closed CRs and resolved advisories — their intent has already been funneled into tasks.
- User instructions always override these rules.
