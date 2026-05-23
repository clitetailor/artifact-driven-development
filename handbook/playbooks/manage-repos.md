# Playbook: Manage Repos

Add, remap, or remove a repo from the vault layout.

## Prerequisites

- ADD vault initialized (`handbook/playbooks/setup-new-repo.md` done)
- For orientation on layout decisions: `handbook/guide/repos.md`

If running standalone, identify which operation you need before starting:
- **Add** — a new repo that does not yet exist in the vault layout
- **Remap** — an existing repo that has been renamed or moved
- **Remove** — a repo that is no longer part of the project

---

## Add a repo

Use this when adding a new code repo (e.g., a second backend service, a mobile app, a data pipeline).

### Step 1 — Add to `AGENTS.md`

**Agent:** Open the **Sibling Repos** table in `AGENTS.md` and add a row:

| Directory | Purpose |
|---|---|
| `../{new-repo}/` | Description of what this repo contains |

### Step 2 — Add to `agents/repo-mapping.md`

**Agent:** Determine whether the new repo needs a dedicated agent role or is covered by an existing one.

- **New role needed** (e.g., a mobile engineer): add a row to the table and follow `handbook/guide/agent-skills.md` — Adding an agent role.
- **Existing role covers it** (e.g., a second backend handled by backend-engineer): add a note in the **Notes** section of `agents/repo-mapping.md` rather than a new row. Update `agents/{role}.md` PKM Access section to include the additional write target.

### Step 3 — Replace the placeholder

**Run:** Preview:
```bash
handbook/scripts/replace-placeholders.sh --docs-repo={docs-repo} --backend-repo={new-repo} --dry-run
```

**Run:** Apply:
```bash
handbook/scripts/replace-placeholders.sh --docs-repo={docs-repo} --backend-repo={new-repo}
```

Use the flag that matches the role (`--frontend-repo`, `--backend-repo`, or `--infra-repo`). For a role with no matching default flag, replace the placeholder manually in `AGENTS.md` and `agents/repo-mapping.md`.

---

## Remap a repo

Use this when a repo has been renamed or moved to a different path.

### Step 1 — Update `agents/repo-mapping.md`

**Agent:** Update the **Writes code to** column for the affected agent row.

### Step 2 — Update `AGENTS.md`

**Agent:** Update the **Sibling Repos** table row for the renamed repo.

### Step 3 — Replace the old name throughout the vault

**Run:**
```bash
grep -rl "{old-repo-name}" . --include="*.md" -l
```

**Agent:** For each file in the output, replace `{old-repo-name}` with the new name.

---

## Remove a repo

### Step 1 — Reassign or remove the agent role

**Agent:** Before removing the repo, check `agents/repo-mapping.md` for the agent that writes to it.

- If the role is repo-specific and no longer needed: follow `handbook/guide/agent-skills.md` — Removing an agent role.
- If an existing shared role covered it: update that agent's row in `agents/repo-mapping.md` to remove the target.

### Step 2 — Check for affected artifacts

**Run:**
```bash
grep -rl "{repo-name}" . --include="*.md" \
  --exclude-dir=templates \
  --exclude-dir=_sources \
  --exclude-dir=handbook
```

**Agent:** For any artifact in the output that references this repo, flag it to the user — those artifacts may reference tasks or paths that will no longer resolve.

### Step 3 — Remove from `agents/repo-mapping.md` and `AGENTS.md`

**Agent:** Remove the agent row from `agents/repo-mapping.md` and the directory row from the **Sibling Repos** table in `AGENTS.md`.

### Step 4 — Validate

**Run:**
```bash
handbook/scripts/validate-refs.sh
```

**Agent:** Fix any `BROKEN` refs surfaced by the script.
