# Artifact Vocabulary

| Term | Definition |
|---|---|
| **artifact** | A versioned, typed document in the vault with YAML frontmatter |
| **charter** | A top-level product capability authorization (e.g. `authentication`, `billing`). Defines scope, success criteria, and sponsor sign-off. Top-level organizing namespace. |
| **prd** | Product Requirements Document — scoped to one charter (or sub-area), captures *what* the system must do with ID-tagged requirements, owned by business-analyst |
| **user-story** | One verifiable unit of user value extracted from a PRD, in the format "As a [role], I want [goal], so that [benefit]", with Given/When/Then acceptance criteria |
| **user-journey-map** | Visual + narrative of a user's end-to-end experience: touchpoints, emotions, pain points, and opportunities. Grounds all downstream design and requirements in real user research. Replaces the former research-note + persona pair. |
| **task** | Agent-sized implementation unit, derived from API contract or component spec, links to a specific user-story |
| **milestone** | Optional coordination artifact for cross-cutting timeline tracking (sprints/phases) |
| **refs** | Frontmatter field listing all related artifacts — upstream, downstream, sideways. The only link field. |
| **CR** | Change request — filed when an agent or user needs an existing artifact changed |
| **advisory** | Noted-for-future tracker — a concern, deferred improvement, or known limitation worth remembering |
| **needs-review** | Status applied to an artifact when an upstream it references has changed; a prompt (not a block) to re-confirm consistency |
