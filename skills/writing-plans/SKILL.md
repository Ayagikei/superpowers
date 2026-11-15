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

1. **What changes for users (first, plain language):** a short list your human
   partner can approve without reading the rest. Name every new page, dialog,
   or blocking state; new startup or main-thread work; new check or limit that
   can reject a user operation, and what it rejects; new background work or
   stored data. Write "none" for empty items. No internal state names,
   milestone codes, or agent names.
2. **Goal and acceptance:** user-visible result, non-goals, and completion bar.
3. **Constraints:** product invariants, permission boundary, compatibility,
   security/privacy, and dependencies.
4. **File map:** exact files or modules and each one's responsibility.
5. **Tasks:** coherent, independently checkable deliverables in dependency order.
6. **Interfaces:** signatures, state transitions, or data flow where neighboring
   tasks depend on exact contracts.
7. **Validation:** targeted commands, expected evidence, and one final integration
   check. Include failure handling when validation is unavailable.
8. **Open questions:** only decisions that still block or materially change implementation.

## Safeguard budget

Every safeguard in the plan (check, limit, fallback, block, retry, rescue
state) must name the concrete failure it prevents, what the user loses without
it, and which normal operations it could reject or slow. A threat category
such as "attack" or "resource exhaustion" is not a concrete failure; name who
can construct the input and how it gets in. Drop safeguards that cannot answer,
that duplicate an existing check, that sit in front of a root cause the plan
could fix instead, or that guard a failure downstream code already reports or
rolls back. Optional protection must skip on failure instead of blocking the
main flow or startup.

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
placeholders, validation completeness, and the safeguard budget. Fix plan
defects inline.
