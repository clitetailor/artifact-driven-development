# Customize Artifact Decisions

> Reference this file in your AI chat to switch a customization axis (requirements-root
> type, ask-threshold policy, artifact-id-dating, or any other available axis). The agent
> will walk you through selecting and applying a customization file.

---

## For The Agent

The user has referenced this file. Follow the steps below in order.

**Important:**
- Ask one question at a time using your question/prompt tool
- Wait for the user's answer before proceeding to the next question
- The confirmation gates (Steps 1, 4) are Yes/Cancel choices; render them as a picker if your tool supports it
- For conceptual background (mechanism classes, what each class touches, upgrade flow), read `../customization.md` — do not duplicate that content here
- For the format conventions that govern customization files, read `../customizations/FORMAT.md`
- For the catalog of available axes and their alternatives, read `../customizations/README.md`

Skip any question the user has already answered in their opening message.

---

## Step 1 — Identify the Decision

Agent: Read `../customizations/README.md` and present the available customization axes
with their alternatives. Ask: Which axis do you want to switch, and which alternative?

For each axis, list its alternatives from the axis file's Alternatives table. The current
applied state for each axis is read from `manifest.yaml` (e.g. `feature_type:` for
requirements-root, `dated_types:` for artifact-id-dating) or `AGENTS.md` (the
`## Communication` first bullet lead-in for ask-threshold).

If the user names a target directly (e.g. "switch to press-release", "use snapshot-style
dating"), skip to Step 2 with that choice.

---

## Step 2 — Confirm the Decision

Agent: I will apply the `{choice}` alternative from `customizations/{axis}.md`. This is a
`{mechanism class}` axis — it will touch `{files per the mechanism class}`. Already-created
artifacts are not touched — they are migrated on demand. Continue? (Yes / Cancel)

If user selects **Cancel**: Exit. No changes made.

If user selects **Yes**: Proceed to Step 3.

---

## Step 3 — Apply the customization file

Open the customization file (`customizations/{axis}.md`) and follow its **Apply** section.
The flow depends on the axis's mechanism class (read the "What changes" section to
determine it):

**Template-touching class** *(no current axes — kept for future axes that need prose swaps):*
1. **Read the current state** — read the relevant `manifest.yaml` field to identify
   the current default. If the chosen alternative is already the current state, skip to
   Step 4.
2. **L1 (templates):** Run the customization file's find commands to discover target
   files. Apply the placeholder map to each file returned, replacing the current default's
   placeholders with the chosen alternative's. Use your native file-edit tools.
3. **L2 (reference docs & handbook):** Apply the chosen alternative's per-alternative
   section. Match by prose meaning, not exact line numbers — surrounding text may have
   drifted.
4. **`manifest.yaml`:** Edit the relevant field directly.
5. **Run the customization file's §Verify block.**

**AGENTS-only class:**
1. **Read the current state** — read `AGENTS.md`'s `## Communication` first bullet
   lead-in. If it matches the chosen alternative, skip to Step 4.
2. Replace the two bullets (`## Communication` first bullet + `## Output Style` last
   bullet) with the chosen alternative's full text. Match by the bold lead-in to locate
   each bullet.
3. **Run the customization file's §Verify block.**

**Manifest-only class:**
1. **Read the current state** — read the relevant `manifest.yaml` field (e.g.
   `feature_type:` for requirements-root, `dated_types:` for artifact-id-dating). If it
   matches the chosen alternative's value, skip to Step 4.
2. Replace the manifest field with the chosen alternative's value (a single edit).
   Templates and reference docs are already parameterized/option-agnostic — no other edits
   needed.
3. **Run the customization file's §Verify block.**

For any class, if a §Verify check fails, re-apply the missed edit to that file.

---

## Step 4 — Verify and Report

Agent: I have applied the decision. Here is a summary of what changed:

[List the files modified, grouped by the mechanism class's layers: templates, reference
docs, manifest.yaml, AGENTS.md — whichever apply]

To switch to a different alternative later, apply that alternative's section from the same
customization file — alternatives are peers, not inverses, so there is no "revert" step.

Is there anything else you want to customize? (Yes / Cancel)

If user selects **Yes**: Return to Step 1.

If user selects **Cancel**: Done.

---

## Notes

- Customization axes are orthogonal when they touch disjoint files. All current axes are
  pairwise orthogonal and can be applied in any order. Confirm orthogonality for a new
  axis by comparing its mechanism class's file set against existing axes' file sets.
- For the full list of available customization files, see `../customizations/README.md`.
- For the mechanism classes and what each touches, see `../customization.md` → "Mechanism
  Classes" and "What a Decision Touches".
- For upgrade-flow implications (re-applying decisions after pulling upstream), see
  `../customization.md` → "Upgrade Flow".
