# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
PRD artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern 'prd'` once the CLI is available. Downstream artifacts link to the feature's PRD via the `feature:` frontmatter field.

```bash
# All artifacts of a given type
rg -l --glob '!.*' "type: api-spec" {vault-root}/
rg -l --glob '!.*' "type: data-design" {vault-root}/

# All PRD artifacts (default requirements-root type)
rg -l --glob '!.*' "type: prd" {vault-root}/

# All plan artifacts
rg -l --glob '!.*' "type: plan" {vault-root}/

# Find the PRD for a feature (by its root id, e.g. prd-user-auth)
rg -l --glob '!.*' "^id: prd-user-auth" {vault-root}/

# All downstream artifacts tied to a feature (via the `feature:` field)
rg -l --glob '!.*' "feature: prd-user-auth" {vault-root}/

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {vault-root}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: prd-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
rg -l --glob '!.*' "story: story-user-login" {vault-root}/tasks/

# Find all test specs for a user story
rg -l --glob '!.*' "refs:.*story-user-login" {vault-root}/test-specs/

# TDD traceability — tasks referencing a specific test-spec
rg -l --glob '!.*' "refs:.*ts-user-authentication" {vault-root}/tasks/

# Specs still in draft
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: draft"

# Accepted specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: accepted"

# Data designs referencing a specific api-spec
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/data-designs/
```
