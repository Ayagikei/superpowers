---
name: receiving-code-review
description: Use when code review feedback must be evaluated, dispositioned, or implemented, especially when it is unclear or may expand scope
---

# Receiving Code Review

Treat feedback as evidence, not authority. Verify it against the approved
requirements and code before changing anything.

## Disposition

For each finding, choose one:

- **Required now:** fixes a missed requirement, introduced regression, security/
  data risk, build failure, or other blocker inside the approved scope.
- **Optional follow-up:** useful improvement that is not needed for this task.
- **Requirement expansion:** adds scenarios, migration/backfill, redesign,
  compatibility, or behavior beyond what the user approved.
- **Rejected:** technically incorrect or already covered; cite evidence.

Implement required findings. Do not implement follow-ups or expansions without
new authorization. If feedback is unclear and different interpretations would
change behavior, ask one focused question before editing.

## Fix loop

1. Verify the finding against the code and current evidence.
2. Fix blocking in-scope findings in dependency order.
3. Run the smallest validation covering each changed boundary.
4. Reuse still-valid evidence; do not replay unrelated suites after every item.
5. Request re-review only for open P0/P1 IDs or a materially changed risk boundary.
6. Run one fresh final verification for the integrated result before readiness.

Stop patch-chasing if feedback oscillates. Restate the invariant, identify the
root cause, and choose the smallest safe correction.

## Communication

Respond technically: state what was fixed, rejected, or deferred and why. Avoid
performative agreement. After handling external/subagent feedback, summarize the
real finding, disposition, and behavior impact in one or two sentences.

Reviewer feedback never authorizes commit, push, branch creation, migration,
dependency changes, or broader product behavior.
