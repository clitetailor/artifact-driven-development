# ADD Setup

> Reference this file in your AI chat to set up or use Artifact-Driven Development in a project.
> The agent will ask you a set of questions to understand the context, then proceed accordingly.

---

## For The Agent

The user has referenced this file. Ask one question at a time using the `AskUserQuestion` tool — render each question as a UI picker with its options as selectable choices. Wait for the user's answer before proceeding to the next question. Do not ask multiple questions at once.

Skip any question the user has already answered in their opening message. Skip conditional questions (Q2a/b/c, Q4, Q5) if their prerequisite answer makes them irrelevant.

---

## Questions

### Q1 — Intent

What do you want to do?

- **A** — Set up this repo with ADD for the first time
- **B** — Plan a new feature
- **C** — Plan a change or fix to an existing feature
- **D** — Manage repo names (update `registry.yaml` → `repos`)
- **E** — Query artifacts (find by status, charter, type, or refs)
- **F** — Clean up stale or unused artifacts

---

### Q2 — Repo layout

- **S** — Skip — already configured in `registry.yaml` and `AGENTS.md`, no change needed
- **U** — Update — layout is changing (answer below)

If U: how is this project laid out?
- Monorepo — all code and docs in one repo
- Multi-repo — sibling directories on the same machine
- Multi-repo — separate remotes

---

### Q2a — Frontend repos _(ask only for Q2 = U, or when adding repos)_

- **S** — Skip — already configured, no change
- **A** — Add — adding new frontend repos (list names below)
- **U** — Update — changing an existing frontend repo name or path (list old → new below)

Examples: `web`, `mobile`, `admin-ui`

---

### Q2b — Backend repos _(ask only for Q2 = U, or when adding repos)_

- **S** — Skip — already configured, no change
- **A** — Add — adding new backend repos (list names below)
- **U** — Update — changing an existing backend repo name or path (list old → new below)

Examples: `api`, `auth-service`, `data-pipeline`

---

### Q2c — Infra repo _(ask only for Q2 = U, or when adding repos)_

- **S** — Skip — already configured, no change
- **A** — Add — adding an infra repo (give name below)
- **U** — Update — changing the infra repo name or path (give old → new below)

Example: `infra`, `deploy`

---

### Q3 — Product context

- **S** — Skip — already established in README or planning artifacts
- **U** — Update — product context has changed (answer below)

If U:
- What is this product or system called?
- What problem does it solve?
- Who are the primary users?
- What are the main workflows?

---

### Q4 — Scope _(ask only for Q1 = B or C)_

What kind of work is this?

- **A** — New capability — nothing like this exists yet
- **B** — Enhancement — improving or extending something that already exists
- **C** — Correction — fixing a specific bug or targeted issue

---

### Q5 — Planning depth _(ask only for Q1 = B or C)_

How much planning do you want generated now?

- **A** — Full SDLC — charter, PRD, design artifacts, tasks
- **B** — Selected artifacts — pick only what this scope needs
- **C** — Change request only — a targeted correction, no new planning artifacts _(only valid when Q1 = C)_

---

## What to do with the answers

| Condition | Action |
|---|---|
| Q1 = A | Fill in `registry.yaml` (`project`, `repos`, `seedbed`); create artifact folders for types in use; update `AGENTS.md` `<!-- USER:BEGIN -->` section |
| Q1 = B or C | Read `registry.yaml` to confirm types + prefixes; follow the artifact dependency graph in `reference/artifact-dep-graph.md` |
| Q1 = D | Update `repos` section of `registry.yaml`; re-apply placeholders in `reference/` and `agents/` |
| Q1 = E | Use grep recipes in `reference/vault-queries.md` |
| Q1 = F | Scan for artifacts with `status: deprecated` or no `refs`; remove stale files |

Pass collected answers into your work as context. Do not re-ask questions the user already answered.
