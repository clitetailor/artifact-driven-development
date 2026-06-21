# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Requirements-root artifacts are discovered via live scan — use `rg` directly or `orchard query --pattern '{feature-type}'` once the CLI is available. Downstream artifacts link to the feature's requirements root via the `feature:` frontmatter field.

**Active requirements-root type:** The queries below use `prd` as the example type (the framework's shipped default). Substitute the active type from `manifest.yaml`'s `feature_type:` field if different (e.g. `feature-brief` → `fb-`, `press-release` → `pr-`).

**Date-prefixed IDs:** Types listed in `manifest.yaml`'s `dated_types:` carry a `YYYY-MM-DD-` creation-date prefix. Queries that anchor on IDs use the pattern `id: (\d{4}-\d{2}-\d{2}-)?prefix-` to optionally match the date prefix — this works whether the type is dated or not, so queries don't change when dating alternatives are switched. `type:` and `status:` queries are unaffected — they search frontmatter field values, not IDs.

```bash
# All artifacts of a given type
rg -l --glob '!.*' "type: api-spec" {vault-root}/
rg -l --glob '!.*' "type: data-design" {vault-root}/

# All requirements-root artifacts (example uses prd — substitute active type from manifest)
rg -l --glob '!.*' "type: prd" {vault-root}/

# All plan artifacts
rg -l --glob '!.*' "type: plan" {vault-root}/

# Find the requirements root for a feature (by its root id, e.g. prd-user-auth)
# Uses optional date-prefix regex — works whether prd is dated or not
rg -l --glob '!.*' "id: (\d{4}-\d{2}-\d{2}-)?prd-user-auth" {vault-root}/

# All downstream artifacts tied to a feature (via the `feature:` field)
# Uses optional date-prefix regex on the feature ID
rg -l --glob '!.*' "feature: (\d{4}-\d{2}-\d{2}-)?prd-user-auth" {vault-root}/

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {vault-root}/

# Find a specific artifact by id
# Uses optional date-prefix regex — works whether the type is dated or not
rg -l --glob '!.*' "id: (\d{4}-\d{2}-\d{2}-)?prd-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
# Uses optional date-prefix regex on the story ID
rg -l --glob '!.*' "story: (\d{4}-\d{2}-\d{2}-)?story-user-login" {vault-root}/tasks/

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
