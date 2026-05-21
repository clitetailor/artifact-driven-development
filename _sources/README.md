---
type: meta
---

# Source Material

Real-world process descriptions that inspired this framework. **Inputs**, not outputs.

## What lives here

| File | Real-world process |
|---|---|
| `ba-ux.md` | Combined BA / UX-UI Designer workflow |
| `backend.md` | Backend Engineer workflow |
| `frontend.md` | Frontend Engineer workflow |

## How they relate to the rest of the repo

These docs were synthesized into the framework artifacts that coding agents and humans actually use:

- `reference/` — canonical schemas, vocabulary, lifecycle, ownership, dep graph (agent-friendly)
- `handbook/agent-roles.md` — role bios, capabilities, PKM scopes (human-friendly)
- `handbook/sdlc-workflows.md` — phase sequencing and gates (human-friendly)

The synthesis is one-way: changes to the framework do **not** flow back here, and these files are not kept in sync with `_registry.md`.

## Read rules

- **Coding agents**: do not load files in `_sources/` by default. They use off-framework vocabulary on purpose (e.g. `modules/<name>/design/`, `/update-design`) and will conflict with `_registry.md`, `reference/folder-structure.md`, and the artifact prefixes.
- **Humans**: read these only when extending the framework — e.g. adding a new role, rethinking a phase, or re-deriving an agent's responsibilities.

## Vocabulary mismatch is intentional

These files predate the framework and use ad-hoc terminology. Do not normalize them. If a real-world process changes and the framework needs updating, update the source here, then re-derive the relevant `reference/` and `handbook/` artifacts manually.
