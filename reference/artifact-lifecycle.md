# Status Labels

Status is an **informational label** — not an enforced state machine. Pick the value that best describes where the artifact is right now.

Valid labels, their one-line meanings, and any `applies-to` constraints live in `../manifest.yaml` under `statuses`.

No required transitions. Agents and humans pick the label that fits; the project manager (if any) reads it as context, not as a gate.
