---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation
---

# Code Review Reception

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. SCOPE-CHECK: Is this required for the approved task?
5. EVALUATE: Technically sound for THIS codebase?
6. RESPOND: Technical acknowledgment or reasoned pushback
7. IMPLEMENT: One item at a time, test each
8. REPORT-BACK: After handling subagent review, tell your human partner what was found, what changed, and whether behavior changed
```

## Scope Gate Before Any Change

**Technical correctness does not equal approval to expand scope.**

For each review item, ask:

1. Is it required to satisfy the approved plan / requirement?
2. Is it required to fix a regression or bug introduced by this task?
3. Is it required for build, tests, security, data correctness, or release safety?

**If yes:** treat it as in-scope and continue normal verification.

**If no:** treat it as a scope expansion.

**Default to requirement expansion** when the suggestion:
- broadens supported scenarios, user flows, or behavior beyond the approved task
- changes the time horizon or affected population (for example: future events only → historical events too)
- introduces backfill, compensation, migration, replay, or repair logic for existing data
- turns a narrow bugfix into a larger product or operational capability

- Do **not** implement it yet
- Report it to your human partner as an optional follow-up
- Explain why it was suggested, what files/behavior it would change, and what test scope would expand
- Wait for explicit approval before coding

If your human partner approves the extra work, record the approved delta before implementation:
- what extra change was approved
- why it is being added
- affected files / modules
- testcases or verification scope that must be updated
- how you will report the extra scope back to your human partner after implementation

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit CLAUDE.md violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From your human partner
- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From External Reviewers
```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first

IF technically valid but outside the approved task:
  Surface it as an optional follow-up
  Do not implement without your human partner's approval

IF technically valid but it expands the requirement:
  Treat it as a requirement expansion, not a normal review fix
  Stop and get your human partner's approval before any code changes
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

## YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Risk-Based Scope Control

```
IF a suggestion targets an ultra-edge, low-probability case:
  Estimate blast radius first

  IF fix requires broad or unpredictable changes:
    Prefer stable fallback/degradation over deep rewrites
    Push back unless user impact is material
```

**Prioritize fixes by real risk:**
- Must-fix first: crash, data loss, security, hangs, severe performance regressions
- Then: reproducible functional bugs
- Last: extreme edge cases (only when low-risk or explicitly required)

**KMP example:** Do not over-engineer around hypothetical "shared layer not fully rebuilt" anomalies unless they are reproducible in real workflows/environments.

## Implementation Order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Classify each item as in-scope, optional follow-up, or requirement expansion
  3. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  4. Test each fix individually
  5. Verify no regressions
  6. If fixes start oscillating (A->B->A), STOP and reassess root cause before more changes
```

## Detect Feedback Oscillation (A↔B Loops)

```
IF subagent feedback starts ping-ponging:
  "Fix A" causes B, then "Fix B" reintroduces A
THEN:
  1. Stop patch-chasing
  2. Identify one root cause and one invariant to protect
  3. Choose the smallest safe fix for real production risk
  4. Keep rare extremes on a basic fallback path unless explicitly requested
