# Vault Queries

**Never `ls` a folder to find artifacts.** Use grep against frontmatter fields.
Feature briefs are discovered via live scan — use `rg` directly or `orchard query --pattern 'feature-brief'` once the CLI is available.

```bash
# All artifacts of a given type
rg -l --glob '!.*' "type: api-spec" {vault-root}/
rg -l --glob '!.*' "type: data-design" {vault-root}/
rg -l --glob '!.*' "type: ticket" {vault-root}/

# All artifacts that reference a specific artifact
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/

# All artifacts in needs-review state
rg -l --glob '!.*' "status: needs-review" {vault-root}/

# Find a specific artifact by id
rg -l --glob '!.*' "^id: fb-user-authentication-login" {vault-root}/

# Find all tasks for a specific user story
rg -l --glob '!.*' "story: story-user-login" {vault-root}/tasks/

# Find all tasks for a specific ticket
rg -l --glob '!.*' "ticket: ticket-add-rate-limiting" {vault-root}/tasks/

# Find all tickets of a given kind
rg -l --glob '!.*' "kind: defect" {vault-root}/tickets/

# Find all test specs for a user story
rg -l --glob '!.*' "refs:.*story-user-login" {vault-root}/test-specs/

# TDD traceability — tasks referencing a specific test-spec
rg -l --glob '!.*' "refs:.*ts-user-authentication" {vault-root}/tasks/

# Specs still in draft
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: draft"

# Accepted specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" {vault-root}/test-specs/ | xargs rg -l "status: accepted"

# Open tickets
rg -l --glob '!.*' "type: ticket" {vault-root}/tickets/ | xargs rg -l "status: open"

# Data designs referencing a specific api-spec
rg -l --glob '!.*' "refs:.*api-user-authentication" {vault-root}/data-designs/
```
