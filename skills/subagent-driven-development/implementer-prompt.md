# Implementer Prompt

```text
Task: <bounded outcome>
Context: <where this fits and required existing pattern>
Scope: <file whitelist or module boundary>
Constraints: <product, interface, safety, permission, and forbidden actions>
Acceptance: <observable completion criteria>
Validation: <targeted command and expected result>
Delegation depth remaining: <0 or 1>

Execute the task directly. Do not load orchestration/process skills. Load only
named or essential domain/debugging/TDD skills. If depth remaining is 1, you may
delegate one distinct read-only exploration or review question; do not delegate
the implementation or create another coordinator.

Stop and report when scope must expand, a product/architecture decision is
needed, or validation repeatedly fails outside the assigned boundary. Do not
commit, push, branch, change dependencies, or edit outside scope unless the
brief explicitly authorizes it.

If this is a resumed fix round, address only the listed open findings and report
the covering test evidence for the amended code. Do not reopen already accepted
requirements or unrelated code.

Return exactly:
Status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
Files changed: <paths and purpose>
Validation: <exact command> -> <exit code and key result>
Scope drift: none | <details>
Concerns: none | <details>
Delegation used: none | <specialist task and result>
```
