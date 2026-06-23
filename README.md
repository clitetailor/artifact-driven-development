# Artifact-Driven Development

Artifact-Driven Development (ADD) is a methodology that leverages a Personal Knowledge Management (PKM) vault of artifacts to drive the Software Development Life Cycle (SDLC). In this approach, artifacts—such as specifications, architectural decisions, requirements, and tasks—enforce the development process rather than merely supplementing it.

The architecture comprises four core components:

- **Artifact Vault** — A structured PKM consisting of planning documents.
- **Agent Roles** — Distinct roles, each owning a specific subset of artifact types and responsibilities.
- **Agent Skill Mappings** — Mappings that associate agent capabilities with specific tasks (currently not built-in; they can be added manually or extended in the future).
- **SDLC & Artifact Dependency Graph** — A phase-ordered workflow featuring explicit upstream dependencies among artifacts.

These components are designed for maximum flexibility. You can add or remove artifact types to tailor the workflow to your specific needs. The SDLC phases can be adjusted, and skill mappings can be reconfigured. This project provides a foundational scaffold, enabling anyone to construct and evolve their own customized PKM-driven development workflow.

## Table of Contents

- [Why It Works for AI-Assisted Development](#why-it-works-for-ai-assisted-development)
- [Artifacts](#artifacts)
- [Repo Layout](#repo-layout)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Walkthrough — Fictional Issue-Tracker Project](#walkthrough--fictional-issue-tracker-project)
- [Upgrading the Framework](#upgrading-the-framework)
- [Background](#background)
- [License](#license)

---

## Why It Works for AI-Assisted Development

Without structured processes, coding agents tend to improvise—silently filling gaps, adopting inconsistent patterns, and losing context across sessions. ADD addresses these challenges through five key properties that ensure agent behavior remains reliable and consistent:

**On-Demand Artifact Creation Prevents Documentation Bloat**  
There is no need to generate all artifact types upfront. Developers can specify which artifacts to create or update, or they can allow the coding agent to decide based on the current task. Because artifacts are created only when the workflow demands them, the vault remains streamlined. Consequently, coding agents load a focused, task-relevant context rather than an ever-expanding set of documents that accumulates regardless of the current scope.

**Frontmatter References Enable Tracing and Cross-Validation**  
Every artifact links to its upstream, downstream, and lateral counterparts via the `refs` field in its frontmatter. When executing a task, a coding agent can follow these links to trace the original intent, navigate related architectural decisions, and cross-validate requirements before taking action—all without needing to blindly search the entire codebase.

**A Centralized Design Document Layer Facilitates Early Verification**  
By consolidating all design artifacts in one location, agents can verify consistency and identify conflicts early in the workflow rather than mid-implementation. This centralization enforces uniformity throughout the codebase and is cost-effective: agents read the vault directly to understand the architecture and design, bypassing the need to infer it by scanning the source code.

**Fine-Grained Tasks Reduce Ambiguity**  
Smaller, tightly scoped tasks with detailed instructions give coding agents less room to misinterpret intent. Furthermore, each task links back to its related design artifacts. If gaps appear during implementation, the agent has immediate access to rich context from upstream decisions, preventing it from having to guess or halt progress. Clear, concrete "done" conditions on each task also make verifying the final output straightforward.

**An Isolated Convention Layer Enforces Best Practices**  
Large, legacy, or multi-contributor codebases inevitably accumulate inconsistent patterns over time. If a coding agent relies solely on reading existing code, it may absorb and propagate these inconsistencies. By defining coding conventions within the vault, the vault serves as the authoritative source for how new code should be written, effectively overriding the current state of the codebase.

---

## Artifacts

Artifacts serve as the fundamental unit of work within the vault. Each artifact is a Markdown file containing frontmatter, a specific ID prefix, and explicit references to its upstream dependencies. This scaffold includes 17 artifact types that span the entire SDLC:

**Requirements**
- `fb-` — Feature brief (a lightweight requirements-root type).
- `prd-` — Product requirements document (a comprehensive requirements-root type, and the framework's default).
- `pr-` — Press release (a requirements-root type utilizing a working-backwards approach).
- `story-` — A verifiable unit of user value.

**Design**
- `uf-` — User flow with a journey overview (incorporates user journey maps).
- `ds-` — Design spec (combines wireframes and component specifications).

**Architecture**
- `adr-` — Architecture decision record.
- `sa-` — System architecture with embedded ADRs (incorporates broader architecture decisions).
- `api-` — API spec (details external contracts only).
- `dd-` — Data design (covers internal data shapes and detailed data flows).

**Development**
- `td-` — Technical design (feature-scoped).
- `task-` — A fine-grained unit of implementation work.

**Planning**
- `plan-` — A deliverable hierarchy (requirements-root → stories → tasks) complete with effort estimates and rolled-up totals. It features optional sections for effort rollup, sequencing rationale, task lanes, and unparented tasks, scaling seamlessly with team size and task complexity.

**Verification**
- `ts-` — Test spec with an embedded test plan (incorporates test planning).

**General**
- `note-` — An ad-hoc scratchpad available for any agent at any time.

The complete list of artifact types, ID prefixes, agents, skills, and statuses can be found in `manifest.yaml`. The artifact dependency graph—which dictates the required sequence of artifact creation—is located in `reference/artifact-dep-graph.md`.

---

## Repo Layout

Refer to [`reference/folder-structure.md`](reference/folder-structure.md) for the complete vault folder tree and root file details.

**The `handbook/` Subfolders**

| Folder | Purpose |
|---|---|
| `handbook/README.md` | The handbook index, containing links to playbooks and conceptual reference documents. |
| `handbook/customization.md` | Instructions on how to switch the requirements-root type and adjust the ask-threshold policy via customization files. |
| `handbook/playbooks/` | Agent-driven procedures. Reference these in your AI chat to perform setup or customization walkthroughs. |
| `handbook/customizations/` | Customization files organized by axis, with all alternatives presented side-by-side (see `handbook/customizations/README.md`). |

---

## Prerequisites

| Tool | Required | Purpose |
|---|---|---|
| [**git**](https://git-scm.com/) | Yes | Version control for committing vault changes. |
| [**rg**](https://github.com/BurntSushi/ripgrep) (ripgrep) | Yes | Artifact discovery. All vault queries utilize `rg` against frontmatter fields (see `reference/vault-queries.md`). |

---

## Getting Started

This setup supports multi-repo configurations where your artifact vault resides as a sibling directory to your active code repositories.

### Walkthrough — Fictional Issue-Tracker Project

Assume you are initiating a new project named `issue-tracker` featuring a React frontend (`issue-tracker-web`) and a Node API (`issue-tracker-api`). Follow these steps to initialize and align your vault:

1. **Clone this seedbed to initialize your project's vault.**  
   Assuming the parent directory `issue-tracker/` exists alongside your initialized sibling code repositories:
   ```bash
   git clone https://github.com/clitetailor/artifact-driven-development issue-tracker/issue-tracker-vault
   cd issue-tracker/issue-tracker-vault
   ```
   Your workspace should now resemble this structure:
   ```text
   issue-tracker/
   ├── issue-tracker-vault/     ← Your project's artifact vault ({vault-root})
   ├── issue-tracker-web/       ← Sibling code repository
   └── issue-tracker-api/       ← Sibling code repository
   ```

2. **Run the setup playbook.**  
   Open your coding agent within `{vault-root}` (the `issue-tracker-vault/` folder) and execute the setup playbook located at `handbook/playbooks/setup.md`. The agent will configure your project metadata, link the upstream seedbed reference, and map the sibling repository paths in `manifest.yaml`.

3. **Customize your vault.**  
   Run the customization playbook to select your preferred options across various customization axes (e.g., active requirements-root type, ask-threshold policy, or artifact ID dating format). Consult the procedures in `handbook/playbooks/customize-vault.md` and read `handbook/customization.md` for background on how alternative configurations are structured.

4. **Develop with the vault.**  
   Utilize your newly configured vault to draft versioned artifacts (requirements, designs, plans, and tasks) and to orchestrate development across your sibling code repositories.

---

## Upgrading the Framework

The vault's `manifest.yaml` includes a `framework_version` field, indicating the last synced version of the upstream seedbed. When a new version is released upstream, framework-owned files (such as `handbook/`, `reference/`, `agents/`, and `README.md`) are updated automatically, and `AGENTS.md` undergoes a 3-way merge. User-owned content (e.g., `manifest.yaml`, `templates/`, `conventions/`, and all vault folders) remains untouched. The seedbed source and reference are tracked under the `seedbed` key in `manifest.yaml`. In the future (Phase 3), the `orchard upgrade` CLI command will automate this process using a git-style 3-way merge.

---

## Background

ADD originated as a spec-driven folder containing Markdown plan files designed to coordinate a multi-repo project. Seeking to integrate more SDLC structure into that workflow, I explored existing tools. While OpenSpec supported research and planning well, it lacked the flexibility required to model the full development lifecycle precisely on my terms.

The PKM angle emerged serendipitously. While collaborating with an AI assistant to standardize the folder layout, the suggested structure closely mirrored the organizational paradigms used by PKM tools like Capacities and Obsidian. This convergence introduced the PKM framing into the project.

Subsequently, the repository was restructured into an artifact-based layout. Initially skeptical about its practical viability, I found the approach highly effective. The framework performs exceptionally well for both greenfield and brownfield projects. For an existing codebase, I was able to reverse-sync the project's architecture—including feature modules, API contracts, and data models—into the artifact vault, establishing it as the definitive single source of truth moving forward.

ADD represents an ongoing effort to formalize this structure, allowing it to be versioned, shared, and evolved rather than reinvented for every new project.

This project draws inspiration from SpecKit and OpenSpec.

---

## License

MIT — See [`LICENSE`](LICENSE) for details.