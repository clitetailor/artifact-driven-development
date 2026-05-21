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
```
