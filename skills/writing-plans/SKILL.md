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

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

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

```markdown
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

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes (if TDD applies)**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
```

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills by name (no @ links)
- DRY, YAGNI, TDD when it applies, frequent commits
- If unsure whether TDD applies, follow the scope gate in superpowers:test-driven-development

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
