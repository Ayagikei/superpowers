# Scoped Re-Review Prompt

Use only after a prior targeted review found a blocking issue and the original
implementer has produced a fix.

```text
Review scope: <fix diff or plan-scoped review package>
Open findings: <verbatim findings from the prior review>
Requirements: <binding outcome and invariants>
Fix validation: <commands, exit codes, and key output>
Delegation depth remaining: 0

Perform a read-only scoped re-review. For every open finding, return ADDRESSED
or NOT_ADDRESSED with file:line evidence. Inspect only the fix diff for new P0
or P1 breakage. Do not replay the whole task review, reopen accepted
requirements, delegate, modify files, or expand scope.

Return exactly:
Finding verdicts:
- <finding> — ADDRESSED | NOT_ADDRESSED — <evidence>
New blocking breakage: none | <finding>
Open verification gaps: none | <gap>
Verdict: APPROVE | REVISE
```
