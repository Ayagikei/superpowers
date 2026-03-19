---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, passing, or ready to commit or merge
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.
If you haven't shown the user a visible verification scorecard and summary, you cannot claim the work is complete, fixed, ready to commit, or ready to merge.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: Continue to presentation
5. PRESENT: Output a visible `Verification Scorecard` and `Verification Summary`
6. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Required User-Facing Output

Before any completion claim, ready-to-commit statement, or merge recommendation, you MUST output these two sections for the user:

```markdown
## Verification Scorecard

| Check | Blocking | Command / Method | Fresh Evidence | Result |
|---|---|---|---|---|
| Build | Yes | `scripts/build-ios.sh --ios-only` | exit 0 | ✅ Pass |
| Repro Fix | Yes | Mobile MCP | screenshot path / observed behavior | ✅ Pass |
| Scope Check | Yes | `git diff --stat` | changed files list | ✅ Pass |
| Optional Regression | No | targeted scenario | not run | ⏳ Not Run |

## Verification Summary

- Blocking checks: 3/3 passed
- Non-blocking checks: 0/1 passed
- Ready to commit: Yes
- Remaining gaps: None
```

Rules:
- Use the exact section titles: `Verification Scorecard` and `Verification Summary`
- Adapt the rows to the task, but always include every blocking check that gates your claim
- If any blocking check is `❌ Fail` or `⏳ Not Run`, then `Ready to commit` / `Ready to merge` MUST be `No`
- If a check is not applicable, say so explicitly instead of silently omitting the gate
- Do not hide verification inside prose when a visible scorecard is required

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |
| Ready to commit | Visible scorecard + summary with all blocking checks passed | "Build and MCP passed" in prose |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Running checks but not showing a visible scorecard
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "I already mentioned the checks in prose" | Completion claims require a visible scorecard + summary |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**User-facing completion / commit recommendation:**
```
✅ [Verification Scorecard] [Verification Summary] "Ready to commit: Yes"
❌ "Build + MCP passed, ready to commit"
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## Why This Matters

From 24 failure memories:
- your human partner said "I don't believe you" - trust broken
- Undefined functions shipped - would crash
- Missing requirements shipped - incomplete features
- Time wasted on false completion → redirect → rework
- Violates: "Honesty is a core value. If you lie, you'll be replaced."

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

## The Bottom Line

**No shortcuts for verification.**

Run the command. Read the output. Show the scorecard. Show the summary. THEN claim the result.

This is non-negotiable.
