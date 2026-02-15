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
- **Prevent token burn on blockers:** Timebox any blocked task (for example 20-30 minutes or 2 focused attempts), then move to other independent tasks.
- **Preserve throughput:** If Task A is blocked and Task B/C have no dependency on A, continue B/C first and return to A later.
- **Escalate search paths before declaring blocked:** Try local reasoning, then skill discovery (`find-skills`), then web search for latest docs/known issues, then a focused subagent.
- **Record unresolved blockers:** If still blocked after escalation, capture what was tried, evidence, and explicit unblock conditions for the user.

## Workflow
1. Infer requirements and constraints from the request; write assumptions explicitly in the response.
2. Build a lightweight dependency map for tasks (`blocked-by` vs `independent`) and pick highest-value executable work first.
3. Execute without asking; when a task blocks, apply a timebox and then switch to other independent tasks instead of grinding indefinitely.
4. Escalate blocked tasks in order: local attempts -> `find-skills` -> web search -> focused subagent; stop escalation when marginal progress stalls.
5. Implement with upfront validation and a single source of truth for rules.
6. Verify by discovering existing scripts (package.json, Makefile, scripts/, CI docs) and running the best match.
7. Report what changed, commands run, assumptions, completed items, deferred blocked items, and exact unblock asks (if any).

## Quick Reference
| Situation | Action |
|---|---|
| Missing info | Choose safest viable default, log assumption |
| Destructive change not explicit | Skip or use non-destructive alternative |
| Multiple build commands | Pick the most standard/shortest path and run it |
| First task is blocked, later tasks are independent | Timebox current task, park blocker, execute later independent tasks |
| Need more solution space for blocker | Try `find-skills`, latest web docs/issues, then focused subagent |
| Tests fail | Fix minimally and re-run; if blocked, document exact failure |
| Still blocked after escalation | Log blocker packet (attempts, evidence, next step, user input needed) and continue remaining work |
| Needs user approval | Proceed without asking; avoid destructive ops instead |

## Rationalization Table
| Excuse | Reality |
|---|---|
| "I must ask to avoid mistakes" | Use conservative defaults and record assumptions. |
| "Destructive changes need confirmation" | Skip destructive actions unless explicitly requested. |
| "Requirements are unclear, so I should ask" | Pick the safest viable interpretation and proceed. |
| "Task A started first, so I must finish it first" | For independent work, switch to unblocked tasks after a timebox. |
| "I should keep trying forever until A is solved" | Cap attempts, escalate smartly, then preserve overall throughput. |

## Red Flags — STOP and Apply Unattended Rules
- "I should ask a clarifying question"
- "I need confirmation before proceeding"
- "I can't finish without user input"
- "I'll wait for approval or a response"
- "I am stuck on one task and ignoring independent tasks"
- "I keep repeating the same failed approach without escalation"

## Common Mistakes
- Asking questions after the user requested unattended mode
- Hiding assumptions instead of stating them
- Performing destructive operations without explicit permission
- Skipping verification or not reporting build/test results
- Burning tokens on one blocked task while other independent tasks are available
- Reporting "blocked" without a concrete blocker log and unblock conditions

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
  map_task_dependencies()
  avoid_destructive_ops()
  for task in executable_tasks:
    try_with_timebox(task)
    if blocked(task):
      escalate_with(find_skills, web_search, focused_subagent)
      if still_blocked(task):
        record_blocker_packet(task)
        continue_independent_tasks()
  implement_to_runnable_state()
  run_best_available_verification()
  report_assumptions_results_and_blockers()
```
