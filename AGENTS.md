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

## Token Efficiency: Reading & Editing

- **Read and update documents in an efficient way.** Optimize token usage by being precise.
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
- **Prefer editing over rewriting.** Use Edit for targeted changes; Write for new files or full rewrites.
- **Batch edits to the same file efficiently.** Combine clustered changes into a single Edit or Write; for large files with sparse changes, use one targeted Edit per changed section.
- **Keep agent prompts concise.** No preamble, no restating context the agent doesn't need.
- **Pass paths, not content.** Standards docs and vault artifacts are stable — give the path.

## Optimize Communication

- **Ask before acting on ambiguity.** Engage in frequent back-and-forth to clarify intent. When user intent is even slightly unclear, ask a clarifying question before reading artifacts or producing output. This takes precedence over self-clarifying by reading when a single question would resolve the ambiguity.
- **Surface key reasoning.** Make your thoughts visible so the user understands how you work. State the decision and the one-line rationale that drove it. Do not make the user reconstruct your thinking from the diff.
- **Propose best practices over silent compliance.** If you find a more appropriate solution than what was requested, do not silently substitute or blindly comply. Ask for clarification and propose the best practice alternative(s), including the decision and rationale, so the user can choose. Silent compliance hides trade-offs; silent substitution bypasses the user.
- **Surface rejected alternatives.** When you consider and reject a meaningfully different approach, name it and the rejection reason in one line. This lets the user catch a misaligned direction early.
- **State assumptions made when inferring intent.** If you inferred instead of asking, call out the assumption explicitly so the user can correct it in one round.
- User instructions always override these rules.

## Operating Modes

- **Interactive Mode (Default)**
  - **Badge**: Always start your first response after a user message (and when explicitly switching modes) with the badge `**🧑‍💻 Interactive Mode**` on its own line at the very top.
  - **Flow**: Work interactively with the user to clarify intent. Prefer research first before asking.
  - **Pause Trigger**: If you uncover **more than 3 valuable questions or findings** (those essential to answer the user's request), pause.
  - **Pause Action**: Summarize these questions and findings and report back to the user to ask for direction before continuing. Avoid long, dense, black-box research phases that obscure information.

- **Autonomous Mode**
  - **Badge**: Always start your first response after a user message (and when explicitly switching modes) with the badge `**🚀 Autonomous Mode**` on its own line at the very top.
  - **Switching**: If the task requirements are clear (or once any initial ambiguities are resolved), proactively state your understanding of the task and explicitly ask for confirmation to make the switch. Even if the user explicitly requests this mode, you must still ask for confirmation before switching.
  - **Execution**: Once in this mode and confirmed, automatically perform tasks without asking. Only stop if every requirement has been resolved or if a fatal flaw is hit (e.g., encountering dangerous operations or detecting insecure actions).
  - **Blockers & Fallbacks**: If a fatal flaw or blocker is hit, immediately switch back to Interactive Mode.
  - **Reporting**: If working on a task artifact (`tasks/task-*`), update its status to `blocked`, otherwise report the error to standard output (do not write to a file unless explicitly requested).

## Output Style

- **Be short and concise.** Short replies, no preamble, no restating context the user already has — but never omit information the user needs to verify alignment.
