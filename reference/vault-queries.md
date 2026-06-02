# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Charters and PRDs are discovered via live scan — use `rg` directly or `orchard query --pattern 'charter/prd'` once the CLI is available.

```bash
# All artifacts for a charter
rg -l --glob '!.*' "charter: user-authentication" {vault-root}/

# All artifacts of a given type
rg -l --glob '!.*' "type: api-contract" {vault-root}/

# All accepted artifacts for a charter
rg -l --glob '!.*' "charter: user-authentication" {vault-root}/ | xargs rg -l "status: accepted"

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {vault-root}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: prd-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
rg -l --glob '!.*' "story: story-user-login" {vault-root}/tasks/

# Find all tasks assigned to a milestone
rg -l --glob '!.*' "milestone: sprint-1" {vault-root}/tasks/

# Find all test specs for a user story
rg -l --glob '!.*' "refs:.*story-user-login" {vault-root}/test-specs/

# TDD traceability — tasks referencing a specific test-spec
rg -l --glob '!.*' "refs:.*ts-user-authentication" {vault-root}/tasks/

# Test-suite containing a specific spec
rg -l --glob '!.*' "refs:.*ts-user-login" {vault-root}/test-suites/

# Specs still in draft
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: draft"

# Accepted specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: accepted"
```
