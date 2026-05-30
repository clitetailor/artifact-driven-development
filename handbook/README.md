# Handbook
> Entry point for the SDLC AI Agent Framework handbook. The handbook is the **narrative companion** to the canonical schemas in `../reference/`.

## Three Lenses

The handbook describes the same system from three angles. Pick the one matching your question.

| Lens | Question it answers | File |
|---|---|---|
| **Agent** | Who does what? | [`agent-roles.md`](./agent-roles.md) |
| **Process** | When does it happen and what are the gates? | [`sdlc-workflows.md`](./sdlc-workflows.md) |
| **Artifact** | What is produced and how do artifacts relate? | [`artifact-dependency-graph.md`](./artifact-dependency-graph.md) |

Supporting docs:

- [`../templates/`](../templates/) — fillable body templates for every artifact type (CR, advisory, ADR, wireframe, user-flow, task, etc.)
- [`tdd-workflow.md`](./tdd-workflow.md) — QA-internal mechanics (red/green/refactor pairing)
- [`coordination-examples.md`](./coordination-examples.md) — worked examples

## Setup & Customization

| File / Folder | Purpose |
|---|---|
| [`setup.md`](./setup.md) | Prompt script — paste into AI chat to set up or use ADD in a project |
| [`playbooks/`](./playbooks/) | Step-by-step run instructions per scenario (agent + bash) |
| [`guide/`](./guide/) | Human guide for customizing ADD (artifacts, templates, SDLC, agent skills) |
| [`scripts/`](./scripts/) | Bash scripts called by playbooks |

### Playbooks

| Playbook | When to use |
|---|---|
| [`playbooks/setup-new-repo.md`](./playbooks/setup-new-repo.md) | First-time vault initialization |
| [`playbooks/plan-feature.md`](./playbooks/plan-feature.md) | Plan a new feature or enhancement |
| [`playbooks/plan-change.md`](./playbooks/plan-change.md) | File and apply a targeted change request |
| [`playbooks/manage-repos.md`](./playbooks/manage-repos.md) | Add, remap, or remove a repo |
| [`playbooks/cleanup-artifacts.md`](./playbooks/cleanup-artifacts.md) | Remove stale files or unused artifact type folders |

### Guide

| Guide | Covers |
|---|---|
| [`guide/artifacts.md`](./guide/artifacts.md) | Adding, removing, and naming artifact types |
| [`guide/templates.md`](./guide/templates.md) | Creating and modifying artifact templates |
| [`guide/sdlc-workflows.md`](./guide/sdlc-workflows.md) | Customizing tracks, phases, and gates |
| [`guide/repos.md`](./guide/repos.md) | Repo layout model and incremental setup |
| [`guide/agent-skills.md`](./guide/agent-skills.md) | Agent roles and skill integrations |

## Where the Specs Live

| Concern | File |
|---|---|
| Folder tree | `../reference/folder-structure.md` |
| Artifact types, prefixes, features, modules | `../_registry.md` |
| Frontmatter schema + ID naming pattern | `../reference/artifact-frontmatter.md` |
| Common status labels | `../reference/artifact-lifecycle.md` |
| Agent ownership per artifact type | `../reference/artifact-ownership.md` |
| Suggested creation order | `../reference/artifact-dep-graph.md` |
| Grep recipes for navigation | `../reference/vault-queries.md` |
| Vocabulary | `../reference/artifact-vocabulary.md` |
| Coordination decision tree | `../reference/coordination-decision-tree.md` |
| SDLC phase reference (PKM writes per phase, QA anchors) | `../reference/sdlc-phases.md` |
| Artifact body templates (one per type) | `../templates/` |

## Roles at a Glance

| Role | Lead phases | Owns |
|---|---|---|
| Business Analyst | 1 | research-notes, personas, features, requirements |
| Product Designer | 2 | user-flows, wireframes, component-specs |
| Software Architect | 2, 3 | ADRs, api-contracts, data-models, quality-requirements, backend tasks |
| QA Engineer | 2 (test-plan), 3 (specs/suites) | test-plans, test-specs, test-suites |
| Frontend Engineer | 3, 4 | frontend tasks, UI implementation |
| Backend Engineer | 4 | backend implementation, task notes |
| Platform Engineer | 5 | infra |
| Project Manager | all | advisories, milestone, status stamps |

Full responsibilities, capabilities, PKM scopes, and interaction patterns are in [`agent-roles.md`](./agent-roles.md).

## Conventions

- Each handbook file owns one lens; cross-references replace duplication.
- `reference/` is canonical for tables and schemas; handbook is narrative.
- Artifact body templates live only in [`../templates/`](../templates/); schemas live in `../reference/`.
- Phase sequencing & gates live only in [`sdlc-workflows.md`](./sdlc-workflows.md).
- Per-agent ownership lives only in [`agent-roles.md`](./agent-roles.md).
