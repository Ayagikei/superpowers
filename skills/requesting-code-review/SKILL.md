---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch superpowers:code-reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review deliberately, not uniformly — keep review outcomes inside the approved scope, and scale review ceremony to task complexity.

## Lane Guidance

Use the same lane model as `brainstorming`, `writing-plans`, and `verification-before-completion`:

| Lane | Default review stance |
|---|---|
| Trivial | Independent reviewer optional by default |
| Standard | Independent reviewer default-allowed and recommended; local review still allowed |
| Heavy | Independent reviewer is the default gate |

If the task shows any higher-risk signal, upgrade it to the higher lane.

Reviewer subagents for code review are **policy-allowed by default**. If a specific runtime harness separately asks for authorization before spawning one, treat that as an environment exception rather than the repository's default policy.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main
- For mobile changes (iOS/Android/KMP), also consult `mobile-diff-review` for platform-specific risk checks

**Optional but valuable:**
- Trivial work when the user still wants an independent check
- Standard work when you want an outside read before submission
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch code-reviewer subagent:**

Use Task tool with superpowers:code-reviewer type, fill template at `code-reviewer.md`

**2.1 Treat reviewer as a leaf node:**

When dispatching a reviewer, explicitly lock the reviewer to direct review work:
- It is the direct review subagent for this request
- It must not call, delegate to, or suggest any other subagent
- It must not perform nested review
- It must not discuss tool/platform limits
- It must base conclusions only on the approved scope, provided diff / SHAs / file range, and code it directly inspects
- If something is missing, it should name the missing input briefly and still return the best review possible from available evidence

**2.2 Wait patiently for the review:**

Code review is not an RPC. Give the reviewer enough time to read the diff, compare it to the plan, and write actionable findings.

- If you can continue other non-overlapping work, do that first and let review run in the background
- If review is on the critical path, wait in longer intervals rather than busy-polling
- In Codex, record the reviewer `agent_id`, then use `wait_agent` when blocked (prefer one longer wait over short polling)
- Do not interrupt just because the first `wait_agent` returned no result
- In Codex, close the reviewer with `close_agent` once you have integrated or dispositioned the result and no follow-up is needed
- Only interrupt when priorities changed, the context became stale, or you have strong evidence the reviewer is stuck

**2.3 Frame the review around approved scope:**

Tell the reviewer to separate:

- **In-scope issues** — missing requirements, regressions, correctness problems, test gaps, or production risks that must be fixed for the approved task
- **Out-of-scope follow-ups** — optional optimizations, refactors, cleanup, or adjacent improvements that may be valid ideas but are **not approved changes**
- **Requirement expansions** — broader behavior changes, additional scenario support, legacy backfills/compensation/migrations, or other suggestions that materially extend what this task delivers

Technically sound feedback is not automatic approval to expand scope. If a reviewer proposes a larger requirement than the approved task, that still needs user approval.

**2.5 If the diff touches mobile code (iOS/Android/KMP):**

Run an additional pass with `mobile-diff-review` to catch mobile-specific issues (memory leaks, coroutine/thread misuse, main-thread blocking, rendering regressions, and data consistency risks).

**Placeholders:**
- `{WHAT_WAS_IMPLEMENTED}` - What you just built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit
- `{DESCRIPTION}` - Brief summary

**3. Act on feedback:**
- Recommended: Pair with `receiving-code-review` to process feedback before implementation
- First classify each review item: **required now**, **optional follow-up**, or **requirement expansion**
- Fix Critical in-scope issues immediately
- Fix Important in-scope issues before proceeding
- Note Minor issues for later
- Do **not** implement optional follow-ups or requirement expansions without explicit user approval
- If the user approves extra scope, record the approved delta before coding: what is being added, why, affected files, and what tests / verification scope must expand
- Push back if reviewer is wrong (with reasoning)

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch superpowers:code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: Verification and repair functions for conversation index
  PLAN_OR_REQUIREMENTS: Task 2 from docs/superpowers/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

## Integration with Workflows

**Subagent-Driven Development:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Executing Plans:**
- Review after each batch (3 tasks)
- Get feedback, apply, continue

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Red Flags

**Never:**
- Silently skip review when the chosen lane still requires or expects it
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback
- Treat a slow reviewer as a failed reviewer after one short wait
- In Codex, replace subagent waiting with shell waits, ad-hoc polling commands, or other non-agent blocking patterns
- Interrupt a reviewer just to get a faster but shallower answer
- Let a reviewer spawn, delegate to, or suggest another reviewer / subagent
- Let a reviewer convert missing context into tool-limit discussion instead of a direct review result
- Treat a reviewer suggestion as approved scope just because it sounds technically right
- Piggyback an optimization / refactor / cleanup that was not part of the approved task
- Treat a reviewer-proposed requirement expansion as a normal bugfix just because it belongs to the same defect family

**Lane-specific note:**
- Trivial work may legitimately skip independent review
- Standard work may use local review instead of an independent reviewer, but reviewer subagent use should not require special project-policy permission
- Heavy work should not silently downgrade review without user authorization

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: requesting-code-review/code-reviewer.md
