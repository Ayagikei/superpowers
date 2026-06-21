---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute approved tasks only, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** Tell your human partner that Superpowers works much better with access to subagents. The quality of its work will be significantly higher if run on a platform with subagent support (Claude Code, Codex CLI, Codex App, Copilot CLI, and Gemini CLI all qualify; see the per-platform tool refs in `../using-superpowers/references/`). If subagents are available, use superpowers:subagent-driven-development instead of this skill.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions, concerns, and explicit scope boundaries in the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create todos for the plan items and proceed

### Step 2: Execute Tasks

For each task:
1. Run a scope gate:
   - **Directly allowed:** the smallest set of changes explicitly required by the plan, the minimum supporting changes required to unblock the task, and fixes for regressions introduced by the task
   - **Not directly allowed:** opportunistic refactors, cleanup, performance tuning, API redesign, adjacent bug fixes that are not required for the current step, or reviewer-proposed requirement expansions
   - **Requirement expansion examples:** supporting additional scenarios, historical remediation/backfill/compensation, migrations, or broader behavior changes than the approved step described
2. If you discover a worthwhile but non-essential change, stop and ask your human partner before implementing it
3. Mark as in_progress
4. Follow each step exactly (plan has bite-sized steps)
5. Run verifications as specified
6. Mark as completed

### Step 2.5: If Scope Expands

Only after explicit approval from your human partner:
- Update the written plan/progress to record the approved scope delta
- State what changed relative to the original plan
- State which files/modules are now in scope
- Expand testcases / verification scope to match the newly approved work
- Report the approved scope expansion back to your human partner when summarizing progress/completion
- Then implement the additional change

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly
- You find an unrelated or optional improvement that is not required for the current plan step
- A reviewer or your own investigation suggests a broader requirement than the plan approved, even if it is related to the same defect family

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
- Do not treat reviewer suggestions or personal optimization ideas as approved scope
- If extra work is approved, record the delta and verification impact before coding
- Do not silently convert a narrow bugfix into a wider requirement, migration, or backfill

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - Optional; use only when the user explicitly wants isolation or the current repo has many unrelated changes and the user agrees
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:finishing-a-development-branch** - Complete development after all tasks
