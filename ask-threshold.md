# Ask Threshold — Decision Record

> Records the active rule for when an agent should ask the user vs. infer and proceed. Update the **Active** row to switch approaches; keep the alternatives so future switches are one-line edits.

## Context

`AGENTS.md` previously had a single "Ask before acting on ambiguity" bullet buried under `## Token Efficiency Rules`, where it was framed as a token-cost heuristic and conflicted with the adjacent "Think before acting" bullet. This file separates the *threshold policy* from the operating instructions so the threshold can evolve without re-editing `AGENTS.md` prose.

## Active

**Always ask first.** When user intent is even slightly unclear, ask a clarifying question before reading artifacts or producing output. Maximizes alignment at the cost of more frequent interruptions.

## Alternatives Considered

| Alternative | Behavior | Reason currently not active |
|---|---|---|
| Approach-changing only | Ask only when the answer would change the approach/scope; for trivial details, infer and state the assumption in the output. | Lower friction, but risks the agent silently inferring wrong intent on details that later turn out to matter. Revisit once the agent's inference accuracy is trusted. |
| Read-then-confirm | Read the directly-relevant artifact, then state understood intent in one line and ask for confirmation before producing output. | Middle ground, but still front-loads reading on potentially-wrong assumptions and adds a round-trip anyway. |

## References

- `AGENTS.md` — `## Communication` section enforces the active threshold.
