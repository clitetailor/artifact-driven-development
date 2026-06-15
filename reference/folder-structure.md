# Vault Folder Structure

`{vault-root}` is the vault repo itself — the current repo/folder you're working in (default CWD), where `manifest.yaml` lives.

```
{vault-root}/
├── manifest.yaml           # Artifact types, prefixes, agent roster, skills, statuses (source of truth)
├── PROJECT.md              # Human-readable project overview (active tickets, PRDs, status)
├── prds/                   # Product Requirements Documents (prd-)
├── user-stories/           # Verifiable user-value units with Given/When/Then AC (story-)
├── user-flows/             # User flow diagrams with journey overview (uf-)
├── design-specs/           # Wireframes + component behavior specs (ds-)
├── system-architectures/   # System-wide structural views with ADRs (sa-)
├── api-specs/              # External API contracts with entity mapping (api-)
├── data-designs/           # Internal data shapes + detailed data flows (dd-)
├── tech-designs/           # Technical design documents per feature (td-)
├── tasks/                  # Decomposed implementation units (task-)
├── test-specs/             # Test specifications with embedded test plan (ts-)
├── tickets/                # Coordination artifacts (ticket-)
├── agents/                 # Agent design docs + repo/skill mappings
├── conventions/            # Enforced conventions (prescriptive)
├── reference/              # AI-friendly reference: vocabulary, lifecycle, ownership, SDLC phases, dep graph
├── handbook/               # Human-readable workflow guides, setup prompt, playbooks, customization guide
├── _sources/               # Source material the framework was synthesized from; off-framework vocabulary; do not auto-load
└── templates/              # Artifact doc templates
```

See `manifest.yaml` for the authoritative artifact type + prefix list.