```

Goal: robust production behavior, not theoretical perfection through high-risk over-fixing.

## When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions
- Suggestion optimizes ultra-edge scenarios with high blast radius and low user impact
- Suggestion enlarges the requirement beyond what your human partner approved

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**Signal if uncomfortable pushing back out loud:** "Strange things are afoot at the Circle K"

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]
✅ "This is a valid follow-up, but it expands the approved scope. I have not changed it; surfacing it for approval."

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Post-Review Summary Back To Your Human Partner

If you handled feedback from a subagent or other external reviewer, do **not** disappear into silent implementation.

After you finish evaluating and acting on that feedback, give your human partner a **1-2 sentence summary** that covers:

1. **What the reviewer actually found** — real bug, code-quality issue, mismatch with intent, or expected behavior / false alarm
2. **What you did about it** — fixed it, partially fixed it, or intentionally left it unchanged with reason
3. **Whether behavior changed** — user-visible behavior change, internal-only cleanup, or no behavior change

This summary is for human oversight. Your human partner may agree with your fix, reject it, or decide the reviewer found an intended behavior. Surface that decision point clearly instead of forcing them to reconstruct it from the diff.

### Required Cases

Give this summary when:
- you accepted and implemented a subagent / external review suggestion
- you investigated a review item and decided it was expected behavior or not worth changing
- you implemented only part of the suggestion because the rest was out of scope or too risky

Do **not** skip the summary just because the fix was small or because you think the diff is self-explanatory.

### Summary Pattern

Keep it short and factual:

```text
Subagent found [issue type]. I [fixed / declined / narrowed] it by [change]. [Behavior impact sentence].
```

### Good Examples

```text
Subagent found that the retry path could bypass the existing timeout guard. I fixed it by routing retries through the same bounded helper. This should not change normal behavior, but it now fails fast instead of hanging on that edge path.
```

```text
Subagent flagged the current empty-state branch, but after checking the approved flow I confirmed that behavior is intentional. I left the code unchanged. No behavior changed.
```

```text
Subagent found a valid null-handling bug, but the broader fallback they suggested would expand scope. I fixed the crash with a narrow guard and did not add the larger recovery path. Behavior changes only for that invalid-input case; normal flow stays the same.
```

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right - I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Implementing technically valid but out-of-scope feedback | Surface it, get approval, record scope/test impact first |
| Treating requirement expansion as "same bug, bigger fix" | Stop, call out the requirement change, get approval before coding |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |
| Over-fixing rare edge cases | Prioritize by user impact; keep fallback when safer |
| Ping-ponging A↔B fixes | Stop, reassess root cause, then pick smallest safe change |
| Fixing subagent feedback silently | Add a 1-2 sentence summary of what was found, what you changed, and whether behavior changed |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that..."
```

**Technical Verification (Good):**
```
Reviewer: "Remove legacy code"
✅ "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID - fix it or drop pre-13 support?"
```

**YAGNI (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "Grepped codebase - nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Good):**
```
your human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
✅ "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

**Scope Expansion Disguised as Optimization (Bad):**
```
Context: Iteration adds custom sound effects. Reviewer says:
"While you're here, switch item loading to use in-memory state instead of repo lookup. It should be faster."

❌ "Makes sense - I'll optimize that too."
❌ [Changes retrieval to in-memory state without asking]
```

**Scope Expansion Disguised as Optimization (Good):**
```
Context: Iteration adds custom sound effects. Reviewer says:
"While you're here, switch item loading to use in-memory state instead of repo lookup. It should be faster."

✅ "This is a possible follow-up, but it expands the approved scope. I have not changed it."
✅ "Current expected behavior is repo-backed fallback; in-memory state may be incomplete here."
✅ "If you want this optimization, I need approval first and will record the extra scope, affected retrieval path, and expanded tests/verification."
```

**Requirement Expansion Disguised as Thoroughness (Bad):**
```
Context: Bug fix is approved only for future history writes on new events. Reviewer says:
"We should also compensate legacy events that already missed writes."

❌ "That's reasonable - I'll add a compensation pass too."
❌ [Implements backfill / repair flow without asking]
```

**Requirement Expansion Disguised as Thoroughness (Good):**
```
Context: Bug fix is approved only for future history writes on new events. Reviewer says:
"We should also compensate legacy events that already missed writes."

✅ "That may be a valid follow-up, but it expands the requirement from forward-only fixes to historical remediation."
✅ "I have not implemented it. Backfill/compensation changes scope, blast radius, and verification scope."
✅ "If you want this approved, I need confirmation first and will record the extra behavior, affected data range, and expanded tests/verification."
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## The Bottom Line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Then implement.

No performative agreement. Technical rigor always.
