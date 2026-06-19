# Artifact-Driven Development — Agent Instructions

**Before doing anything else, read this file in full.**

---

## Where to Look

- **Artifact types, prefixes, agent roster, skills, statuses, repo names** → `manifest.yaml` (source of truth)
- **Reference docs** (vocabulary, lifecycle, ownership, dep graph, frontmatter, queries, folder structure, coordination tree) → `reference/README.md`
- **Project setup** → `handbook/setup.md`
- **Source material** (real-world process docs the framework was synthesized from) → `_sources/`. Do not load unless explicitly asked — uses off-framework vocabulary on purpose.

`{vault-root}` (used throughout reference docs) = the current repo/folder you're working in (default CWD), where `manifest.yaml` lives. Sibling code repos are listed under `repos:` in `manifest.yaml`.

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
Bare `jj commit` always lands in `{vault-root}` (default CWD).

---

## Token Efficiency Rules

- **Ask before acting on ambiguity.** If a task or requirement is unclear, ask first.
- **Think before acting.** Read all relevant artifact and conventions docs before writing any agent prompt.
- **Only read what the task requires.** Read the target artifact and its direct upstream references (from the `refs` field). Do not read artifacts owned by other agents unless explicitly referenced by the task. To navigate to a referenced artifact, use the `## References` section links at the bottom of the artifact body, or resolve the ID to a path via the grep recipes in `reference/vault-queries.md`.
- **Do not re-read files already read in this session** unless the file may have changed.
- **Use `offset`/`limit` on Read for large files.** When only a specific section is needed (e.g. frontmatter, a single entity definition), read only that portion — not the whole file.
- **One read is enough as a pattern.** When applying the same structural change to multiple similar files, read one file to confirm the pattern, then edit the rest without re-reading each.
- **Prefer editing over rewriting.** Use Edit for targeted changes; Write for new files or full rewrites.
- **Batch edits to the same file efficiently.** Combine clustered changes into a single Edit or Write; for large files with sparse changes, use one targeted Edit per changed section.
- **Keep agent prompts concise.** No preamble, no restating context the agent doesn't need.
- **Pass paths, not content.** Standards docs and vault artifacts are stable — give the path.
- **Load reference docs on demand.** Read them only when the task requires resolving a status transition, ownership question, or unfamiliar term.
- **Skip historical task artifacts; read live ones in scope.** Do not read closed/done `tasks/task-*` files for orientation by default. Read them when any of these apply:
    - The task's `refs` explicitly point to the task.
    - A task has `status: open` or `in-progress` and its `refs` include any artifact in your task's upstream chain.
    - A task's `kind: review` targets an artifact in your scope (review tasks set `needs-review` on affected artifacts).
    Skip done/withdrawn tasks — their intent has already been funneled into newer tasks.
- User instructions always override these rules.
