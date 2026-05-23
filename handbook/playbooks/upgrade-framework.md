# Playbook: Upgrade Framework

Pull in upstream changes from the artifact-driven-development scaffold into this user vault, without clobbering user-owned content.

## Ownership Model

| Class | Paths | Upgrade behavior |
|---|---|---|
| Framework-owned | `handbook/`, `reference/`, `agents/`, `_sources/`, `README.md` | Overwritten (rsync `--delete` per dir; whole-file copy for files) |
| 3-way merged | `AGENTS.md` | Merged against cached base at `.framework-cache/AGENTS.md` |
| User-owned (never touched) | `_registry.md`, `templates/`, `conventions/`, all vault folders (`personas/`, `features/`, `requirements/`, …) | Untouched |

`FRAMEWORK_VERSION` records the upstream version this vault was last synced to. Rewritten on successful upgrade.

---

## Step 1 — Pick the source

**Agent:** Ask the user:
1. **Source type:** git URL, or local path to a checkout?
2. **If git URL:** which tag? Upgrades MUST be pinned to a tag for reproducibility — never `main` or a branch.

**Run** (if git URL) — list available tags so the user can pick:
```bash
git ls-remote --tags <source-url> | awk '{print $2}' | sed 's|refs/tags/||' | sort -V
```

**Agent:** Capture the chosen `--source` value and (if applicable) `--ref` tag.

---

## Step 2 — Dry run

**Run:**
```bash
handbook/scripts/upgrade-framework.sh \
  --source=<git-url-or-path> \
  [--ref=<tag>] \
  --dry-run
```

**Agent:** Show the user:
- Local vs source `FRAMEWORK_VERSION`
- List of files that would be added / changed / deleted under framework-owned paths
- Whether the AGENTS.md merge is projected to be clean or conflicted

Pause for confirmation.

---

## Step 3 — Apply

**Run:**
```bash
handbook/scripts/upgrade-framework.sh \
  --source=<git-url-or-path> \
  [--ref=<tag>]
```

The script will:
1. Resolve the source (clone the tag into a temp dir, or read the local path).
2. Verify it looks like an ADD vault (`FRAMEWORK_VERSION` + `AGENTS.md` present).
3. `rsync -a --delete` framework-owned dirs.
4. Overwrite framework-owned files.
5. 3-way merge `AGENTS.md` using `.framework-cache/AGENTS.md` as base.
6. Update `.framework-cache/AGENTS.md` to the new upstream **only if the merge was clean**.
7. Rewrite `FRAMEWORK_VERSION`.

---

## Step 4 — Resolve AGENTS.md conflicts (if any)

**Agent:** If the script reports `MERGED WITH CONFLICTS`:
- Open `AGENTS.md`, find `<<<<<<<` / `=======` / `>>>>>>>` markers
- For each conflict, reconcile the user's customization with the upstream change
- Remove all conflict markers
- Re-run the upgrade script with the same `--source`/`--ref` to refresh the base cache (this is a no-op for framework dirs but updates `.framework-cache/AGENTS.md`)

---

## Step 5 — Drift check against user `_registry.md`

The script never touches `_registry.md`, but upstream may have renamed, added, or removed artifact types. Check for drift.

**Agent:** Diff the user `_registry.md` against the upstream registry and dep graph:
- Compare local `_registry.md` against source `_registry.md` (use the cloned temp dir, or have the user point you at the source path)
- Compare local conventions / mental model against source `reference/artifact-dep-graph.md`
- Surface to the user:
  - Artifact types the user has files for but upstream removed
  - Artifact types upstream added that the user might want to adopt
  - ID prefix renames that would require renaming user artifact files

Do **not** auto-edit `_registry.md` — report findings, let the user decide.

---

## Step 6 — Convention review

**Agent:** Read the source `conventions/` directory (do not copy from it). If upstream introduced new convention docs the user lacks, mention them and ask if the user wants to copy any in. Existing local conventions are never overwritten.

---

## Step 7 — Verify and commit

**Run:**
```bash
git diff --stat   # or: jj diff --stat
```

**Agent:** Confirm:
- No conflict markers remain (`grep -rn '<<<<<<< ' .`)
- `FRAMEWORK_VERSION` matches the target
- Framework-owned dirs look reasonable

**Run:**
```bash
jj commit -m "Upgrade ADD framework to <new-version>

- Sync handbook/, reference/, agents/, _sources/, README.md
- AGENTS.md: <merged cleanly | resolved conflicts>
- Drift notes: <summary or 'none'>"
```

---

## Edge cases

- **User edited a framework-owned file** (e.g., `reference/sdlc-phases.md`): those edits are lost on upgrade. The script does not detect this. Tell the user to fork such customizations into a user-owned location (e.g., `conventions/`) before upgrading.
- **Upstream renames a handbook path**: handled — `rsync --delete` removes stale files.
- **First upgrade after older copies**: if `.framework-cache/AGENTS.md` is missing, the script falls back to overwriting AGENTS.md and warns. Seed the cache by copying your current AGENTS.md into `.framework-cache/` before upgrading if you want the first merge to be 3-way.
- **`--ref` is a branch, not a tag**: the script will accept it (`git clone --branch` works for both) but you lose reproducibility. Prefer tags.
