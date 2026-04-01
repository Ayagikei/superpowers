---
name: writing-plans
description: Use when a multi-step task needs a detailed implementation plan document before any code changes
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD when it applies. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**REQUIRED SUB-SKILL:** Use planning-with-files to locate the project’s docs/planning directory and create `task_plan.md`, `findings.md`, and `progress.md`.

**Workspace:** Default to the current repo workspace. Use `superpowers:using-git-worktrees` only if the current directory has many unrelated changes or the user explicitly requests isolation.

**Save plans to:** Follow project conventions to locate the docs/planning directory (per planning-with-files), and use a feature-specific folder so all related docs live together.

**Co-locate feature docs:** The detailed plan, `task_plan.md`, `findings.md`, and `progress.md` should live in the same feature directory.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---

**Docs location (example):**

```
docs/plans/YYYY-MM-DD-<feature-name>/
  implementation-plan.md
  task_plan.md
  findings.md
  progress.md
```
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test (if TDD applies)**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails (if TDD applies)**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes (if TDD applies)**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- Reference relevant skills by name (no @ links)
- DRY, YAGNI, TDD when it applies, frequent commits
- If unsure whether TDD applies, follow the scope gate in superpowers:test-driven-development

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Plan Review Gate

After the self-review:

1. Classify the work:
   - **Lightweight:** a narrowly scoped tweak, small UI/content adjustment, or similarly bounded work where the plan is short and the expected implementation diff is modest
   - **Heavy:** a new feature, broad refactor, multi-file coordination, architecture-sensitive work, or anything where an independent reviewer materially reduces planning risk
2. If **Heavy**, independent plan review is the default:
   - Dispatch a single plan-document-reviewer subagent (see plan-document-reviewer-prompt.md) with precisely crafted review context — never your session history
   - Provide: path to the plan document, path to spec document
   - If the harness requires explicit authorization before spawning subagents, ask for that authorization instead of silently skipping the reviewer
   - If the user declines that reviewer authorization, stop and ask whether they want to proceed with the independent reviewer gate explicitly skipped for this heavy task
   - If ❌ Issues Found: fix the issues, re-dispatch reviewer for the whole plan
   - If ✅ Approved: proceed to execution handoff
3. If **Lightweight**, ask the user whether to run the reviewer subagent or keep the planning flow lean:
   - If user wants review, dispatch the reviewer subagent
   - If user declines, do one careful local review yourself and explicitly note that the independent reviewer gate was skipped by user choice before handoff
4. Never present a local self-review as equivalent to an independent reviewer pass

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `<docs-dir>/<feature>/implementation-plan.md`. Three execution options:**

**1. 当前会话继续执行 (Recommended)** - Manual execution in this session

**2. 子代理驱动（本会话内逐任务执行）** - Subagent-Driven (this session): I dispatch fresh subagent per task, review between tasks, fast iteration

**3. 并行会话（另开执行 plans）** - Parallel Session (separate): Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Current Session chosen:**
- Stay in this session
- Execute tasks manually (no subagents)

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- If worktree criteria apply, create one with `superpowers:using-git-worktrees`; otherwise stay in current workspace
- **REQUIRED SUB-SKILL:** New session uses superpowers:executing-plans
