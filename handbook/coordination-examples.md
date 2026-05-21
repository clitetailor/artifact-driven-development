# Coordination Workflow Examples
> Worked examples showing how scenarios, change-requests, and milestones interact.

For the decision rules, see `../reference/coordination-decision-tree.md`.

---

## Example 1: New Feature (Planned Work)

```
1. BA writes requirement with scenarios
   → req-user-authentication
      ├─ scenario-1: Login
      └─ scenario-2: Logout

2. Architect creates tasks
   → task-login-be
   → task-session-be
   → task-login-fe

3. Coordinator creates milestone (optional)
   → milestone-sprint-1
      └─ refs: [req-user-authentication, task-login-be, task-session-be, task-login-fe]
```

Artifacts created: requirement (with scenarios), tasks, milestone (optional).

---

## Example 2: Simple Change Request

```
1. Engineer discovers a typo in API response
   → cr-fix-session-typo filed
      └─ refs: [api-user-authentication]

2. Owner applies the change to the target artifact

3. Single task created
   → task-fix-session-typo-be
   → cr.refs += [task-fix-session-typo-be]
   → cr.status = applied

4. If milestone exists:
   → milestone-sprint-1.refs += [cr-fix-session-typo, task-fix-session-typo-be]
```

Artifacts created: change-request, task.

---

## Example 3: Larger Change Request

```
1. Engineer discovers missing rate limiting
   → cr-add-rate-limiting filed
      └─ refs: [api-user-authentication]

2. Owner applies the contract change

3. Multiple tasks created — all listed in the CR's refs
   → task-rate-limit-middleware-be
   → task-rate-limit-config-be
   → task-rate-limit-tests-be
   → cr.refs += all three task ids
   → cr.status = applied

4. If milestone exists:
   → milestone-sprint-1.refs += [cr-add-rate-limiting, ...three tasks]
```

Artifacts created: change-request, tasks. The CR plays the role of "what motivates this work"; no separate grouping artifact is needed.

---

## Example 4: Advisory (Noted for Future)

```
While implementing task-login-be, engineer notices:
"Session refresh logic could be extracted into a shared helper if we add OAuth later."

→ adv-extract-session-refresh-helper filed
   ├─ refs: [task-login-be, api-user-authentication]
   └─ status: open

Live list of open improvements:
  rg "type: advisory" /vault | xargs rg -L "status: resolved"
```

Artifacts created: advisory. No action required now — picked up later when the conditions actually arise.

---

For body templates, see `../templates/requirement.md`, `../templates/milestone.md`, `../templates/change-request.md`, `../templates/advisory.md`.
