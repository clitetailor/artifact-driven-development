# Artifact Vocabulary

| Term | Definition |
|---|---|
| **artifact** | A versioned, typed document in the vault with YAML frontmatter |
| **feature** | A top-level product capability (e.g. `authentication`, `function`) |
| **requirement** | Scoped PRD for one feature with embedded scenarios, owned by business-analyst |
| **scenario** | User narrative embedded in requirement doc, includes AC and orchestration metadata (priority, effort, dependencies, timeline) |
| **task** | Agent-sized implementation unit, derived from API contract or component spec, links to specific scenario |
| **milestone** | Optional coordination artifact for cross-cutting timeline tracking (sprints/phases) |
| **hard-dep** | Blocking upstream dependency — artifact cannot be accepted without it |
| **soft-dep** | Recommended dependency — generates warning if missing, does not block |
| **CR** | Change request — filed when a downstream agent needs an upstream artifact changed |
| **advisory** | Non-blocking orchestrator warning, stored in `advisories/` |
| **needs-review** | Status set on accepted artifacts when their upstream hard-dep changes |
