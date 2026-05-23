# Playbook: Setup New Repo

Set up an ADD vault for the first time in a target project.

## Prerequisites

- ADD vault copied into the target project location
- Answers available from `handbook/setup.md` Q&A:
  - Repo names (docs, frontend, backend, infra)
  - Repo shape (monorepo / multi-repo)
  - Product context (name, users, workflows)

If running standalone, collect those answers before starting.

---

## Step 1 — Replace placeholders

**Agent:** From the Q&A answers, build the replacement set. Only include repos the user confirmed — skip any answered `none`.

**Run:** Preview which files will change (omit flags for repos answered `none`):
```bash
handbook/scripts/replace-placeholders.sh \
  --docs-repo={docs-repo} \
  [--frontend-repo={name}] \
  [--backend-repo={name}] \
  [--infra-repo={name}] \
  --dry-run
```

**Run:** Apply once confirmed:
```bash
handbook/scripts/replace-placeholders.sh \
  --docs-repo={docs-repo} \
  [--frontend-repo={name}] \
  [--backend-repo={name}] \
  [--infra-repo={name}]
```

**Agent:** If the user named multiple repos of the same role (e.g., two backends), replace the default placeholder for the first one with the script, then manually add entries for the additional repos in `AGENTS.md` and `agents/repo-mapping.md`. See `handbook/guide/repos.md` for the per-repo steps.

**Agent:** After running the script, check for any remaining `{placeholder}` patterns and replace or remove them.

**Note:** Repos answered `none` are not configured now. Add them on demand later using `handbook/guide/repos.md`.

---

## Step 2 — Initialize `_registry.md`

**Agent:** Open `_registry.md` and apply:
- Set `updated:` to today's date
- Replace `{feature-slug}` placeholder entries under **Features** and **Modules** with real slugs if the user named any, or remove the placeholder lines if none yet

---

## Step 3 — Review convention docs

**Agent:** Read each file in `conventions/`. For each:
- If it matches the target stack — keep as-is
- If it partially conflicts — rewrite to match the target stack
- If it is entirely irrelevant (e.g., a frontend conventions doc for an API-only project) — ask the user whether to remove it or keep it as a placeholder

Do not silently delete. Confirm removals with the user.

---

## Step 4 — Confirm artifact folder scope

**Agent:** Ask the user whether any artifact types are out of scope for this project. Examples:
- No `wireframes/` or `component-specs/` for a backend-only or CLI project
- No `personas/` for an internal tooling project with a single known user group
- No `infra/` if the project uses a fully managed platform with no IaC

For each type the user excludes: note the exclusion as a comment in `_registry.md` rather than deleting the folder, unless the user explicitly wants the folder removed.

---

## Step 5 — Check for remaining unresolved placeholders

**Run:**
```bash
grep -rn "{[a-zA-Z_-]*}" . --include="*.md" \
  --exclude-dir=templates \
  --exclude-dir=_sources
```

**Agent:** For each match:
- If intentionally left for the future — leave it
- If it should have been replaced — replace it now

---

## Step 6 — Validate structure

**Agent:** Confirm:
- `AGENTS.md` references correct sibling repo paths
- `_registry.md` has no placeholder entries remaining (unless intentional)
- `handbook/setup.md` dispatch table references exist (`handbook/playbooks/`, `handbook/guide/`)
- No broken internal links introduced by placeholder replacement

---

## Step 7 — Commit

**Run:**
```bash
jj commit -m "Initialize ADD vault for {project-name}"
```
