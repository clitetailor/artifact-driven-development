# Artifact-Driven Development — Agent Instructions

**Before doing anything else, read this file in full.**

---

## Where to Look

- **Artifact types, prefixes, agent roster, skills, statuses, repo names** → `manifest.yaml` (source of truth)
- **Reference docs** (vocabulary, lifecycle, ownership, dep graph, frontmatter, queries, folder structure, coordination tree) → `reference/README.md`
- **Project setup** → `handbook/playbooks/setup.md`

`{vault-root}` (used throughout reference docs) = the current repo/folder you're working in (default CWD), where `manifest.yaml` lives. Sibling code repos are listed under `repos:` in `manifest.yaml`.

Load reference docs only when the task requires them. Never load `handbook/` docs unless explicitly directed.

---

## Committing

Use `git commit`. Format:

```
git commit -m "Short imperative summary

- Bullet detail 1
- Bullet detail 2"
```

For a sibling repo specifically: `git -C ../{repo-name} commit -m "..."`.
Bare `git commit` always lands in `{vault-root}` (default CWD).

---

## Communication

- **Ask before acting on ambiguity.** When user intent is even slightly unclear, ask a clarifying question before reading artifacts or producing output. This takes precedence over "Think before acting" below — do not self-clarify by reading when a single question would resolve the ambiguity. Switch this threshold via customizations in `handbook/customizations/` (see `handbook/playbooks/customize-artifacts.md`).
- **Propose alternatives when the user's approach is suboptimal.** If you find a more appropriate solution than what was requested, or the requested approach is weaker than it sounds, do not silently substitute or silently comply. Ask for clarification and propose the alternative(s), including the decision and rationale, so the user can choose. Silent compliance hides trade-offs; silent substitution bypasses the user.
- User instructions always override these rules.

## Reading Discipline

- **Think before acting.** Read all relevant artifact and conventions docs before writing any agent prompt — but only after the Communication check above has cleared intent.
- **Only read what the task requires.** Read the target artifact and its direct upstream references (from the `refs` field). Do not read artifacts owned by other agents unless explicitly referenced by the task. To navigate to a referenced artifact, use the `## References` section links at the bottom of the artifact body, or resolve the ID to a path via the grep recipes in `reference/vault-queries.md`.
- **Do not re-read files already read in this session** unless the file may have changed.
- **Use `offset`/`limit` on Read for large files.** When only a specific section is needed (e.g. frontmatter, a single entity definition), read only that portion — not the whole file.
- **One read is enough as a pattern.** When applying the same structural change to multiple similar files, read one file to confirm the pattern, then edit the rest without re-reading each.
- **Load reference docs on demand.** Read them only when the task requires resolving a status transition, ownership question, or unfamiliar term.
- **Skip historical task artifacts; read live ones in scope.** Do not read closed/done `tasks/task-*` files for orientation by default. Read them when any of these apply:
    - The task's `refs` explicitly point to the task.
    - A task has `status: open` or `in-progress` and its `refs` include any artifact in your task's upstream chain.
    - A task's `kind: review` targets an artifact in your scope (review tasks set `needs-review` on affected artifacts).
    Skip done/withdrawn tasks — their intent has already been funneled into newer tasks.

## Output Style

- **Be concise but informative.** Short replies, no preamble, no restating context the user already has — but never omit information the user needs to verify alignment.
- **Surface key reasoning.** State the decision and the one-line rationale that drove it. Do not make the user reconstruct your thinking from the diff.
- **Surface rejected alternatives.** When you considered and rejected a meaningfully different approach, name it and the rejection reason in one line. This is what lets the user catch a misaligned direction early instead of after implementation.
- **State assumptions made when inferring intent.** If you inferred instead of asking, call out the assumption explicitly so the user can correct it in one round.

## Editing & Prompt Discipline

- **Prefer editing over rewriting.** Use Edit for targeted changes; Write for new files or full rewrites.
- **Batch edits to the same file efficiently.** Combine clustered changes into a single Edit or Write; for large files with sparse changes, use one targeted Edit per changed section.
- **Keep agent prompts concise.** No preamble, no restating context the agent doesn't need.
- **Pass paths, not content.** Standards docs and vault artifacts are stable — give the path.
