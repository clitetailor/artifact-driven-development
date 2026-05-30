# Guide: Agent Skills

How to configure agent roles, repo mappings, and skill integrations.

Canonical sources:
- `_registry.md` — repo mapping, skills, artifact types, and ID prefixes
- `reference/artifact-ownership.md` — which agent owns which artifact type
- `agents/{role}.md` — per-agent design doc (capabilities, PKM access, runtime references)

---

## Agent roster

Eight agent roles ship by default:

| Role | Writes to |
|---|---|
| project-manager | `{docs-repo}/` (status + advisories) |
| business-analyst | `{docs-repo}/` |
| product-designer | `{docs-repo}/` |
| software-architect | `{docs-repo}/` |
| qa-engineer | `{docs-repo}/` |
| backend-engineer | `../{backend-repo}/` |
| frontend-engineer | `../{frontend-repo}/` |
| platform-engineer | `../{infra-repo}/` |

---

## Adding a skill

Skills extend what an agent can do within its scope — they do not change artifact ownership or repo boundaries.

**1. Install or locate the skill**

Skills may be Claude Code slash commands, external tools, or MCP integrations. Note the install path or command.

**2. Register in `_registry.md` → Skills**

Add a row to the **Skills** table:

| Skill | Source | Status | Applied to |
|---|---|---|---|
| `{skill-name}` | `{install path or repo}` | `active` | `{phases or artifact types it applies to}` |

**3. Update the relevant agent design doc**

Open `agents/{role}.md` and add the skill under a `## Skill Composition` section (create the section if it doesn't exist). Describe when the skill is invoked and what it produces.

**4. Mark deferred skills**

If a skill is planned but not yet installed, set `Status: deferred` in the skills table. Deferred entries are reminders, not active configuration.

---

## Adding an agent role

Use this when your project needs a specialist role that doesn't exist in the default roster (e.g., a dedicated data engineer, a security reviewer).

**1. Create the agent design doc**

Copy the closest existing doc (e.g., `agents/software-architect.md`) to `agents/{new-role}.md`. Update:
- **Role** — one-sentence description
- **Capabilities** — what this agent can do
- **Authority** — what decisions it owns vs. defers
- **PKM Access** — what it reads and writes
- **Runtime References** — which vault files it loads at invocation

**2. Add to `_registry.md` → Repo Mapping**

Add a row with the new role's write and read targets.

**3. Add to `reference/artifact-ownership.md`**

Add a row under **Artifact Ownership** mapping the new agent to the artifact types it owns. If the new agent takes ownership of types previously owned by another agent, update the existing row for that agent too.

**4. Add to the SDLC phase sequence**

Edit `reference/sdlc-phases.md` — add the agent to the **Agents** column of the phase(s) where it is active.
Edit `handbook/sdlc-workflows.md` — add it to the **Agent Activation Order** tree and the **Actors** table.

---

## Removing an agent role

Before removing a role, reassign its artifact ownership to another agent in `reference/artifact-ownership.md`. An artifact type with no owner will cause the project-manager to skip it silently.

Then remove the role from:
- `_registry.md` → Repo Mapping
- `handbook/sdlc-workflows.md` — Actors table and Agent Activation Order
- `reference/sdlc-phases.md` — Phase Summary agents column
- `agents/{role}.md` — delete the file

---

## Conventions passed per agent

When activating an agent for implementation work, pass the relevant convention files by path — do not embed their content in the prompt. The current convention-to-agent mapping is in `reference/artifact-ownership.md` under **Conventions to Pass per Agent**.

To update the mapping (e.g., adding a new convention file for a new agent):
1. Create `conventions/{new-convention}.md`
2. Add the file to the **Conventions to Pass per Agent** table in `reference/artifact-ownership.md`
