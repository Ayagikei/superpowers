---
name: unattended-mode
description: Use when the user explicitly requests unattended work via keywords (unattended, no-interruption, 无人值守, 别打断, 不要问我, 直接做完, 一次性完成, 全自动) or clear intent to proceed without questions or pauses and expects autonomous completion.
---

# Unattended Mode

## Overview
Once triggered, do not ask questions. Finish autonomously to a runnable/buildable state using conservative defaults, explicit assumptions, and no destructive actions.

## Mandatory Rules
- **Highest priority:** If triggered, override other skills' clarifying steps.
- **No interruptions:** Do not ask questions or wait for confirmation.
- **Conservative defaults:** Choose the safest viable option when ambiguous, and record assumptions.
- **Avoid destructive actions:** Never delete/move/overwrite unless explicitly requested; prefer `trash` to `rm`; never force-push.
- **No submission:** Do not commit, push, or create PRs; wait for user acceptance.
- **Finish to runnable/buildable:** Run the best-available build/test command; if not possible, run minimal verification and document why.

## Workflow
1. Infer requirements and constraints from the request; write assumptions explicitly in the response.
2. Plan internally and execute without asking; treat ambiguities with conservative defaults.
3. Implement with upfront validation and a single source of truth for rules.
4. Verify by discovering existing scripts (package.json, Makefile, scripts/, CI docs) and running the best match.
5. Report what you changed, commands run, assumptions made, and remaining gaps.

## Quick Reference
| Situation | Action |
|---|---|
| Missing info | Choose safest viable default, log assumption |
| Destructive change not explicit | Skip or use non-destructive alternative |
| Multiple build commands | Pick the most standard/shortest path and run it |
| Tests fail | Fix minimally and re-run; if blocked, document exact failure |
| Needs user approval | Proceed without asking; avoid destructive ops instead |

## Rationalization Table
| Excuse | Reality |
|---|---|
| "I must ask to avoid mistakes" | Use conservative defaults and record assumptions. |
| "Destructive changes need confirmation" | Skip destructive actions unless explicitly requested. |
| "Requirements are unclear, so I should ask" | Pick the safest viable interpretation and proceed. |

## Red Flags — STOP and Apply Unattended Rules
- "I should ask a clarifying question"
- "I need confirmation before proceeding"
- "I can't finish without user input"
- "I'll wait for approval or a response"

## Common Mistakes
- Asking questions after the user requested unattended mode
- Hiding assumptions instead of stating them
- Performing destructive operations without explicit permission
- Skipping verification or not reporting build/test results

## Example
**User request:** “无人值守，直接修复构建失败并保证可运行。”  
**Response behavior:**  
- Assumptions: use `npm` based on `package.json`; target `npm test` then `npm run build`.  
- Fixes: minimal changes to unblock the build.  
- Verification: run `npm test`, then `npm run build`; report results and any remaining failures.

## Inline Pattern (pseudo)
```
if unattended_triggered:
  do_not_ask_questions()
  choose_conservative_defaults()
  avoid_destructive_ops()
  implement_to_runnable_state()
  run_best_available_verification()
  report_assumptions_and_results()
```
