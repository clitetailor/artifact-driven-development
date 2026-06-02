# Vault Folder Structure

```
{docs-repo}/
├── registry.yaml           # Artifact types, prefixes, agent roster, skills, statuses (source of truth)
├── user-journey-maps/      # End-to-end user experience maps, grounded in research (ujm-)
├── project-charters/       # Capability authorizations with scope + success criteria (charter-)
├── prds/                   # Product Requirements Documents, scoped per charter area  (prd-)
├── user-stories/           # Verifiable user-value units with Given/When/Then AC      (story-)
├── stakeholder-matrices/   # Stakeholder identification and influence mapping         (sm-)
├── milestones/             # Optional timeline coordination artifacts  (milestone-)
├── test-plans/             # Testing strategy per feature              (tp-)
├── test-specs/             # Test specifications (unit/integration/e2e) (ts-)
├── test-suites/            # Grouped test specs with coverage targets  (suite-)
├── tasks/                  # Decomposed implementation units           (task-)
├── system-architectures/   # System-wide structural views               (sa-)
├── architecture-decisions/ # Architecture decisions                      (adr-)
├── quality-requirements/   # NFRs                                      (qr-)
├── api-contracts/          # Endpoint specs, request/response shapes   (api-)
├── data-models/            # Schemas, indexes, migration notes         (dm-)
├── tech-designs/           # Technical design documents per feature    (td-)
├── user-flows/             # User journey diagrams (Mermaid embedded)  (uf-)
├── wireframes/             # ASCII wireframes per screen               (wf-)
├── component-specs/        # UI component specs                        (cs-)
├── infra/                  # IaC specs, CI/CD, monitoring               (infra-)
├── change-requests/        # Inter-agent artifact modification requests (cr-)
├── advisories/             # Non-blocking project manager warnings      (adv-)
├── bug-reports/            # Defect tracking artifacts                  (bug-)
├── agents/                 # Agent design docs + repo/skill mappings
├── conventions/            # Enforced conventions (prescriptive)
├── reference/              # AI-friendly reference: vocabulary, lifecycle, ownership, SDLC phases, dep graph
├── handbook/               # Human-readable workflow guides, setup prompt, playbooks, customization guide
├── _sources/               # Source material the framework was synthesized from; off-framework vocabulary; do not auto-load
└── templates/              # Artifact doc templates
```

See `registry.yaml` for the authoritative artifact type + prefix list.
