# Reference: Post-Implementation Verification & Upstream Status Suggestion

When all tasks for a story or feature are implemented, the agent MUST verify the implementation against upstream specs and propose status updates. **Do not auto-commit or flip status fields to `done` or `accepted` without explicit human confirmation.**

"DoD" in this vault = Acceptance Criteria (task + story) + Success Metrics (feature) + Execution Checklist (task). There is no separate DoD field.

## Verification & Status Checklists

### 1. Verify Story ACs
- Read the task's `story:` frontmatter → open the parent user-story.
- Walk every AC in `## Acceptance Criteria`. Check against the codebase (grep/read/exec — never assume).
  - *Met:* Propose checking the `[x]` box in your final response.
  - *Unmet:* Leave `[ ]` and note the blocker in the task's `### Known Gaps`.
- Scan sibling stories under the same `feature:` whose ACs this task's work may satisfy (shared-task case). Check those ACs too.
- If **all** ACs on a story are met → propose flipping the story from `status: open|in-progress` to `status: done`.

### 2. Check TD Drift
- Read the task's `tech-design:` frontmatter → open the parent tech-design.
- Compare implementation against the parent TD's Key Decisions and Implementation Plan:
  - *Drift found (changed defaults, signatures, patterns):* Propose marking TD `status: needs-review`, bumping `version`, and adding a `needs-review-reason` explaining the deviation.
  - *No drift + TD completed (all its tasks done):* Propose marking TD `status: needs-review` with reason "implementation complete; pending acceptance review."
  - *No drift + TD already accepted:* Leave unchanged.

### 3. Check Feature Metrics
- When the last story under a feature is `done` → read the requirements root's `## Success Metrics`. Verify each against the codebase.
- All met + no TD needs review → propose marking the requirements root `status: accepted`.
- Any metric unmet OR any TD is `needs-review` → propose marking the requirements root `status: needs-review` with a reason.

> The active requirements-root type is set in `../manifest.yaml`'s `requirements_root:` field (`prd` by default; alternatives `feature-brief`, `press-release`). All three templates carry a `## Success Metrics` section, so this checklist is option-agnostic.

### 4. Record Evidence
- Task `### Approach Taken`: detail what was verified and how (grep commands, file links).
- Story AC checkboxes: the `[x]` mark IS the evidence (once human approves).
- TD `needs-review-reason`: record what drifted and why.
