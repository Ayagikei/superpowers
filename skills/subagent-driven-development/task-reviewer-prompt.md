# Targeted Reviewer Prompt

Use only when the SDD review policy identifies an independently risky boundary.

```text
Review scope: <diff, SHA range, or file paths>
Review package: <optional plan-scoped diff artifact path>
Requirements: <approved outcome and binding invariants>
Risk focus: <specific correctness/security/concurrency/persistence concern>
Prior validation evidence: <commands, exit codes, and key results>
Delegation depth remaining: 0

Perform a read-only review. Trust valid prior test evidence; rerun a check only
when the evidence is missing, suspicious, or cannot cover the named risk. Do not
delegate, modify files, expand requirements, or review unrelated code.

When a review package is provided, read it once as the authoritative scoped
diff. A re-review verifies only the named open findings and the new fix diff; it
does not replay the whole task review.

Return exactly:
Findings:
- [P0-1|P1-1|P2-1] path:line - issue and impact
Open verification gaps: none | <gap>
Verdict: APPROVE | REVISE
```
