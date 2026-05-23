# Playbook: Cleanup Artifacts

Remove stale artifact files and unused artifact type folders. Safe to run at any time.

## Prerequisites

None. This playbook is standalone-safe.

---

## Part A — Remove stale artifact files

Stale artifacts are files that were started but never progressed: long-lived drafts with no inbound refs and no active task pointing to them.

### Step A1 — Find draft artifacts

**Run:**
```bash
grep -rl "status: draft" . --include="*.md" \
  --exclude-dir=templates \
  --exclude-dir=_sources \
  --exclude-dir=handbook \
  --exclude-dir=reference
```

### Step A2 — Find orphaned artifacts (no inbound refs)

**Run:**
```bash
handbook/scripts/find-orphaned-artifacts.sh
```

**Agent:** Cross-reference the output with the draft artifacts found in Step A1. The candidate removal list is the intersection: draft artifacts that are also orphaned (no inbound refs, not referenced by any open task or milestone).

### Step A3 — Confirm with user

**Agent:** Present the candidate list grouped by artifact type. For each candidate, show:
- File path
- `id` and `status`
- Date last modified (use file mtime or frontmatter date if present)
- Why it is a candidate (no inbound refs, long-lived draft)

Ask the user to confirm which files to remove. Do not delete anything without explicit confirmation.

### Step A4 — Remove confirmed files

**Agent:** For each confirmed file, delete it.

**Run:**
```bash
rm {confirmed-file-path}
```

### Step A5 — Update `_registry.md`

**Agent:** If any removed artifacts belonged to a feature that now has no remaining artifacts, remove that feature slug from `_registry.md`. Update `updated:` date.

---

## Part B — Remove unused artifact type folders

Use this when the project has decided an artifact type is permanently out of scope (e.g., no wireframes for an API-only project).

### Step B1 — Identify candidate folders

**Agent:** Ask the user which artifact type folders to remove, or ask them to confirm a list you propose based on what you observe (empty folders, or folders the user flagged during setup).

### Step B2 — Check for remaining files

**Run:**
```bash
ls -la {folder-path}/
```

**Agent:** If the folder contains any files (including accepted artifacts), warn the user before proceeding. Only remove folders the user explicitly confirms are safe to delete.

### Step B3 — Remove confirmed folders

**Run:**
```bash
rm -rf {confirmed-folder-path}
```

### Step B4 — Update `_registry.md`

**Agent:** Remove the artifact type entry from the **Artifact Types** and **ID Prefixes** sections of `_registry.md` for each removed folder. Update `updated:` date.

### Step B5 — Update the artifact dependency graph

**Agent:** Open `handbook/artifact-dependency-graph.md`. Remove any references to the deleted artifact type from the per-group notes and inter-group descriptions.

**Agent:** Open `reference/artifact-dep-graph.md`. Remove the deleted type from the dependency table and any inter-group matrix rows that reference it.

---

## Step C — Validate

**Run:**
```bash
handbook/scripts/validate-refs.sh
```

**Agent:** For each `BROKEN` line in the output, either fix the ref (if the artifact was renamed) or remove the ref line (if the artifact was intentionally deleted). The script exits with code 1 if any broken refs remain.

---

## Done

Confirm with the user that the vault is in the expected state, then commit:

**Run:**
```bash
jj commit -m "Clean up stale artifacts"
```
