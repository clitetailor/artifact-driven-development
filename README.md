# Artifact-Driven Development

Artifact-Driven Development (ADD) uses a Personal Knowledge Management (PKM) vault to drive your Software Development Life Cycle (SDLC). Instead of just supplementing your codebase, structured artifacts (specs, decisions, tasks) actively enforce your development process.

The framework is built on four flexible components:
- **Artifact Vault:** A local PKM of structured Markdown planning documents.
- **Agent Roles:** Defined scopes of responsibility for AI coding agents.
- **Skill Mappings:** Tool and action permissions scoped to specific tasks (extensible).
- **Dependency Graph:** A phase-ordered workflow where every artifact explicitly links to its upstream context.

*Everything is customizable. You can add or remove artifact types, tweak the SDLC phases, and evolve the workflow as your project grows.*

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Repo Layout](#repo-layout)
- [Artifacts](#artifacts)
- [Why It Works for AI-Assisted Development](#why-it-works-for-ai-assisted-development)
- [Upgrading the Framework](#upgrading-the-framework)
- [Inspirations](#inspirations)
- [License](#license)

## Prerequisites

| Tool | Required | Purpose |
|---|---|---|
| [**git**](https://git-scm.com/) | Yes | Version control for committing vault changes. |
| [**rg**](https://github.com/BurntSushi/ripgrep) (ripgrep) | Yes | Artifact discovery. All vault queries utilize `rg` against frontmatter fields (see `reference/vault-queries.md`). |

---

## Getting Started

The fastest way to understand ADD is to spin up a vault and see it in action. This setup supports multi-repo configurations where your artifact vault resides as a sibling directory to your active code repositories.

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

## Repo Layout

Once your vault is initialized, it helps to understand where everything lives. Refer to [`reference/folder-structure.md`](reference/folder-structure.md) for the complete vault folder tree and root file details.

**The `handbook/` Subfolders**

| Folder | Purpose |
|---|---|
| `handbook/README.md` | The handbook index, containing links to playbooks and conceptual reference documents. |
| `handbook/customization.md` | Instructions on how to switch the requirements-root type and adjust the ask-threshold policy via customization files. |
| `handbook/playbooks/` | Agent-driven procedures. Reference these in your AI chat to perform setup or customization walkthroughs. |
| `handbook/customizations/` | Customization files organized by axis, with all alternatives presented side-by-side (see `handbook/customizations/README.md`). |

---

## Artifacts

Within this repository layout, the actual work is captured in **Artifacts**. Artifacts are the fundamental units of work in the vault. Each is a Markdown file with a specific ID prefix, frontmatter, and explicit references to upstream dependencies.

The framework categorizes artifacts across the entire Software Development Life Cycle (SDLC):
- **Requirements** (`prd-`, `story-`, etc.) to define what to build.
- **Design & Architecture** (`uf-`, `sa-`, `api-`, etc.) to define how it looks and behaves.
- **Planning & Development** (`plan-`, `td-`, `task-`, etc.) to break down and implement the work.
- **Verification** (`ts-`) to ensure it works.

*The complete list of artifact types, ID prefixes, agents, skills, and statuses can be found in `manifest.yaml`. The artifact dependency graph—which dictates the required sequence of artifact creation—is located in `reference/artifact-dep-graph.md`.*

---

## Why It Works for AI-Assisted Development

Understanding the layout and the artifact types clarifies *what* ADD is, but *why* does this structure matter? Without structured processes, coding agents tend to improvise—silently filling gaps, adopting inconsistent patterns, and losing context across sessions. ADD addresses this through:

- **On-Demand Context:** Artifacts are created only when needed. Coding agents load a focused, task-relevant context rather than an ever-expanding, bloated document set.
- **Explicit Tracing:** `refs` in the frontmatter link artifacts to their upstream requirements and downstream tasks. Agents can trace original intent without blindly searching the codebase.
- **Early Verification:** Consolidating design documents allows agents to catch conflicts early. They read the vault to understand architecture instead of inferring it from source code.
- **Reduced Ambiguity:** Fine-grained, well-scoped tasks with clear "done" conditions leave agents less room to misinterpret intent.
- **Isolated Conventions:** Defining coding conventions in the vault prevents agents from absorbing and propagating legacy inconsistencies from the existing codebase.

---

## Upgrading the Framework

ADD safely separates framework logic from your project data. Your `manifest.yaml` tracks the `framework_version` and upstream seedbed repository.

When upgrading to a new version:
- **Framework-owned files** (`handbook/`, `reference/`, `agents/`, `README.md`) sync automatically.
- **User-owned files** (`manifest.yaml`, `templates/`, `conventions/`, and your actual vault artifacts) are completely untouched.
- **Shared files** (`AGENTS.md`) undergo a standard 3-way git merge.

*(Note: In Phase 3, an `orchard upgrade` CLI command will fully automate this git-style merge process).*

---

## Inspirations

ADD didn't emerge in a vacuum. It adapts core concepts from several excellent tools to create a framework built specifically for AI-assisted development:

- **[SpecKit](https://github.com/dtauraso/speckit) and [OpenSpec](https://openspec.ai/):** These tools proved the value of spec-driven development using structured Markdown. While they excel at project planning, ADD extends this philosophy across the entire Software Development Life Cycle (SDLC) to cover implementation and verification.
- **[Capacities](https://capacities.io/) and [Obsidian](https://obsidian.md/):** The "artifact vault" is directly inspired by Personal Knowledge Management (PKM) systems. By organizing information into tightly scoped, standardized files linked via frontmatter, ADD creates a knowledge graph that coding agents can traverse exactly like humans do.
- **[Jira](https://www.atlassian.com/software/jira):** The artifact dependency graph borrows from Jira's column-based workflows, which serve as an assistive tool to reduce human error. Just as Jira relies on a strict "Definition of Done", ADD requires explicit artifact generation to close out a task. This ensures humans and coding agents communicate efficiently through a shared, verifiable baseline before any code is written.

---

## License

MIT — See [`LICENSE`](LICENSE) for details.