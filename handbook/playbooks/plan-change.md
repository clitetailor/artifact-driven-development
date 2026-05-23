# Playbook: Plan Change

File a change request against one or more existing artifacts and propagate the impact.
Use for targeted corrections, small fixes, or scoped changes that don't require new feature planning.

## Prerequisites

- ADD vault initialized (`handbook/playbooks/setup-new-repo.md` done)
- The user has described what needs to change and why
- At least one existing artifact is identifiable as the target

If running standalone, ask the user: which artifact(s) should change, and what is the problem or gap?

---

## Step 1 — Identify the target artifact

**Agent:** From the user's description, identify the artifact(s) to modify. If ambiguous:

**Run:**
```bash
# Search by keyword across artifact folders
grep -rl "{keyword}" requirements/ features/ api-contracts/ data-models/ tasks/
```

**Agent:** Confirm the target artifact ID(s) with the user before proceeding.

---

## Step 2 — Traverse impact downstream

**Agent:** For each target artifact, identify what references it or depends on it:

**Run:**
```bash
# Find all artifacts that ref the target
grep -rl "{target-artifact-id}" . --include="*.md" \
  --exclude-dir=templates \
  --exclude-dir=_sources \
  --exclude-dir=handbook
```

**Agent:** Build a short impact list — the target plus any downstream artifacts whose content may become inconsistent after the change. Present it to the user:
- **Directly affected:** content will need updating
- **Potentially affected:** worth reviewing after the change is applied

---

## Step 3 — File the change request

**Agent:** Create `change-requests/cr-{slug}.md` from `templates/change-request.md`. Fill:
- `id`, `owner` (the agent filing the CR), `status: open`, `priority: minor | major`
- `refs`: target artifact ID first, then downstream artifact IDs, then any triggering artifact
- **Problem:** what is missing or incorrect, with specific field/section callouts
- **Proposed Change:** concrete description of what should change
- **Justification:** which requirement, scenario, or constraint requires this
- **Impact Assessment:** breaking yes/no, migration yes/no, downstream IDs

Present the CR to the user for approval before applying any changes.

---

## Step 4 — Apply the change

Once the user approves the CR:

**Agent:** Apply the proposed change to the target artifact(s). Edit only the sections described in the CR — do not refactor surrounding content.

**Agent:** For each downstream artifact marked as directly affected:
- If the change is straightforward to propagate — apply it and note it in the CR body
- If the change requires a judgment call — flag it to the user before editing

---

## Step 5 — Mark downstream artifacts for review

**Agent:** For any `accepted` artifact in the impact list that was not directly edited:
- Set `status: needs-review` in its frontmatter
- Add a short note in its body under an `## Open Items` or `## Change History` section explaining why it needs review

---

## Step 6 — Resolve the CR

**Agent:** Once all changes are applied, update `cr-{slug}.md`:
- Set `status: applied`
- Fill in the **Decision** section: what was changed and by whom

---

## Step 7 — Validate

**Run:**
```bash
handbook/scripts/validate-refs.sh
```

**Agent:** For each `BROKEN` line in the output, fix the ref or flag it to the user if the correct target is ambiguous.

---

## Done

The change request is applied and resolved. Artifacts marked `needs-review` should be reviewed by their owners before the next gate.
