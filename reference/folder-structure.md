# Vault Folder Structure

```
{docs-repo}/
├── _registry.md            # Artifact type + feature registry (source of truth)
├── research-notes/         # Raw discovery notes, interview summaries  (rn-)
├── personas/               # Synthesized user archetypes               (persona-)
├── features/               # Feature-level scope documents             (feat-)
├── requirements/           # PRDs with embedded scenarios              (req-)
├── milestones/             # Optional timeline coordination artifacts  (milestone-)
├── test-plans/             # Testing strategy per feature              (tp-)
├── test-specs/             # Test specifications (unit/integration/e2e) (ts-)
├── test-suites/            # Grouped test specs with coverage targets  (suite-)
├── tasks/                  # Decomposed implementation units           (task-)
├── architecture-decisions/ # ADRs                                      (adr-)
├── quality-requirements/   # NFRs                                      (qr-)
├── api-contracts/          # Endpoint specs, request/response shapes   (api-)
├── data-models/            # Schemas, indexes, migration notes         (dm-)
├── tech-designs/           # Technical design documents per feature    (td-)
├── user-flows/             # User journey diagrams (Mermaid embedded)  (uf-)
├── wireframes/             # ASCII wireframes per screen               (wf-)
├── component-specs/        # UI component specs                        (cs-)
├── infra/                  # IaC specs, CI/CD, monitoring, runbooks    (infra-)
├── change-requests/        # Inter-agent artifact modification requests (cr-)
├── advisories/             # Non-blocking orchestrator warnings         (adv-)
├── bug-reports/            # Defect tracking artifacts                  (bug-)
├── agents/                 # Agent design docs + repo/skill mappings
├── conventions/            # Enforced conventions (prescriptive)
├── reference/              # AI-friendly reference: vocabulary, lifecycle, ownership, SDLC phases, dep graph
├── handbook/               # Human-readable workflow guides, setup prompt, playbooks, customization guide
├── _sources/               # Source material the framework was synthesized from; off-framework vocabulary; do not auto-load
└── templates/              # Artifact doc templates
```

See `_registry.md` for the authoritative artifact type + prefix list.
