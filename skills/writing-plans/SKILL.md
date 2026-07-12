---
name: writing-plans
description: Use when an approved change needs durable multi-step implementation guidance or handoff before code changes
---

# Writing Plans

Write the smallest plan that lets an engineer implement the approved outcome
without rediscovering decisions. Plans describe deliverables, not every routine
keystroke.

## Artifact choice

| Lane | Artifact |
|---|---|
| Trivial | No plan file; keep a short inline checklist if useful |
| Standard | One `delivery-plan.md` combining rationale, constraints, implementation tasks, and validation |
| Heavy | Keep the approved design spec separate; write an implementation plan that references it instead of copying it |

Follow the repository's existing `docs/plans`, `docs/plan`, `docs/planning`, or
feature-doc convention. Do not create or commit a plan merely because this skill
was loaded.

## Required plan content

1. **Goal and acceptance:** user-visible result, non-goals, and completion bar.
2. **Constraints:** product invariants, permission boundary, compatibility,
   security/privacy, and dependencies.
3. **File map:** exact files or modules and each one's responsibility.
4. **Tasks:** coherent, independently checkable deliverables in dependency order.
5. **Interfaces:** signatures, state transitions, or data flow where neighboring
   tasks depend on exact contracts.
6. **Validation:** targeted commands, expected evidence, and one final integration
   check. Include failure handling when validation is unavailable.
7. **Open questions:** only decisions that still block or materially change implementation.

Use code snippets only when exact syntax or an interface would otherwise be
ambiguous. Do not copy full implementations into the plan, require artificial
2–5 minute steps, or add commit steps without commit authorization.

## Task sizing

A task is a coherent deliverable that one owner can implement and validate
without competing edits. Split when contracts, risk, or ownership differ; merge
setup, tests, docs, and cleanup into the deliverable they support.

## Execution route

- Use `executing-plans` when the main agent can implement efficiently in context.
- Use `subagent-driven-development` only when bounded delegation materially
  improves speed, isolation, or review quality.
- Do not recommend fresh implementer and reviewer agents per task by default.

Before handoff, check requirement coverage, type/interface consistency,
placeholders, and validation completeness. Fix plan defects inline.
