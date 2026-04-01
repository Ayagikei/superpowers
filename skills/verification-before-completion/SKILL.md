---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, passing, or ready to commit or merge
---

# Verification Before Completion

## Overview

This skill has **two gates**:

1. **Claim Gate** — fresh evidence before any success claim
2. **Commit / Merge Gate** — a visible readiness panel before commit, PR, or merge

**Core principle:** evidence before claims, readiness before submission.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
NO READY-TO-COMMIT / READY-TO-MERGE CLAIMS WITHOUT A VISIBLE READINESS PANEL
```

If you have not run the proving command in this message, do not claim success.
If you have not shown the user a short scorecard plus summary, do not recommend commit / PR / merge.

## Gate 1: Claim Verification

Before saying work is complete, fixed, or passing:

1. **IDENTIFY** the exact command or method that proves the claim
2. **RUN** it fresh
3. **READ** full output, exit code, failures, and missing coverage
4. **REPORT** the actual result with evidence

Skip any step = not verified.

## Gate 2: Commit / Merge Readiness

Before commit, PR, or merge:

1. Classify the task lane: **trivial / standard / heavy**
2. Decide which checks are **applicable**
3. Decide which checks are **Hard Gate**, **Conditional**, or **Optional by lane**
4. Run the applicable checks
5. Show the user a **readiness panel** scaled to the lane
6. If any applicable **Hard Gate** is missing or failed, `Ready to commit / merge` must be **No**
7. Stop unless the user gives an **explicit authorization override**

## Graduated Readiness Lanes

| Lane | Review default | Readiness output | Typical use |
|---|---|---|---|
| Trivial | independent review optional by default | lightweight panel | copy tweaks, narrow UI polish, tiny low-risk fixes |
| Standard | independent review conditional by default; local review allowed | short scorecard | bounded multi-file or low-risk behavior changes |
| Heavy | independent review hard by default | full scorecard | broad, risky, or architecture-sensitive work |

If the work shows any higher-risk signal, upgrade it to that lane before applying readiness rules.

## Default Check Matrix

Use these defaults unless the project has a stricter rule.

| Check | Default Level by Lane | Applies When | Expected Evidence |
|---|---|---|---|
| Independent code review via `requesting-code-review` | Trivial: Optional / Standard: Conditional / Heavy: Hard Gate | Most code changes | reviewer result |
| Review disposition for all review streams (fixed / deferred / rejected with reason) | Trivial: Only if review ran / Standard: Conditional / Heavy: Hard Gate | Any review returned findings | short disposition list |
| Automated tests / regression | Conditional | Tests exist, logic changed, or bugfix touched covered code | fresh test output |
| New or updated automated tests | Conditional | New behavior or logic fix where tests are practical | added test + fresh pass |
| TDD flow followed via `test-driven-development` | Conditional by default | Logic-heavy behavior, repository/domain work, or bugfix where tests are practical | failing test + fresh pass |
| Testcase backfill / usecase update and status | Conditional | Client app feature iteration, user-facing flow, QA handoff, release validation, or manual acceptance tracking | doc path + updated cases/status |
| Mobile diff review via `mobile-diff-review` | Conditional | iOS / Android / KMP diff | review result |
| Mobile MCP acceptance via `ios-simulator-mobile-mcp` / `android-mobile-mcp` | Conditional | Client UI / flow change and simulator or emulator validation is practical | screenshot / evidence path |
| Automated UI / acceptance flow | Bonus by default | Existing suite exists or automation is practical | fresh run output |

Notes:
- `requesting-code-review` is the default independent review workflow when the chosen lane requires or benefits from it.
- `Review disposition` covers findings from `requesting-code-review`, `mobile-diff-review`, and any other explicit review stream you asked an agent to run.
- When TDD applies, use `test-driven-development`. If the project or user explicitly required TDD, upgrade this check from **Conditional** to **Hard Gate**.
- For testcase docs / backfill, use project convention first. If a structured checklist needs to be drafted or backfilled, use `test-case-summary` and adapt it to any project-specific house style.
- For client app feature iteration, prefer marking testcase backfill as applicable unless there is a clear reason it does not exist in the team's workflow.
- `Mobile MCP` is **not** a universal blocker. Only mark it applicable for real client validation scenarios.

## Change-Type Heuristics

Use these heuristics to choose the lane faster:

| Change Type | Default Lane | Notes |
|---|---|---|
| Docs-only / copy-only / tiny UI polish | Trivial | upgrade if the change affects rules, flows, or multiple surfaces |
| Bounded feature adjustment / small multi-file change | Standard | local review may be enough |
| New feature / broad refactor / state-flow change | Heavy | keep the strongest default gates |

## Required User-Facing Output

Before any completion claim, ready-to-commit statement, or merge recommendation, output a readiness panel in the user's language:

- **Trivial:** lightweight panel
- **Standard:** short scorecard + summary
- **Heavy:** full scorecard + summary

For standard/heavy work, keep the scorecard structure below:

```markdown
## [Localized Readiness Scorecard Title]

