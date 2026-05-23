# Artifact-Driven Development

Artifact-Driven Development (ADD) is a method that uses a Personal Knowledge Management (PKM) vault of artifacts to drive the software development lifecycle (SDLC). Artifacts — specs, decisions, requirements, tasks — are what enforce the development process, not just supplement it.

The architecture is made up of four components:

- **Artifact vault** — a structured PKM of planning docs
- **Agent roles** — defined roles, each owning a slice of artifact types and responsibilities
- **Agent skill mappings** — maps agent capabilities to tasks (not yet built-in; can be added manually or extended later)
- **SDLC + artifact dependency graph** — phase-ordered workflow with explicit upstream dependencies between artifacts

All components are designed to be flexible. The number of artifact types can be added or removed to fit the developer's development workflow. The SDLC can be adjusted. Skill mappings can be reconfigured. This project provides the base scaffold so anyone can start building their own PKM development workflow and evolve it over time.

The setup supports multi-repo projects where the vault lives separately from the code repos as a sibling folder.

---

## Why It Works for AI-Assisted Development

With more refined discovery, proposal, and design steps across defined roles — and fine-grained task breakdown — it becomes more reliable to build a batch of features in a consistent, structural, and systematic way. It brings more engineering to AI-assisted workflow.

Without structure, agents improvise. With ADD:

- Agents receive bounded, well-defined context
- The vault persists intent across context resets and model sessions
- Roles and ownership reduce coordination ambiguity in multi-agent setups

---

## Artifacts

Artifacts are the unit of work in the vault. Each one is a Markdown file with frontmatter, an ID prefix, and explicit references to its upstream artifacts. The scaffold ships with a starting set of artifact types covering the full SDLC, for example:

- `persona-` — a user archetype the product is being built for
- `feat-` — a feature that captures a user-facing capability
- `req-` — a requirement, scoped to a feature
- `adr-` — an architecture decision record, capturing a durable constraint
- `task-` — a fine-grained unit of implementation work, tied back to a requirement
- `cr-` — a change request, used when an existing contract needs to evolve

The full list of artifact types, ID prefixes, and SDLC phase groupings lives in `_registry.md`. The SDLC phases themselves are defined in `reference/sdlc-phases.md`, and the artifact dependency graph — which artifact must exist before which — lives in `reference/artifact-dep-graph.md`.

---

## Repo Layout

**Root files**

| File | Purpose |
|---|---|
| `AGENTS.md` | Core operating instructions for agents working in the vault |
| `_registry.md` | Source of truth for artifact types, ID prefixes, features, and modules |
| `README.md` | This file — entry point for humans and agents |

**Folders**

| Folder | Purpose |
|---|---|
| `reference/` | AI-friendly reference docs: vocabulary, lifecycle, ownership, dep graph, SDLC phases, frontmatter, vault queries, folder structure, coordination decision tree |
| `handbook/` | Human-readable workflow guides: SDLC, TDD, role processes, coordination examples |
| `handbook/scaffold/` | Setup, onboarding, and customization docs for replicating this scaffold |
| `templates/` | Artifact doc templates, one per artifact type |
| `agents/` | Agent role definitions and repo/skill mappings |
| `conventions/` | Enforced project conventions |
| `_sources/` | Source material the framework was synthesized from (off-framework vocabulary — do not load by default) |
| `personas/`, `features/`, `requirements/`, `user-flows/`, `wireframes/`, `component-specs/`, `architecture-decisions/`, `api-contracts/`, `data-models/`, `quality-requirements/`, `test-plans/`, `test-specs/`, `test-suites/`, `tasks/`, `infra/`, `change-requests/`, `advisories/`, `milestones/`, `research-notes/` | Vault artifact folders, one per artifact type. Populated during onboarding. |

---

## Getting Started

The detailed setup docs live in `handbook/scaffold/`. Use this table as a map:

| Step | Doc |
|---|---|
| Overall replication procedure | `handbook/scaffold/replication-steps.md` |
| Customization checklist (what to rename, what to fill in) | `handbook/scaffold/customization-checklist.md` |
| Agent-facing onboarding prompt | `handbook/scaffold/starter-prompt.md` |
| Ongoing vault operation | `handbook/scaffold/onboarding.md` |
| Bootstrapping the vault into an existing repo | `handbook/scaffold/bootstrap.md` |
| Discovery questionnaire (for the first onboarding pass) | `handbook/scaffold/discovery-questionnaire.md` |

### Walkthrough — fictional issue-tracker project

Assume you are starting a new project called `issue-tracker` with a React frontend (`issue-tracker-web`) and a Node API (`issue-tracker-api`). Steps to bring up the vault:

1. **Create the workspace.**
   ```
   mkdir issue-tracker && cd issue-tracker
   ```
   This folder will hold the vault and all sibling code repos.

2. **Copy this scaffold into the workspace as the docs repo.**
   ```
   cp -r /path/to/artifact-driven-development ./issue-tracker-docs
   cd issue-tracker-docs
   ```

3. **Replace placeholders.** Open `AGENTS.md` and the templates under `templates/`. Replace `{docs-repo}` → `issue-tracker-docs`, `{frontend-repo}` → `issue-tracker-web`, `{backend-repo}` → `issue-tracker-api`. Walk the customization checklist (`handbook/scaffold/customization-checklist.md`) for the full list of placeholders.

4. **Initialize the sibling code repos** as sibling folders:
   ```
   cd ..
   git init issue-tracker-web
   git init issue-tracker-api
   ```
   The workspace now looks like:
   ```
   issue-tracker/
   ├── issue-tracker-docs/   ← this scaffold
   ├── issue-tracker-web/
   └── issue-tracker-api/
   ```

5. **Run the starter prompt.** Open a coding agent in `issue-tracker-docs/` and point it at `handbook/scaffold/starter-prompt.md`. The agent will inspect the workspace, ask clarifying questions about the product, and generate the first wave of artifacts (personas, features, initial requirements) from the templates.

6. **Iterate.** From here, work flows through the artifact dependency graph: features beget requirements, requirements beget design artifacts, design artifacts beget tasks. The `handbook/` workflow guides describe the day-to-day pattern.

---

## License

MIT — see [`LICENSE`](LICENSE).
