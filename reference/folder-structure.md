# Vault Folder Structure

`{vault-root}` is the vault repo itself — the current repo/folder you're working in (default CWD), where `manifest.yaml` lives.

```
{vault-root}/
├── AGENTS.md              # Core operating instructions for agents working in the vault
├── README.md              # Entry point for humans and agents
├── manifest.yaml          # Artifact types, prefixes, agent roster, skills, statuses (source of truth)
├── PROJECT.md             # Human-readable project overview (active tasks, PRDs, status)
├── feature-briefs/         # Feature Briefs (fb-) — requirements-root alternative
├── prds/                   # Product Requirements Documents (prd-) — default requirements-root
├── press-releases/         # Press Releases (pr-) — requirements-root alternative
├── user-stories/           # Verifiable user-value units with Given/When/Then AC (story-)
├── user-flows/             # User flow diagrams with journey overview (uf-)
├── design-specs/           # Wireframes + component behavior specs (ds-)
│   └── wireframes/         #   Supporting HTML wireframe files linked from design-spec markdown
├── adrs/                   # Architecture Decision Records (adr-)
├── system-architectures/   # System-wide structural views with ADRs (sa-)
├── api-specs/              # External API contracts with entity mapping (api-)
├── data-designs/           # Internal data shapes + detailed data flows (dd-)
├── tech-designs/           # Technical design documents per feature (td-)
├── tasks/                  # Decomposed implementation units (task-)
├── plans/                  # Plans (plan-) — deliverable hierarchy with optional sequencing sections
├── test-specs/             # Test specifications with embedded test plan (ts-)
├── notes/                  # Ad-hoc scratchpad notes (note-) — any agent, any time
├── agents/                 # Agent design docs + repo/skill mappings
├── conventions/            # Enforced conventions (prescriptive)
├── reference/              # AI-friendly reference: vocabulary, lifecycle, ownership, SDLC phases, dep graph
├── handbook/               # Human-readable workflow guides, setup prompt, customization guide
└── templates/              # Artifact doc templates
```

See `manifest.yaml` for the authoritative artifact type + prefix list.
