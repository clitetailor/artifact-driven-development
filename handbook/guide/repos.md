# Guide: Repos

How repo layout works in an ADD vault and when to add repos.

Canonical sources:
- `agents/repo-mapping.md` — which agent writes to which repo
- `AGENTS.md` — sibling repo table and vault role
- `reference/folder-structure.md` — vault folder layout

For adding, remapping, or removing repos: `handbook/playbooks/manage-repos.md`.

---

## How repo layout works

Every agent has a write target and a PKM read source defined in `agents/repo-mapping.md`. Agents that write planning artifacts (BA, UX, Architect, QA) write to the docs vault. Agents that write code (Backend, Frontend, DevOps) write to their respective sibling repos and read planning artifacts from the vault.

`AGENTS.md` is the human- and agent-facing entry point that names the sibling repos and their paths.

No repos are required at setup time. The vault is useful on its own for planning — you can write features, requirements, and design artifacts before any code repo exists. Add repos on demand when you're ready to route implementation work to them.

---

## Incremental repo setup

Start with just the vault. Add repos when a planning artifact needs an implementation target.

**Typical progression:**

1. **Vault only** — plan features, write requirements, design APIs. No code repos needed.
2. **Add a backend repo** — when backend tasks are ready to implement.
3. **Add a frontend repo** — when frontend tasks are ready.
4. **Add infra** — when deployment planning begins.

Each addition is independent. Run `handbook/playbooks/manage-repos.md` for each repo when you need it.

---

## Monorepo vs. multi-repo

The vault works the same way in both layouts — only the paths differ.

**Multi-repo (default):** Each repo is a sibling directory. Agent write paths use `../` prefix (e.g., `../{backend-repo}/`). The vault is one of the sibling directories.

**Monorepo:** All code and the vault live under one root. Agent write paths are relative to the monorepo root (e.g., `packages/backend/`). Update `agents/repo-mapping.md` write targets accordingly and remove the `../` prefix.

There is no other structural difference — artifact types, ownership, and the dep graph are layout-agnostic.
