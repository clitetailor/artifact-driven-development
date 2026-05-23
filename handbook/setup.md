# ADD Setup

> Reference this file in your AI chat to set up or use Artifact-Driven Development in a project.
> The agent will ask you a set of questions, then run the right playbook.

---

## For The Agent

The user has referenced this file. Ask all questions below in a single message, then dispatch based on the answers. Do not ask one question at a time.

For setup questions (Q2, Q2a/b/c, Q3): act on the option the user picks —
- **S** — preserve existing config, move on
- **A** — append new entries without touching existing ones
- **U** — modify existing entries

Skip any question the user has already answered in their opening message.

---

## Questions

### Q1 — Intent

What do you want to do?

- **A** — Set up this repo with ADD for the first time
- **B** — Plan a new feature
- **C** — Plan a change or fix to an existing feature
- **D** — Manage repos (add, remap, or remove a repo)
- **E** — Customize ADD (add/remove artifact types, modify SDLC workflow, agent skills)
- **F** — Clean up stale or unused artifacts

---

### Q2 — Repo layout

- **S** — Skip — already configured in `AGENTS.md`, no change needed
- **U** — Update — layout is changing (answer below)

If U: how is this project laid out?
- Monorepo — all code and docs in one repo
- Multi-repo — sibling directories on the same machine
- Multi-repo — separate remotes

---

### Q2a — Frontend repos _(ask only for Q2 = U, or when adding repos to an existing setup)_

- **S** — Skip — already configured, no change
- **A** — Add — adding new frontend repos (list names below)
- **U** — Update — changing an existing frontend repo name or path (list old → new below)

Examples: `web`, `mobile`, `admin-ui`

---

### Q2b — Backend repos _(ask only for Q2 = U, or when adding repos to an existing setup)_

- **S** — Skip — already configured, no change
- **A** — Add — adding new backend repos (list names below)
- **U** — Update — changing an existing backend repo name or path (list old → new below)

Examples: `api`, `auth-service`, `data-pipeline`

---

### Q2c — Infra repo _(ask only for Q2 = U, or when adding repos to an existing setup)_

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

- **A** — Full SDLC — feature, requirements, design artifacts, tasks
- **B** — Selected artifacts — pick only what this scope needs
- **C** — Change request only — a targeted correction, no new planning artifacts _(only valid when Q1 = C)_

---

## Dispatch

Once you have the answers, read the matching playbook in full before starting.

| Condition | Playbook |
|---|---|
| Q1 = A | `handbook/playbooks/setup-new-repo.md` |
| Q1 = B | `handbook/playbooks/plan-feature.md` |
| Q1 = C, Q5 = A or B | `handbook/playbooks/plan-feature.md` |
| Q1 = C, Q5 = C | `handbook/playbooks/plan-change.md` |
| Q1 = D | `handbook/playbooks/manage-repos.md` |
| Q1 = E | `handbook/guide/` — point the user to the relevant guide |
| Q1 = F | `handbook/playbooks/cleanup-artifacts.md` |

Pass collected answers into the playbook as context. Do not re-ask questions the user already answered.

---

## Standalone Use

Each playbook in `handbook/playbooks/` can also be run directly without going through this file.
Every playbook starts with a short prerequisites block listing what context it needs.
