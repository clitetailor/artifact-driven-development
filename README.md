# Artifact-Driven Development

Artifact-Driven Development (ADD) is a method that uses a Personal Knowledge Management (PKM) vault of artifacts to drive the software development lifecycle (SDLC). Artifacts — specs, decisions, requirements, tasks — are what enforce the development process, not just supplement it.

The architecture is made up of four components:

- **Artifact vault** — a structured PKM of planning docs
- **Agent roles** — defined roles, each owning a slice of artifact types and responsibilities
- **Agent skill mappings** — maps agent capabilities to tasks (not yet built-in; can be added manually or extended later)
- **SDLC + artifact dependency graph** — phase-ordered workflow with explicit upstream dependencies between artifacts

All components are designed to be flexible. The number of artifact types can be added or removed to fit the developer's development workflow. The SDLC can be adjusted. Skill mappings can be reconfigured. This project provides the base scaffold so anyone can start building their own PKM development workflow and evolve it over time.

---

## Prerequisites

| Tool | Required | Purpose |
|---|---|---|
| [**git**](https://git-scm.com/) | Yes | Version control — committing vault changes |
| [**rg**](https://github.com/BurntSushi/ripgrep) (ripgrep) | Yes | Artifact discovery — all vault queries use `rg` against frontmatter fields (see `reference/vault-queries.md`) |

---

## Why It Works for AI-Assisted Development

Without structure, coding agents improvise — filling gaps silently, absorbing inconsistent patterns, and losing context across sessions. ADD addresses this through five properties that make agent behavior more reliable and consistent.

**Artifact types are created on-demand, preventing design doc bloat.** There is no need to create all artifact types upfront — developers can specify which artifacts to create or update, or let the coding agent decide based on the task. Because artifacts only exist when the workflow needs them, the vault stays lean — coding agents load a focused, task-relevant context rather than a growing document set that accumulates regardless of scope.

**Frontmatter refs let coding agents trace original intent and cross-validate requirements across related artifacts.** Every artifact links to its upstream, downstream, and sideways artifacts through the `refs` field. When working on a task, a coding agent follows these links to trace the chain of intent, navigate to related decisions, and cross-validate requirements before acting — without having to search the codebase.

**A central design doc layer lets coding agents pre-verify requirements before creating tasks or writing code.** With all design artifacts in one place, agents can check consistency and catch conflicts early in the workflow rather than mid-implementation. This also enforces consistency throughout the codebase. It is also cost-effective — agents read the vault to understand architecture and design directly, rather than navigating the codebase to infer it.

**Fine-grained tasks with detailed instructions reduce ambiguity and help coding agents comply with requirements.** Smaller, well-scoped tasks give coding agents less room to misinterpret intent. Each task also links to its related design artifacts — when gaps arise mid-implementation, the agent has direct access to richer context from upstream decisions rather than having to guess or halt. Concrete done conditions on each task also make it straightforward to verify the output against the original intent.

**A separated convention layer enforces best practices on new code changes, independent of the existing codebase.** Large, legacy, or multi-contributor codebases accumulate inconsistent patterns over time — a coding agent reading existing code would absorb and propagate those patterns forward. By defining conventions in the vault, the vault becomes the authoritative source for how new code should be written, regardless of what the codebase currently looks like.

---

## Artifacts

Artifacts are the unit of work in the vault. Each one is a Markdown file with frontmatter, an ID prefix, and explicit references to its upstream artifacts. The scaffold ships with 17 artifact types covering the full SDLC:

**Requirements**
- `fb-` — feature brief (lighter requirements-root type)
- `prd-` — product requirements document (requirements-root type, framework default)
- `pr-` — press release (requirements-root type, working-backwards framing)
- `story-` — a verifiable unit of user value

**Design**
- `uf-` — user flow with journey overview (absorbs user-journey-map)
- `ds-` — design spec (merges wireframe + component-spec)

**Architecture**
- `adr-` — architecture decision record
- `sa-` — system architecture with embedded ADRs (absorbs architecture-decision)
- `api-` — API spec, external contract only
- `dd-` — data design, internal shapes + detailed data flows

**Development**
- `td-` — technical design, feature-scoped
- `task-` — a fine-grained unit of implementation work

**Planning**
- `plan-` — deliverable hierarchy (requirements-root → stories → tasks) with effort estimates and rolled-up sums; optional sections for effort rollup, sequencing rationale, task lanes, and unparented tasks scale with team size and task complexity

**Verification**
- `ts-` — test spec with embedded test plan (absorbs test-plan)

**General**
- `note-` — ad-hoc scratchpad (any agent, any time)

The full list of artifact types, ID prefixes, agents, skills, and statuses lives in `manifest.yaml`. The artifact dependency graph — which artifact must exist before which — lives in `reference/artifact-dep-graph.md`.

---

## Repo Layout

**Root files**

| File | Purpose |
|---|---|
| `AGENTS.md` | Core operating instructions for agents working in the vault |
| `manifest.yaml` | Source of truth for artifact types, ID prefixes, agents, skills, and statuses |
| `PROJECT.md` | Human-readable project overview (active tasks, requirements roots, status) |
| `README.md` | This file — entry point for humans and agents |

**Folders**

| Folder | Purpose |
|---|---|
| `reference/` | AI-friendly reference docs: vocabulary, lifecycle, ownership, dep graph, frontmatter, vault queries, folder structure, coordination decision tree |
| `handbook/` | Entry point, customization guide, and playbooks |
| `handbook/README.md` | Handbook index — links to playbooks and conceptual reference docs |
| `handbook/customization.md` | How to switch the requirements-root type and ask-threshold policy via customization files |
| `handbook/playbooks/` | Agent-driven procedures — reference in your AI chat to walk through setup or customization |
| `handbook/customizations/` | Customization files — one per axis, all alternatives side-by-side (see `handbook/customizations/README.md`) |
| `templates/` | Artifact doc templates, one per artifact type |
| `agents/` | Agent role definitions and repo/skill mappings |
| `conventions/` | Enforced project conventions |
| `feature-briefs/`, `prds/`, `press-releases/`, `user-stories/`, `user-flows/`, `design-specs/`, `adrs/`, `system-architectures/`, `api-specs/`, `data-designs/`, `tech-designs/`, `tasks/`, `plans/`, `test-specs/`, `notes/` | Vault artifact folders, one per artifact type. Populated during onboarding. |

---

## Getting Started

The setup supports multi-repo configurations where your artifact vault lives as a sibling to your active code repositories.

### Walkthrough — fictional issue-tracker project

Assume you are starting a new project called `issue-tracker` with a React frontend (`issue-tracker-web`) and a Node API (`issue-tracker-api`). Steps to initialize and align your vault:

1. **Clone this seedbed to initialize your project's vault.** Assuming the parent project directory `issue-tracker/` already exists with the sibling code repositories initialized:
   ```bash
   git clone https://github.com/clitetailor/artifact-driven-development issue-tracker/issue-tracker-vault
   cd issue-tracker/issue-tracker-vault
   ```
   The workspace now looks like:
   ```
   issue-tracker/
   ├── issue-tracker-vault/     ← your project's artifact vault ({vault-root})
   ├── issue-tracker-web/       ← sibling code repository
   └── issue-tracker-api/       ← sibling code repository
   ```

2. **Run the setup playbook.** Open a coding agent in `{vault-root}` (the `issue-tracker-vault/` folder) and execute the setup playbook found in `handbook/playbooks/setup.md`. The agent will configure your project metadata, upstream seedbed reference, and sibling repository paths within `manifest.yaml`.

3. **Customize your vault.** Run the customization playbook to select your preferred options for each customization axis (such as the active requirements-root type, ask-threshold policy, or artifact-id-dating format). Reference the procedures in `handbook/playbooks/customize-vault.md` (see `handbook/customization.md` for the conceptual background on how alternatives are structured side-by-side).

4. **Develop with the vault.** Leverage your newly configured vault to draft versioned artifacts (requirements, designs, plans, and tasks) and orchestrate development across your sibling code repositories.
---

## Upgrading the Framework

The vault's `manifest.yaml` stores the `framework_version` field (the upstream seedbed version last synced). When upstream releases a new version, framework-owned files (`handbook/`, `reference/`, `agents/`, `README.md`) are synced and `AGENTS.md` is 3-way merged. User-owned content (`manifest.yaml`, `templates/`, `conventions/`, all vault folders) is never touched. The seedbed source and ref are stored in `manifest.yaml` under `seedbed`; the `orchard upgrade` CLI command (Phase 3) will automate this with a git-style 3-way merge.

---

## Background

ADD began as a spec-driven folder of Markdown plan files for coordinating a multi-repo project. Looking to integrate SDLC structure into that workflow, I evaluated existing tools — OpenSpec supported research and planning but lacked the flexibility I needed to model the full development lifecycle on my own terms.

The PKM angle emerged by accident. While working with Claude to standardize the folder layout, one of its suggested structures mapped almost exactly onto how Capacities and Obsidian organize a personal knowledge base. That convergence is what introduced the PKM framing to the project.

From there, the repo was refactored into an artifact-based layout. I was skeptical the approach would hold up in practice — but it did. The framework works for both greenfield and brownfield projects: on an existing codebase, I was able to reverse-sync the project architecture — including feature modules, API contracts, and data models — into the artifact vault and use it as the single source of truth going forward.

ADD is the effort to formalize that structure so it can be versioned, shared, and evolved rather than reinvented for every project.

The project draws inspiration from SpecKit and OpenSpec.

---

## License

MIT — see [`LICENSE`](LICENSE).
