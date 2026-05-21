# Artifact Vocabulary

| Term | Definition |
|---|---|
| **artifact** | A versioned, typed document in the vault with YAML frontmatter |
| **feature** | A top-level product capability (e.g. `authentication`, `function`) |
| **requirement** | Scoped PRD for one feature with embedded scenarios, owned by business-analyst |
| **scenario** | User narrative embedded in requirement doc, includes AC and optional orchestration hints (priority, effort, dependencies, timeline) |
| **task** | Agent-sized implementation unit, derived from API contract or component spec, links to a specific scenario |
| **milestone** | Optional coordination artifact for cross-cutting timeline tracking (sprints/phases) |
| **refs** | Frontmatter field listing all related artifacts — upstream, downstream, sideways. The only link field. |
| **CR** | Change request — filed when an agent or user needs an existing artifact changed |
| **advisory** | Noted-for-future tracker — a concern, deferred improvement, or known limitation worth remembering |
| **needs-review** | Status applied to an artifact when an upstream it references has changed; a prompt (not a block) to re-confirm consistency |
