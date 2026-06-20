# Handbook

> Entry point for the Artifact-Driven Development handbook.
> Narrative companion to the canonical schemas in `../reference/` and `../manifest.yaml`.

## Contents

| File | Purpose |
|---|---|
| [`customization.md`](./customization.md) | How to switch the default requirements-root and plan types via decision files |

## Playbooks

Agent-driven procedures — reference these in your AI chat to walk through a task step by step.

| File | Purpose |
|---|---|
| [`playbooks/setup.md`](./playbooks/setup.md) | Configure `manifest.yaml` for your project (project metadata, repo names, feature type pattern) |
| [`playbooks/customize-artifacts.md`](./playbooks/customize-artifacts.md) | Apply a decision file to change the default artifact type or ask-threshold policy |

## Where the Specs Live

| Concern | File |
|---|---|
| Artifact types, prefixes, agents, skills, statuses | `../manifest.yaml` |
| Folder tree | `../reference/folder-structure.md` |
| Frontmatter schema + ID naming pattern | `../reference/artifact-frontmatter.md` |
| Status lifecycle framing | `../reference/artifact-lifecycle.md` |
| Agent ownership per artifact type | `../reference/artifact-ownership.md` |
| Artifact dependency graph + phases | `../reference/artifact-dep-graph.md` |
| Grep recipes for navigation | `../reference/vault-queries.md` |
| Vocabulary | `../reference/artifact-vocabulary.md` |
| Coordination decision tree | `../reference/coordination-decision-tree.md` |
| Available decision axes (customization) | `../decisions/README.md` |
| Artifact body templates (one per type) | `../templates/` |
