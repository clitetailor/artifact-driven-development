# Guide: SDLC Workflows

How to understand, use, and customize the SDLC tracks and gates.

For the full phase spec: `reference/sdlc-phases.md`.
For the narrative workflow with diagrams: `handbook/sdlc-workflows.md`.

---

## The three tracks

Track selection is driven by impact depth — how many artifact layers a change touches — not by manual classification. The project-manager traverses the dependency graph forward and backward from the entry-point artifact and counts affected layers.

| Track | Impact depth | Entry point | Gates |
|---|---|---|---|
| **Large** | 5+ artifact layers | feature or requirement | 5 gates, full phase sequence |
| **Medium** | 3–4 artifact layers | requirement or design artifact | 2–3 gates, selective phases |
| **Small / CR** | 1–2 artifact layers | specific artifact | 1 gate, CR flow |

The track is a recommendation. The user can override it at any time — for example, choosing to run Medium artifacts for a change that the dep graph scored as Large.

---

## Customizing track thresholds

The layer thresholds (1–2 / 3–4 / 5+) live in `reference/sdlc-phases.md` under **Track Selection**. Edit that table to tighten or loosen what qualifies as Large vs. Medium for your project.

Common reasons to adjust:
- A smaller team that finds 5-gate planning too heavy for most work → lower the Large threshold to 7+ layers, making more work fall into Medium
- A high-compliance project where audit trails matter → lower the Small threshold so more changes go through at least a Medium review

After editing the threshold table, note the change as an advisory so future team members know the project diverged from the default.

---

## Adding or removing a phase

Phases are defined in two places that must stay in sync:

1. `reference/sdlc-phases.md` — **Phase Summary** table (machine-readable)
2. `handbook/sdlc-workflows.md` — narrative flow with Mermaid diagrams (human-readable)

**To add a phase:**
1. Insert a row in the **Phase Summary** table in `reference/sdlc-phases.md` with: phase name, responsible agents, artifacts produced, gate condition
2. Add the phase node and gate to the Mermaid diagram in `handbook/sdlc-workflows.md`
3. Update the **Agent Activation Order** section in `handbook/sdlc-workflows.md`
4. Update `reference/sdlc-phases.md` **PKM Writes Per Phase** table to include any new artifact types the phase produces

**To remove a phase:**
- Follow the same files in reverse
- Check that no artifact type is *only* produced in the removed phase; if so, decide whether to move it to an adjacent phase or remove the artifact type entirely

---

## Modifying a gate condition

Gate conditions live in the **Gate condition** column of the Phase Summary table in `reference/sdlc-phases.md`. Edit the text there.

Gate conditions are guidance for the project-manager, not enforced checks. Changing them adjusts what the project-manager surfaces to the user at each review point — it does not add or remove hard blocks.

---

## Adding parallel execution windows

By default, phases run sequentially. Parallel execution is opt-in per phase. The rules live in `reference/sdlc-phases.md` under **Parallel Execution Windows**.

To allow a new parallel window:
1. Add a row to the **Parallel Execution Windows** table with: phase, default sequencing, and the condition under which agents can run in parallel
2. Ensure the two agents in the window have no blocking dependency at that point — check `reference/artifact-dep-graph.md` intra-group dependencies before enabling
3. Update the **Agent Activation Order** tree in `handbook/sdlc-workflows.md` to show the `‖` (parallel) symbol

---

## Deferred items and advisories

When the user proceeds past a gate warning, the project-manager files an `advisory`. Advisories accumulate until the final gate or until the user asks to clear them.

To change how deferred items are handled — for example, auto-resolving certain advisory types — edit the **Deferred Items Handling** section in `handbook/sdlc-workflows.md`. That section defines the four user choices (resolve now / keep deferred / escalate / dismiss) and when each applies.

---

## CR routing rules

Minor vs. major CR classification and routing behavior is defined in `handbook/sdlc-workflows.md` under **CR Routing Rules**. Edit that section to change auto-apply windows, escalation triggers, or block behavior.

The CR template shape is in `templates/change-request.md` — separate from the routing rules.
