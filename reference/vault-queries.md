# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Charters and PRDs are listed in `_registry.md` — read it first to scope queries.

```bash
# All artifacts for a charter
rg -l --glob '!.*' "charter: user-authentication" {docs-repo}/

# All artifacts of a given type
rg -l --glob '!.*' "type: api-contract" {docs-repo}/

# All accepted artifacts for a charter
rg -l --glob '!.*' "charter: user-authentication" {docs-repo}/ | xargs rg -l "status: accepted"

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {docs-repo}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {docs-repo}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: prd-user-authentication-login" {docs-repo}/

# Find all tasks for a specific user story
rg -l --glob '!.*' "story: story-user-login" {docs-repo}/tasks/

# Find all tasks assigned to a milestone
rg -l --glob '!.*' "milestone: sprint-1" {docs-repo}/tasks/

# Find all test specs for a user story
rg -l --glob '!.*' "refs:.*story-user-login" {docs-repo}/test-specs/

# TDD traceability — tasks referencing a specific test-spec
rg -l --glob '!.*' "refs:.*ts-user-authentication" {docs-repo}/tasks/

# Test-suite containing a specific spec
rg -l --glob '!.*' "refs:.*ts-user-login" {docs-repo}/test-suites/

# Specs still in draft
rg -l --glob '!.*' "type: test-spec" {docs-repo}/test-specs/ | xargs rg -l "status: draft"

# Accepted specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" {docs-repo}/test-specs/ | xargs rg -l "status: accepted"
```
