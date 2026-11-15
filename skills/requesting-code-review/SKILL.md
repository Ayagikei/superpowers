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

Every review includes a separate over-defense pass, not only a search for
missing protection: the reviewer walks each path that throws, refuses, retries,
or blocks and reports limits on the user's own data, home-made heuristics that
guess data is changing or abnormal and then refuse, duplicate validation or
hashing, heavy work on startup or the main thread, optional protection that
blocks the main flow, and unrequested pages or modes. Rate these P1 when they
can fail a normal user flow, block startup, or cause an ANR. A finding that
asks for a new check, limit, or fallback must name a concrete trigger path and
prefer fixing the root cause when that is possible.

The reviewer is read-only and always a leaf. If a distinct security, platform,
or persistence specialist is needed, the controller dispatches it separately
within the overall depth budget. The reviewer does not modify code, expand
scope, or rerun valid tests merely to duplicate evidence.

## Output contract

```text
Findings:
- [P0-1|P1-1|P2-1] path:line - issue, impact, and concise correction
Over-defense:
- [P1-2|P2-2] path:line - what it rejects or slows, what it claims to prevent, simplification
- Checked with no finding: <categories>
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
