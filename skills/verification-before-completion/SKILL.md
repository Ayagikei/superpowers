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

1. Decide which checks are **applicable**
2. Run the applicable checks
3. Classify each check as **Hard Gate**, **Conditional**, or **Bonus**
4. Show the user a **readiness scorecard** and **summary**
5. If any applicable **Hard Gate** is missing or failed, `Ready to commit / merge` must be **No**
6. Stop unless the user gives an **explicit override**

## Default Check Matrix

Use these defaults unless the project has a stricter rule.

| Check | Level | Applies When | Expected Evidence |
|---|---|---|---|
| Independent code review via `requesting-code-review` | Hard Gate | Most code changes | reviewer result |
| Review disposition (fixed / deferred / rejected with reason) | Hard Gate | Review returned findings | short disposition list |
| Automated tests / regression | Conditional | Tests exist, logic changed, or bugfix touched covered code | fresh test output |
| New or updated automated tests | Conditional | New behavior or logic fix where tests are practical | added test + fresh pass |
| Testcase / usecase doc update and status | Conditional | User-facing flow, QA handoff, release validation, or manual acceptance tracking | doc path + updated status |
| Mobile diff review via `mobile-diff-review` | Conditional | iOS / Android / KMP diff | review result |
| Mobile MCP acceptance via `ios-simulator-mobile-mcp` / `android-mobile-mcp` | Conditional | Client UI / flow change and simulator or emulator validation is practical | screenshot / evidence path |
| Automated UI / acceptance flow | Bonus by default | Existing suite exists or automation is practical | fresh run output |

Notes:
- `requesting-code-review` is the default review workflow. If the current environment cannot run subagents, say so explicitly and treat review as a **missing Hard Gate** unless the user overrides it.
- For testcase docs, use project convention first. If the project uses an Ulives-style release checklist, use `test-case-summary-ulives`.
- `Mobile MCP` is **not** a universal blocker. Only mark it applicable for real client validation scenarios.

## Readiness Profiles

Use these profiles to decide applicability faster. They do **not** override stricter project rules.

| Change Type | Default Hard Gates | Common Conditionals | Usually N/A |
|---|---|---|---|
| Docs-only / copy-only | review, disposition | testcase doc status | tests, Mobile MCP |
| Backend / CLI / automation | review, disposition | tests, new tests, testcase doc | Mobile MCP |
| Web UI / frontend flow | review, disposition | tests, testcase doc, UI automation | Mobile MCP |
| Mobile client logic | review, disposition | tests, new tests, mobile diff review | — |
| Mobile client user flow | review, disposition | tests, testcase doc, mobile diff review, Mobile MCP | — |

Profile rules:
- `review` means `requesting-code-review`
- `disposition` means every meaningful review finding is marked `fixed`, `deferred`, or `rejected with reason`
- If a profile says a check is common, still mark it `No` / `N/A` explicitly when not practical

## Required User-Facing Output

Before any completion claim, ready-to-commit statement, or merge recommendation, output these two sections in the user's language:

```markdown
## [Localized Readiness Scorecard Title]

| [Localized Check] | [Localized Level] | [Localized Applies] | [Localized Status] | [Localized Evidence] | [Localized Gap] |
|---|---|---|---|---|---|
| Code review | Hard | Yes | ✅ | review done | None |
| Review fixes | Hard | Yes | ⚠️ | 1 deferred | 1 item |
| Tests | Conditional | Yes | ✅ | 38/38 | None |
| Testcase doc | Conditional | No | N/A | — | Not needed |
| Mobile MCP | Conditional | Yes | ⏳ | not run | simulator check |
| UI automation | Bonus | No | N/A | — | Not needed |

## [Localized Readiness Summary Title]

- [Localized Robustness Score]: 78/100
- [Localized Hard Gates]: 1/2 passed
- [Localized Conditional Checks]: 1/2 passed
- [Localized Bonus Checks]: 0/1 passed
- [Localized Ready to Commit / Merge]: No
- [Localized Key Gaps]:
  - Mobile MCP acceptance not run
  - 1 review item deferred
- [Localized Override Phrase]: "I accept the risk of skipping Mobile MCP and the deferred review item; continue to commit"
```

Rules:
- **Keep table cells short.** Use the table for terse state only. Put long explanations, rationale, and risk detail in summary bullets below the table.
- `Applies` should be one of: `Yes`, `No`, `N/A`
- `Status` should be short: `✅ Pass`, `❌ Fail`, `⏳ Not Run`, `⚠️ Override`, `N/A`
- If a check is not applicable, say so explicitly instead of silently omitting it
- If any applicable Hard Gate is `❌ Fail` or `⏳ Not Run`, then `Ready to commit / merge` must be `No`
- A user override may change the final recommendation, but only after the explicit override protocol below
- Score is advisory; missing applicable Hard Gates still default to **Not Ready**

## Scoring Standard

Use this default weighting unless the project defines its own:

| Level | Weight |
|---|---|
| Hard Gate | 5 |
| Conditional | 3 |
| Bonus | 1 |

Scoring rules:
- `Pass` = full weight
- `Fail`, `Not Run`, `Override` = 0
- `N/A` rows are excluded from the denominator
- `Robustness Score = earned_weight / applicable_weight * 100`, rounded to the nearest integer
- Missing applicable Hard Gates still mean **Not Ready**, even if the score looks decent

Suggested bands:
- `90-100` Strong
- `75-89` Good with minor gaps
- `60-74` Risky, user should review gaps carefully
- `<60` Not ready

## Explicit Override Protocol

Hard Gates are default blockers, but the user may override them.

**Valid override requirements:**
- The user must explicitly accept the risk
- The user must clearly say they still want to commit / PR / merge
- The override must mention the missing Hard Gate(s), either individually or as an explicit list

**Valid examples:**
- `我接受未做子代理 review 的风险，继续提交`
- `I accept the risk of skipping code review and deferred fixes; continue with the PR`

**Invalid examples:**
- `直接提吧`
- `ship it`
- `应该没问题`

After a valid override:
1. Echo back the overridden checks
2. Echo back the accepted risks
3. Mark those rows as `⚠️ Override`
4. Then proceed only with the action the user approved

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Fresh test output: 0 failures | Previous run, "should pass" |
| Bug fixed | Repro or regression evidence | Code changed, assumed fixed |
| Review complete | Reviewer output + disposition of findings | "I looked at the diff myself" |
| Mobile flow verified | Mobile MCP evidence or explicit N/A | "UI seems fine" |
| Testcase docs updated | Doc path + updated status | "Will update later" |
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
| Testcase doc | Conditional | No | N/A | — | Not needed |

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
