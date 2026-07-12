---
name: using-superpowers
description: Use when starting a new request or entering a new workflow phase and the relevant skill route is not yet clear
---

<SUBAGENT-STOP>
If you were dispatched with a bounded brief, do not load this or other
orchestration skills. Follow the brief. Load only domain skills explicitly
named by the controller or essential to the assigned technical work.
</SUBAGENT-STOP>

# Using Superpowers

Select the smallest workflow that preserves correctness. A phase has one
workflow owner; domain skills may supplement it without replaying its process.

## Route by task state

| Situation | Workflow owner |
|---|---|
| Answer, explain, inspect, or read-only review | No process skill unless a domain skill materially helps |
| Unexpected behavior, failing test, or unclear root cause | `systematic-debugging` |
| Creative, behavioral, UX, risky, or materially ambiguous change | `brainstorming` |
| Clear local edit with settled requirements | Direct implementation; use TDD when its scope gate applies |
| Approved multi-step plan | `executing-plans`, or `subagent-driven-development` when bounded delegation has a clear benefit |
| Claiming readiness or completion | `verification-before-completion` once at the delivery boundary |
| Integration or branch cleanup remains | `finishing-a-development-branch` |

## Workflow lanes

- **Trivial:** local, reversible, directly verifiable. Keep planning and review inline.
- **Standard:** bounded multi-file or user-visible work. Use a short design/plan,
  targeted validation, and risk-based review.
- **Heavy:** high failure cost, unclear architecture, weak automated validation,
  or security/concurrency/persistence/migration risk. Use durable design/plan,
  explicit gates, and independent final review.

Choose the lane from observable risk, not code size alone. Upgrade when risk or
uncertainty grows; downgrade when the problem collapses to a local change.

## Rules

- State each instruction once. Preserve safety, permission, evidence, and product invariants.
- Prefer outcome, constraints, acceptance criteria, evidence, and stop conditions over scripted steps.
- Do not load every possibly relevant skill. Load a skill when it owns the current
  phase or contributes technical guidance that changes the work.
- Re-check routing only when the phase or risk changes.

## Platform references

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`

## Priority

User and repository instructions override skills. Skills override generic
defaults only within their declared scope.
