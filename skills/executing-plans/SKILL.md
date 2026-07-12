---
name: executing-plans
description: Use when an approved written implementation plan should be executed primarily by the current agent
---

# Executing Plans

Execute the approved outcome end to end while preserving scope and evidence.

## Workflow

1. Read the canonical plan and current repository state once. Raise only a
   contradiction or missing decision that prevents safe execution.
2. Execute coherent tasks in dependency order. Keep setup, implementation,
   tests, and documentation together with the deliverable they support.
3. Stay inside the approved boundary. Record a scope delta and ask only when a
   material expansion, destructive action, shared-contract change, or external
   side effect requires new authority.
4. Run targeted validation as behavior becomes available. Reuse still-valid
   evidence rather than replaying the same command at every checkpoint.
5. Inspect the complete diff and run one fresh final verification before
   claiming readiness or performing an authorized commit.

Use a subagent for a bounded exploration, implementation, verification, or
review only when it has a concrete speed, isolation, or quality benefit. Loading
this skill does not require switching to `subagent-driven-development`.

## Review

- Trivial: main-agent self-review.
- Standard: main-agent diff review; one independent final reviewer only when
  risk, uncertainty, user impact, or weak validation justifies it.
- Heavy: independent final review by default; targeted specialist review only
  for a distinct high-risk boundary.

Re-review only blocking findings after fixes. Reviewer suggestions do not expand
the approved scope.

## Stop conditions

Stop when the plan is contradictory, required scope must materially expand,
validation repeatedly fails for an unknown cause, or a product/architecture/risk
decision is missing. Otherwise continue without routine approval prompts.

Use `finishing-a-development-branch` only when branch integration or cleanup is
actually part of the authorized task.
