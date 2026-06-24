# Artifact-Driven Development — Agent Instructions

**Before doing anything else, read this file in full.**

---

## Where to Look

- **Artifacts, roster, skills, repos** → `manifest.yaml` (source of truth)
- **Reference docs** (vocabulary, lifecycle, coordination) → `reference/README.md`
- **Project setup** → `handbook/playbooks/setup.md`

`{vault-root}` = current repo folder (CWD) where `manifest.yaml` lives. Sibling code repos are in `repos:`.
Load reference docs on demand. Never load `handbook/` docs unless explicitly directed.

---

## Committing

Use `git commit`. Format:
```
git commit -m "Short imperative summary

- Bullet detail 1
- Bullet detail 2"
```
For sibling repos: `git -C ../{repo-name} commit -m "..."`. Bare commits land in CWD.

---

## Token Efficiency: Reading & Editing

- **Minimize reads:** Read only the target artifact and its direct upstream references (`refs` field). Skip files owned by other agents unless explicitly referenced.
- **Do not re-read:** Avoid re-reading files in the same session unless changed.
- **Large files:** Use `offset`/`limit` to read specific sections of large files.
- **Reading patterns:** Read one file to confirm a pattern, then edit similar files without re-reading.
- **Task artifacts:** Skip closed tasks. Only read open/in-progress tasks if they target your scope or are in your active upstream chain.
- **Editing:** Prefer targeted edits over full rewrites. Batch multiple edits to the same file. Refer to stable artifacts by path, not content.

---

## Optimize Communication

- **Clarify early:** Ask before acting on ambiguity. Clarify intent via questions rather than self-clarifying by reading.
- **Surface reasoning:** State your decision and one-line rationale; don't make the user guess from the diff.
- **Propose best practices:** Propose alternatives with rationales instead of silently substituting or blindly complying.
- **Surface rejections:** Name rejected approaches and their one-line rejection reason.
- **State assumptions:** Call out any assumptions made when inferring intent.

---

## Operating Modes

### Interactive Mode (Default)
- **Badge:** Start response with `**🧑‍💻 Interactive Mode**` on its own line at the very top.
- **Scope:** Simple Q&A, explanations, plan-drafting, or research. No complex multi-file modifications or commands.
- **Pause Trigger:** If you find >3 valuable questions/findings, pause and summarize them for user direction before continuing.

### Autonomous Mode
- **Badge:** Start response with `**🚀 Autonomous Mode**` on its own line at the very top.
- **Scope:** Execution-heavy tasks (editing, restructuring, running tests/builds).
- **Switching:** Proactively state your understanding, then ask for confirmation to switch via the `ask_user_question` tool (Yes/Cancel picker). Do not execute complex changes in Interactive Mode.
- **Task-Tracking:** Once confirmed, initialize task list (`todo_write`) and execute sequentially. Update states in real-time.
- **Blockers & Reporting:** Return to Interactive Mode on fatal blockers. If working on a task artifact, mark it `blocked`; otherwise output errors to stdout.

### Real-Time Mode Control
- Users can switch modes via `/interactive` (or `/pause`) and `/autonomous` (or `/resume`).
- These trigger `skills/interactive/SKILL.md` and `skills/autonomous/SKILL.md`. Intercept and respect these immediately.

---

## Output Style

- **Be short and concise.** No preambles or redundant context, but never omit details needed to verify alignment.
