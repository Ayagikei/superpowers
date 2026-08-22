---
name: verification-before-completion
description: Use when preparing to claim that implementation is complete, fixed, passing, or ready for commit, review, merge, or delivery
---

# Verification Before Completion

Make one evidence-backed readiness decision at the delivery boundary. Validation
must match the changed behavior and remain current after the final code change.
Current means the last relevant result still covers the present sources. It does
not mean cache-busting, cleaning, or replaying the same command.

## Evidence reuse

Accept targeted evidence when it includes the exact command, exit code, key
output, affected scope, and no later change invalidated it. Incremental or
cached toolchain results count: Gradle `UP-TO-DATE` / `FROM-CACHE`, equivalent
hits in other build systems, and a worker's cited command/result.

Do not rerun the same command solely because another agent ran it, a parent is
closing the task, or a cache hit appeared.

Do not add `--rerun-tasks`, `--no-build-cache`, `clean`, cache wipes, or
equivalent force-rebuild flags as a default gate.

Rerun only when evidence is missing or suspicious, affected code changed
afterward, parallel work overlapped the scope, the command did not cover
integration, or a high-risk invariant still has no current result.

## Final verification

Before the readiness claim or an authorized commit:

1. Inspect repository status and the complete in-scope diff.
2. Confirm acceptance criteria and required artifacts are present.
3. Confirm one current, most-relevant verification for the integrated change.
   Reuse a still-valid worker or earlier result. Run a command only if that
   result is missing or stale.
4. For heavy changes, include the risk-specific check that proves the critical
   invariant. A full suite is required only when project policy or change impact
   makes it the smallest credible proof.
5. Record command, exit code, result, and any unverified boundary.

If validation cannot run, state why and report the best available substitute.
Do not convert partial evidence into a passing claim.

## Review applicability

- **Trivial:** independent review optional.
- **Standard:** conditional final review when risk, uncertainty, user impact, or
  weak validation justifies it.
- **Heavy:** independent final review is the default gate.

Review is not another test runner. Reuse its findings and prior validation
evidence. Re-review only open blocking findings after fixes.

## Claim contract

A completion report states:

```text
Outcome: <what is complete>
Validation: <command> -> <exit code and key result>
Review: pass | not applicable with reason | open findings
Unverified boundaries: none | <details>
```

Do not say fixed, complete, passing, ready, or equivalent before current evidence
supports that exact claim.
