---
name: subagent-driven-development
description: Use when an approved implementation plan contains bounded work that benefits from context isolation or delegated execution in the current session
---

# Subagent-Driven Development

Delegate bounded work while the main agent keeps product decisions, scope,
actual-diff review, integration, and final delivery.

## Use gate

Use this workflow only when delegation has a concrete benefit: independent
exploration, isolated implementation, specialist review, long-running validation,
or meaningful parallelism. Execute directly when work is trivial, tightly
coupled, or cheaper to keep in the main context.

## Delegation depth

- Default depth is 1: main agent → worker.
- Maximum depth is 2: main agent → worker → one bounded specialist.
- A worker may use depth 2 only for a distinct read-only exploration or review
  question with clear inputs and output evidence. It may not delegate its main
  implementation, create another coordinator, or start a review chain.
- A reviewer is terminal at its assigned depth.

Include the remaining depth budget in every dispatch.

## Worker skill budget

Workers follow the task brief directly. They do not load orchestration/process
skills such as `using-superpowers`, `brainstorming`, `writing-plans`, this skill,
`executing-plans`, `planning-with-files`, or branch closeout. They may load a
domain, debugging, or TDD skill when the brief names it or the assigned technical
work clearly requires it.

## Controller workflow

1. Review the approved plan once for contradictions and dependency order.
2. Select direct execution or a worker for each coherent deliverable. Do not
   create one worker merely because a task heading exists.
3. Dispatch an outcome-first brief containing:
   - outcome and where it fits;
   - file/scope boundary and forbidden actions;
   - product and interface invariants;
   - acceptance criteria and validation command;
   - remaining delegation depth;
   - required report shape.
4. When a worker finishes, inspect the actual diff and scope. The main agent
   decides whether the deliverable satisfies the plan.
5. Reuse valid worker test evidence. Do not rerun the same targeted command when
   the report includes the exact command, exit code, key output, and no later
   change invalidated it.
6. Rerun targeted validation only when evidence is missing or suspicious, the
   affected code changed afterward, workers overlapped, or integration/high-risk
   behavior requires fresh evidence.
7. After all deliverables, run one fresh final verification appropriate to the
   whole change before claiming readiness or committing.

## Review policy

The main agent reviews each delivered diff. Independent reviewer agents are
risk-triggered, not task-count-triggered:

- **Trivial:** no independent reviewer by default.
- **Standard:** at most one final reviewer when user impact, uncertainty, or
  weak validation makes it useful.
- **Heavy:** one strong final reviewer by default. Add a targeted specialist
  only for a distinct high-risk boundary.

Use a per-deliverable reviewer only when that boundary is independently risky
and delaying review would make later work unsafe. Re-review only open blocking
findings; do not replay a clean whole-task review.

## Progress and recovery

When durable tracking is active, update its existing `task_plan.md` and
`progress.md`. Do not create a second SDD-specific ledger or copy the plan into
dispatch prompts. Hand workers the smallest task brief or file path that carries
their requirements.

When the runtime needs file-backed SDD artifacts such as briefs, reports, or
review packages, scope the transient workspace to the approved plan:

```bash
skills/subagent-driven-development/scripts/sdd-workspace <plan-file>
```

The plan basename must be unique within the worktree. Treat this workspace as
temporary controller state, not as another product plan. Do not delete it
without the user's authorization.

For an open blocking finding, resume the original implementer when the runtime
supports it, then run a scoped re-review of that finding and the fix diff.
Cap the loop at five rounds, stop earlier when the same finding repeats without
material progress, and return product, architecture, or scope decisions to the
main agent. Do not turn this into a mandatory per-task review loop.

## Worker report

```text
Status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
Files changed: <paths and one-line purpose>
Validation: <exact command> -> <exit code and key result>
Scope drift: none | <details>
Concerns: none | <details requiring controller judgment>
Delegation used: none | <specialist task and result>
```

The worker does not commit, push, create branches, expand scope, or resolve
product/architecture ambiguity unless the brief explicitly authorizes it.

## Stop conditions

Stop and return control when required scope expands, an invariant is unclear,
validation repeatedly fails outside the assigned boundary, or a product/risk
decision is needed. Otherwise continue through the approved plan without asking
for routine permission.
