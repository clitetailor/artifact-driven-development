# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Features and modules are listed in `_registry.md` — read it first to scope queries.

```bash
# All artifacts for a feature
rg -l --glob '!.*' "feature: user-authentication" {docs-repo}/

# All artifacts of a given type
rg -l --glob '!.*' "type: api-contract" {docs-repo}/

# All accepted artifacts for a feature
rg -l --glob '!.*' "feature: user-authentication" {docs-repo}/ | xargs rg -l "status: accepted"

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {docs-repo}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {docs-repo}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: req-user-authentication" {docs-repo}/

# Find all tasks for a specific scenario
rg -l --glob '!.*' "scenario: req-user-authentication#scenario-1" {docs-repo}/tasks/

# Find all tasks assigned to a milestone
rg -l --glob '!.*' "milestone: sprint-1" {docs-repo}/tasks/

# Find all test specs for a scenario
rg -l --glob '!.*' "scenario: req-user-authentication#scenario-1" {docs-repo}/test-specs/

# TDD traceability — tasks referencing a specific test-spec
rg -l --glob '!.*' "refs:.*ts-user-authentication" {docs-repo}/tasks/

# Test-suite containing a specific spec
rg -l --glob '!.*' "refs:.*ts-user-login" {docs-repo}/test-suites/

# Specs still in draft
rg -l --glob '!.*' "type: test-spec" {docs-repo}/test-specs/ | xargs rg -l "status: draft"

# Accepted specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" {docs-repo}/test-specs/ | xargs rg -l "status: accepted"
```
