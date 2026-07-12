---
name: requesting-code-review
description: Use when an independent review is requested or risk, uncertainty, or weak validation makes a separate readiness check valuable
---

# Requesting Code Review

Use independent review deliberately. The main agent owns scope, finding
disposition, actual fixes, final verification, and delivery.

## Review gate

| Lane | Independent review |
|---|---|
| Trivial | Optional; skip unless requested or the main agent is uncertain |
| Standard | Conditional; use at the final boundary when user impact, broad diff, weak validation, or meaningful uncertainty justifies it |
| Heavy | Default final gate; add a targeted specialist only for a distinct high-risk boundary |

Do not review after every implementation task by default. A per-deliverable
review is justified only when that boundary is independently risky and delaying
feedback would make later work unsafe.

## Review brief

Provide only:

- approved outcome and non-goals;
- diff, SHA range, or exact files;
- binding product/interface constraints;
- named risk focus;
- prior validation commands and results;
- delegation depth `0` because reviewers are leaves.

The reviewer is read-only and always a leaf. If a distinct security, platform,
or persistence specialist is needed, the controller dispatches it separately
within the overall depth budget. The reviewer does not modify code, expand
scope, or rerun valid tests merely to duplicate evidence.

## Output contract

```text
Findings:
- [P0-1|P1-1|P2-1] path:line - issue, impact, and concise correction
Verification gaps: none | <missing evidence>
Verdict: APPROVE | REVISE
```

No findings means approval; do not require praise, process narration, or a
second spec-compliance report that repeats the same evidence.

## Findings loop

The main agent classifies each finding as required now, optional follow-up,
requirement expansion, or rejected with evidence. Fix P0/P1 issues in scope.
Re-review only the original open blocking IDs plus the changed regression
boundary. Do not replay a clean whole-diff review, and do not turn P2 suggestions
into unauthorized work.

Use [code-reviewer.md](code-reviewer.md) as the compact dispatch template.
