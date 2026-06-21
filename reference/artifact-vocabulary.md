# Artifact Vocabulary

| Term | Definition |
|---|---|
| **artifact** | A versioned, typed document in the vault with YAML frontmatter |
| **prd** | Product Requirements Document — a requirements-root artifact type. Captures *what* the system must do for a feature, with background, audience, objectives, NFRs, timeline. Owned by business-analyst. |
| **feature-brief** | Feature Brief — a lighter requirements-root artifact type. Captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst. |
| **press-release** | Press Release — a requirements-root artifact type using "working backwards" framing written as if the product has launched; surfaces customer-outcome gaps before implementation. Owned by business-analyst. |
| **user-story** | One verifiable unit of user value extracted from the requirements root, in the format "As a [role], I want [goal], so that [benefit]", with Given/When/Then acceptance criteria |
| **user-flow** | User flow diagram with journey overview (absorbs user-journey-map). Maps entry points, happy path, error paths, and exit points. Owned by product-designer. |
| **design-spec** | Combined wireframe + component behavior specification. Covers visual layouts, component states, props, events, design tokens, and accessibility. Owned by product-designer. |
| **system-architecture** | System-wide structural view with embedded Architecture Decision Records. High-level data flow overview only; detailed flows in data-design. Owned by software-architect. |
| **adr** | Architecture Decision Record — a single significant decision with context, decision, consequences, and alternatives considered. Owned by software-architect. |
| **api-spec** | External API contract — endpoints, request/response DTOs, entity mapping. Internal data shapes belong in data-design. Owned by software-architect. |
| **data-design** | Internal data shapes + detailed data flows. Entity definitions, relationships, state machines, pipeline stages, transformations, migrations. Owned by software-architect. |
| **tech-design** | Feature-scoped technical design. Architectural Context (refs only) + implementation decisions constrained by system-architecture ADRs. Bridges system-architecture and task. Owned by software-architect. |
| **task** | Agent-sized implementation unit, derived from api-spec or design-spec. Links to a specific user-story and the feature's requirements root. Execution steps tracked via internal checklist. |
| **plan** | The planning artifact — a deliverable hierarchy (requirements-root → stories → tasks) with effort estimates and rolled-up sums. The hierarchy's child ordering IS the execution order. Optional sections (Effort Rollup, Sequencing Rationale, Task Lanes, Unparented Tasks) are uncommented based on team size and task complexity. Owned by project-manager. |
| **test-spec** | Test specification with embedded test plan. Covers scope, strategy, environment, test cases, edge cases, error cases. Absorbs test-plan. Owned by qa-engineer. |
| **note** | Ad-hoc scratchpad for context, meeting notes, or brainstorms. Any agent may create one at any time, with no phase or prerequisite restrictions. |
| **refs** | Frontmatter field listing all related artifact IDs — upstream, downstream, sideways. Plain IDs only; used for grep-based queries. Human-navigable markdown links live in the artifact body under `## References`. |
| **needs-review** | Status applied to an artifact when an upstream it references has changed; a prompt (not a block) to re-confirm consistency |

---

*The three requirements-root types (`prd`, `feature-brief`, `press-release`) are peers. The active type for this vault is set in `../manifest.yaml`'s `feature_type:` field — see `../customizations/requirements-root.md` to switch it.*
