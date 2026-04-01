# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

```
Task tool (superpowers:code-reviewer):
  Before using the template, prepend this fixed instruction block to the reviewer:

  "You are the direct code review subagent for this request and the leaf node of this review chain.
  Do NOT call, delegate to, or suggest any other subagent.
  Do NOT perform nested review.
  Do NOT discuss tool limitations or platform limitations.
  Base your conclusions only on the provided requirements, diff / SHA range, file scope, and the code you directly inspect.
  If context is incomplete, state what is missing briefly and still return the best review possible from the available evidence."

  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
```

**In addition to standard code quality concerns, the reviewer should check:**
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
