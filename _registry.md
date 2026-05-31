---
type: registry
updated: YYYY-MM-DD
---

# Vault Registry

## Artifact Types

# REQUIREMENTS & PLANNING
- user-journey-map
- project-charter
- prd
- user-story
- stakeholder-matrix     # optional governance artifact

# DESIGN
- user-flow
- wireframe
- component-spec

# ARCHITECTURE
- system-architecture
- architecture-decision
- api-contract
- data-model
- quality-requirement

# DEVELOPMENT
- tech-design
- task

# TESTING & QA
- test-plan
- test-spec
- test-suite

# DEPLOYMENT & OPS
- infra

# WORKFLOW
- change-request
- advisory      # noted-for-future tracker
- milestone     # optional timeline coordination
- bug-report    # defect tracking; spawns fix task or closed directly

## ID Prefixes
- user-journey-map       : ujm-
- project-charter        : charter-
- prd                    : prd-
- user-story             : story-
- stakeholder-matrix     : sm-
- milestone              : ms-
- user-flow              : uf-
- wireframe              : wf-
- component-spec         : cs-
- system-architecture    : sa-
- architecture-decision  : adr-
- api-contract           : api-
- data-model             : dm-
- tech-design            : td-
- quality-requirement    : qr-
- test-plan              : tp-
- test-spec              : ts-
- test-suite             : suite-
- task                   : task-
- infra                  : infra-
- change-request         : cr-
- advisory               : adv-
- bug-report             : bug-

## Repo Mapping

| Agent | Writes to | Also reads |
|---|---|---|
| project-manager | `{docs-repo}/` | — |
| business-analyst | `{docs-repo}/` | — |
| product-designer | `{docs-repo}/` | — |
| software-architect | `{docs-repo}/` | — |
| backend-engineer | `../{backend-repo}/` | `../{docs-repo}/` |
| frontend-engineer | `../{frontend-repo}/` | `../{docs-repo}/` |
| platform-engineer | `../{infra-repo}/` | `../{backend-repo}/`, `../{frontend-repo}/`, `../{docs-repo}/` |

All agents read PKM artifacts from `{docs-repo}/`. Implementation agents additionally read from their own code repos for context.

## Skills

| Skill | Source | Status | Applied to |
|---|---|---|---|
| brainstorming | TBD | deferred | ideation phases |
| tdd | TBD | deferred | test-driven implementation |
| impeccable | pbakaus/impeccable | deferred | output quality pass |

When a skill is integrated: update `Status` to `active`, add the install path to `Source`, update the relevant `agents/{role}.md` `## Skill Composition` section. Skills apply within each agent's scope — they do not expand artifact ownership.

**Tooling note:** `.claude/skills/` is the source set for Claude-oriented SDLC skills. `.codex/skills/` contains Codex-compatible mirrors — keep them aligned with Claude definitions unless explicitly diverged.

## Charters
- {charter-slug}

## PRDs
- {charter-slug}/{prd-slug}

---

For coordination artifact rules (scenarios, CRs, milestones), see `reference/coordination-decision-tree.md`.