| [Localized Check] | [Localized Level] | [Localized Applies] | [Localized Status] | [Localized Evidence] | [Localized Gap] |
|---|---|---|---|---|---|
| Code review | Hard / Conditional / Optional | Yes | ✅ | review done | None |
| Review fixes | Hard / Conditional | Yes | ⚠️ | 1 deferred | 1 item |
| Tests | Conditional | Yes | ✅ | 38/38 | None |
| Testcase backfill | Conditional | No | N/A | — | Not needed |
| Mobile MCP | Conditional | Yes | ⏳ | not run | simulator check |
| UI automation | Bonus | No | N/A | — | Not needed |

## [Localized Readiness Summary Title]

- [Localized Robustness Score]: 78/100
- [Localized Ready to Commit / Merge]: No
- [Localized Key Gaps]:
  - Mobile MCP acceptance not run
  - 1 review item deferred
```

Rules:
- Keep table cells short; move detail to summary bullets
- If a check is not applicable, say so explicitly instead of silently omitting it
- If any applicable **Heavy-lane Hard Gate** is `❌ Fail` or `⏳ Not Run`, then `Ready to commit / merge` must be `No` unless the user explicitly authorizes proceeding

## Explicit Override Protocol

Default blockers may still be overridden by the user.

**Valid override requirements:**
- The user must explicitly authorize continuing with commit / PR / merge
- The authorization must clearly refer to proceeding despite the shown readiness gaps
- The user does **not** need a rigid magic phrase
- The user does **not** need to enumerate every skipped gate individually if the authorization clearly applies to the shown panel

**Valid examples:**
- `我授权你继续提交`
- `我授权跳过这个 review，继续 commit`
- `授权继续提交`
- `I authorize proceeding with the commit despite the review gap`

**Invalid examples:**
- `直接提吧`
- `ship it`
- `应该没问题`

After a valid override:
1. Echo back the overridden checks or shown gaps that are being accepted
2. Echo back that the user explicitly authorized proceeding
3. Mark overridden rows as `⚠️ Override`
4. Then proceed only with the action the user authorized
## Scoring Standard

Use this default weighting unless the project defines its own:

| Level | Weight |
|---|---|
| Hard Gate | 5 |
| Conditional | 3 |
| Optional | 1 |
| Bonus | 1 |

Scoring rules:
- `Pass` = full weight
- `Fail`, `Not Run`, `Override` = 0
- `N/A` rows are excluded from the denominator
- `Robustness Score = earned_weight / applicable_weight * 100`, rounded to the nearest integer
- Missing applicable Heavy-lane Hard Gates still mean **Not Ready**, even if the score looks decent

Suggested bands:
- `90-100` Strong
- `75-89` Good with minor gaps
- `60-74` Risky, user should review gaps carefully
- `<60` Not ready

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Fresh test output: 0 failures | Previous run, "should pass" |
| Bug fixed | Repro or regression evidence | Code changed, assumed fixed |
| Review complete | Reviewer output + disposition of findings | "I looked at the diff myself" |
| Mobile flow verified | Mobile MCP evidence or explicit N/A | "UI seems fine" |
| TDD followed | Failing test first + fresh pass, or explicit approved skip when not practical | "I added tests afterward" |
| Testcase backfilled | Doc path + updated cases/status | "Will update later" |
| Ready to commit | Visible scorecard + summary + applicable Hard Gates passed or explicitly overridden | "Build and MCP passed" in prose |

## Red Flags - STOP

- Using "should", "probably", or "seems to"
- About to commit / push / PR without a readiness panel
- Treating every check as universally applicable
- Showing a table but hiding the real gaps in prose
- Assuming user intent to override from urgency alone
- Trusting agent success reports without independent verification

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "I already showed a scorecard" | A scorecard without the right checks is still incomplete |
| "Mobile MCP doesn't matter here" | Mark it `N/A` explicitly and say why |
| "Review is implied" | Hard Gates must be visible, not implied |
| "User said hurry" | Hurry is not an override |
| "The table would be too long" | Keep cells short; move detail to summary bullets |
| "Different words so rule doesn't apply" | Spirit over letter |

## Short Examples

**Example A: Backend bugfix**

```markdown
## 验证评分表

| 检查项 | 级别 | 适用 | 状态 | 证据 | 缺口 |
|---|---|---|---|---|---|
| Code review | Hard | Yes | ✅ | review ok | None |
| Review fixes | Hard | Yes | ✅ | all fixed | None |
| Tests | Conditional | Yes | ✅ | 12/12 | None |
| TDD flow | Conditional | Yes | ✅ | RED→GREEN | None |
| Testcase backfill | Conditional | No | N/A | — | Not needed |

## 验证汇总

- 稳健度评分：100/100
- 可提交：Yes
- 关键缺口：None
```

**Example B: Mobile UI flow**

```markdown
## 验证评分表

| 检查项 | 级别 | 适用 | 状态 | 证据 | 缺口 |
|---|---|---|---|---|---|
| Code review | Hard | Yes | ✅ | review ok | None |
| Review fixes | Hard | Yes | ⚠️ | 1 deferred | 1 item |
| Mobile diff review | Conditional | Yes | ✅ | review ok | None |
| Mobile MCP | Conditional | Yes | ⏳ | not run | simulator |

## 验证汇总

- 稳健度评分：50/100
- 可提交：No
- 关键缺口：
  - Mobile MCP 未执行
  - 1 条 review 建议延后
```

## The Bottom Line

Run the checks. Read the output. Show a short scorecard. Show a clear summary. Stop on missing Hard Gates unless the user explicitly accepts the risk.
