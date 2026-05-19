# Artifact-Driven Development Lifecycle — Agent Instructions

**Before doing anything else, read this file in full.**

---

## Project Role

Planning docs and implementation artifacts for a software project.
Code lives in sibling repos (`{frontend-repo}`, `{backend-repo}`).
All design artifacts are stored in this repo (`{docs-repo}`) as a PKM vault.

---

## Sibling Repos

| Directory | Purpose |
|---|---|
| `../{frontend-repo}/` | Frontend application |
| `../{backend-repo}/` | Backend API |
| `../{infra-repo}/` | Infrastructure / deployment repo |
| `../{docs-repo}/` | Documentation vault — plans, SDLC artifacts |

---

## Vault Folder Structure

```
{docs-repo}/
├── _registry.md            # Artifact type + feature registry (source of truth)
├── research-notes/         # Raw discovery notes, interview summaries  (rn-)
├── personas/               # Synthesized user archetypes               (persona-)
├── features/               # Feature-level scope documents             (feat-)
├── requirements/           # PRDs — scoped feature requirements        (req-)
├── stories/                # User narratives + acceptance criteria      (story-)
├── tasks/                  # Decomposed implementation units           (task-)
├── architecture-decisions/ # ADRs                                      (adr-)
├── quality-requirements/   # NFRs                                      (qr-)
├── api-contracts/          # Endpoint specs, request/response shapes   (api-)
├── data-models/            # Schemas, indexes, migration notes         (dm-)
├── user-flows/             # User journey diagrams (Mermaid embedded)  (uf-)
├── wireframes/             # ASCII wireframes per screen               (wf-)
├── component-specs/        # UI component specs                        (cs-)
├── implementation-notes/   # Optional cross-cutting impl notes         (in-)
├── infra/                  # IaC specs, CI/CD, monitoring, runbooks    (infra-)
├── change-requests/        # Inter-agent artifact modification requests (cr-)
├── advisories/             # Non-blocking orchestrator warnings         (adv-)
├── agents/                 # Agent design docs + repo/skill mappings
├── conventions/            # Enforced conventions (prescriptive)
├── reference/              # On-demand reference: vocabulary, lifecycle, ownership
├── handbook/               # Agent workflow guides and source/planning docs
└── templates/              # Artifact doc templates
```

**Reference docs** (read when the task requires it — not by default):
- Vocabulary → `reference/artifact-vocabulary.md`
- Status lifecycles → `reference/artifact-lifecycle.md`
- Agent roles & ownership → `reference/artifact-ownership.md`

**Scaffold workflow docs**:
- For agents starting in a new project → `STARTER-PROMPT.md`
- For human setup and retention guidance → `README.md`
- For copy/setup steps → `REPLICATION-STEPS.md`, `CUSTOMIZATION-CHECKLIST.md`

---

## Artifact Conventions

### Frontmatter (required on every vault artifact)

```yaml
---
id: {prefix}-{feature}-{descriptor}
type: {artifact-type}
owner: {agent-slug}
status: draft
version: 1.0
feature: {feature-slug}
hard-deps:
  - {upstream-artifact-id}
soft-deps:
  - {recommended-artifact-id}
refs:
  - {all-linked-artifact-ids}
---
```

Every `hard-dep` and `soft-dep` must also appear in `refs`.
`refs` is the superset of all links.

### ID Naming

Pattern: `{prefix}-{feature}-{descriptor}` — lowercase, hyphen-separated only.

| Type | Prefix | Example |
|---|---|---|
| research-note | `rn-` | `rn-discovery-notes` |
| persona | `persona-` | `persona-primary-user` |
| feature | `feat-` | `feat-user-authentication` |
| requirement | `req-` | `req-user-authentication` |
| story | `story-` | `story-user-login` |
| user-flow | `uf-` | `uf-user-authentication` |
| wireframe | `wf-` | `wf-login-screen` |
| component-spec | `cs-` | `cs-login-form` |
| architecture-decision | `adr-` | `adr-session-strategy` |
| api-contract | `api-` | `api-user-authentication` |
| data-model | `dm-` | `dm-user-authentication` |
| quality-requirement | `qr-` | `qr-auth-performance` |
| task | `task-` | `task-token-generation-be` |
| infra | `infra-` | `infra-user-authentication` |
| change-request | `cr-` | `cr-api-missing-rate-limit` |
| advisory | `adv-` | `adv-missing-qr-before-adr` |

No auto-incrementing integers. No timestamps in IDs.

### Registry

Before writing any new artifact type or feature, verify it exists in `_registry.md`.
If missing, add it before writing the artifact.

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

## Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Features and modules are listed in `_registry.md` — read it first to scope queries.

```bash
# All artifacts for a feature
rg -l --glob '!.*' "feature: user-authentication" {docs-repo}/

# All artifacts of a given type
rg -l --glob '!.*' "type: api-contract" {docs-repo}/

# All accepted artifacts for a feature
rg -l --glob '!.*' "feature: user-authentication" {docs-repo}/ | xargs rg -l "status: accepted"

# All artifacts that hard-dep on a specific artifact
rg -l --glob '!.*' "hard-deps:.*api-user-authentication" {docs-repo}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {docs-repo}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: req-user-authentication" {docs-repo}/
```

---

## Token Efficiency Rules

- **Ask before acting on ambiguity.** If a task or requirement is unclear, ask first.
- **Think before acting.** Read all relevant artifact and conventions docs before writing any agent prompt.
- **Only read what the task requires.** Read the target artifact and its direct hard-deps. Do not read artifacts owned by other agents unless explicitly referenced by the task.
- **Do not re-read files already read in this session** unless the file may have changed.
- **Use `offset`/`limit` on Read for large files.** When only a specific section is needed (e.g. frontmatter, a single entity definition), read only that portion — not the whole file.
- **One read is enough as a pattern.** When applying the same structural change to multiple similar files (e.g. adding a deployment note to three data-models), read one file to confirm the pattern, then edit the rest without re-reading each.
- **Prefer editing over rewriting.** Use Edit for targeted changes; Write for new files or full rewrites.
- **Batch edits to the same file efficiently.** For small files or clustered changes, combine into a single Edit or Write. For large files with sparse changes across sections, use one targeted Edit per changed section — do not Write the whole file just to avoid multiple calls.
- **Keep agent prompts concise.** No preamble, no restating context the agent doesn't need.
- **Pass paths, not content.** Standards docs and vault artifacts are stable — give the path.
- **Load reference docs on demand.** Vocabulary, lifecycle rules, and ownership tables live in `reference/` — read them only when the task requires resolving a status transition, ownership question, or unfamiliar term. Never load `handbook/` docs unless explicitly directed.
- **Skip CRs, advisories, and ADRs unless explicitly required.** Do not read `change-requests/cr-*`, `advisories/adv-*`, or `architecture-decisions/adr-*` files for orientation. Read them only when the task doc has a hard-dep on a specific decision that directly affects implementation.
- User instructions always override these rules.
