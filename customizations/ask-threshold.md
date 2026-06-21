# Customization: ask-threshold policy

> Switches the active ask-threshold policy enforced in `AGENTS.md`.
> Pick one alternative below; the agent applies that alternative's full bullet text.
> Switching to a different alternative later = apply a different alternative's section.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

Two bullets in `AGENTS.md` are rewritten — one in `## Communication` (the ask-threshold
rule) and one in `## Output Style` (the state-assumptions rule). No templates, reference
docs, or `manifest.yaml` are touched.

The agent reads the chosen alternative's section below and writes the full bullet text,
replacing the entire current bullet. Match by the bullet's bold lead-in to locate it.

---

## Alternatives

| Alternative | Role | Bullet 1 lead-in | Bullet 2 distinguishing phrase |
|---|---|---|---|
| `always-ask-first` | Default | **Ask before acting on ambiguity.** | "If you inferred instead of asking…" |
| `approach-changing-only` | Alternative | **Ask only on approach-changing ambiguity.** | "When you infer a trivial detail instead of asking…" |
| `read-then-confirm` | Alternative | **Read then confirm.** | "If you inferred intent during the read-then-confirm step…" |

The table above is the overview. The full final state of both bullets for each alternative
is in the sections below — apply the chosen alternative's section, not the table. The
current state is determined by reading `AGENTS.md`'s `## Communication` first bullet — if
its lead-in matches the chosen alternative, skip to Verify.

---

## `always-ask-first` (default)

If `AGENTS.md`'s `## Communication` first bullet already starts with "**Ask before acting
on ambiguity.**", the vault is already in this state — skip to Verify. Otherwise, apply
the bullets below.

### Bullet 1 — `## Communication` (first bullet)

```
- **Ask before acting on ambiguity.** When user intent is even slightly unclear, ask a clarifying question before reading artifacts or producing output. This takes precedence over "Think before acting" below — do not self-clarify by reading when a single question would resolve the ambiguity. Switch this threshold via customizations in `customizations/` (see `handbook/playbooks/customize-artifacts.md`).
```

### Bullet 2 — `## Output Style` (last bullet)

```
- **State assumptions made when inferring intent.** If you inferred instead of asking, call out the assumption explicitly so the user can correct it in one round.
```

---

## `approach-changing-only`

### Bullet 1 — `## Communication` (first bullet)

```
- **Ask only on approach-changing ambiguity.** When user intent is unclear, ask a clarifying question only when the answer would change the approach or scope; for trivial details, infer and state the assumption in the output. This takes precedence over "Think before acting" below — do not self-clarify by reading when a single question would resolve an approach-changing ambiguity.
```

### Bullet 2 — `## Output Style` (last bullet)

```
- **State assumptions made when inferring intent.** When you infer a trivial detail instead of asking, call out the assumption explicitly in the output so the user can correct it in one round.
```

---

## `read-then-confirm`

### Bullet 1 — `## Communication` (first bullet)

```
- **Read then confirm.** When user intent is unclear, read the directly-relevant artifact, then state the understood intent in one line and ask for confirmation before producing output. This takes precedence over "Think before acting" below — confirmation is required before producing output.
```

### Bullet 2 — `## Output Style` (last bullet)

```
- **State assumptions made when inferring intent.** If you inferred intent during the read-then-confirm step, call out the assumption explicitly in the confirmation line so the user can correct it in one round.
```

---

## Apply

1. Read `AGENTS.md` and locate the two bullets:
   - Bullet 1: the first bullet in `## Communication` (starts with a bold lead-in about
     asking/ambiguity).
   - Bullet 2: the last bullet in `## Output Style` (starts with
     "**State assumptions made when inferring intent.**").
2. Replace each bullet with the full text from the chosen alternative's section above.
   Use your native file-edit tools — match by the bold lead-in to find the bullet, then
   replace the entire bullet text.
3. Both bullets must be updated — they work as a pair. Updating only one leaves the
   policy inconsistent.

---

## Verify

After applying, run these assertions:

```bash
# The chosen alternative's lead-in should be present in AGENTS.md
rg -n "Ask before acting on ambiguity|Ask only on approach-changing ambiguity|Read then confirm" AGENTS.md
# expect: exactly 1 match, matching the chosen alternative

# The state-assumptions bullet should be present
rg -n "State assumptions made when inferring intent" AGENTS.md
# expect: exactly 1 match

# No stale lead-ins from other alternatives should remain
# (run the line below for each alternative you did NOT choose — expect 0 matches)
rg -n "Ask before acting on ambiguity" AGENTS.md    # 0 if you chose approach-changing-only or read-then-confirm
rg -n "Ask only on approach-changing" AGENTS.md     # 0 if you chose always-ask-first or read-then-confirm
rg -n "Read then confirm" AGENTS.md                 # 0 if you chose always-ask-first or approach-changing-only
```

If a stale lead-in check returns 1, the previous alternative's bullet was not fully
replaced — re-read `AGENTS.md`, find the stale bullet, and replace it with the chosen
alternative's text.

---

## Notes

- This decision touches only `AGENTS.md` — no templates, reference docs, or
  `manifest.yaml` changes.
- The three alternatives are **peers**, not inverses. Switching from one to another is
  always "apply a different alternative's section" — there is no "revert" operation.
