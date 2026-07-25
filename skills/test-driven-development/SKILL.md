---
name: test-driven-development
description: Use when logic or behavior can be protected by automated tests, especially Repository, Service, domain, data-access, or regression-prone code
---

# Test-Driven Development

Tests protect behavior. Choose the test workflow from the purpose of the change;
do not manufacture a RED state that proves nothing.

## Choose the mode

| Scenario | Required evidence |
|---|---|
| Existing bug or wrong behavior on a runnable seam | **Regression TDD:** run a targeted test and observe the expected behavioral RED, then implement and verify GREEN |
| New Repository/Service/domain/data logic | **Contract GREEN:** define required cases, add the test class and implementation, then verify GREEN; a pre-implementation RED is optional when it would be meaningful |
| Behavior change on an existing runnable logic seam | Prefer a real assertion RED when it directly expresses the changed rule; otherwise document why Contract GREEN is the clearer proof |
| Behavior-preserving refactor | Keep existing characterization/regression tests GREEN; add missing coverage where it protects the refactor |
| UI-only change | Automated UI testing is optional and follows the feasibility/stop rule below |
| Compile, import, wiring, test-harness, or build fix | Reproducing that exact infrastructure failure is a valid RED |
| Evaluation, investigation, design, or plan | No RED or implementation test is required |

Repository, Service, use-case, reducer, validator, persistence, mapping, and
business-rule layers are the primary TDD targets because their behavior is
deterministic and inexpensive to exercise.

## Regression TDD

Use this for an existing defect or an existing runnable behavior whose rule is
changing.

1. Write the smallest test that expresses the expected behavior.
2. Run it before the fix.
3. Confirm it executes and fails for the reported behavioral reason.
4. Implement the smallest correct fix.
5. Run the targeted test and relevant nearby tests to GREEN.
6. Refactor only while the tests stay GREEN.

An assertion mismatch, wrong value/state, missing exception, or unexpected
exception can be a real behavioral RED. A missing symbol, compile error, broken
fixture, import failure, crashed runner, or unconfigured test target is not a
behavioral RED.

If implementation already exists, do not delete or destructively revert work to
perform ceremony. When practical, prove the regression test against the pre-fix
baseline in an isolated/reversible way. Otherwise report that the test is
tests-after and do not claim that a behavioral RED was observed.

## Contract GREEN for new logic

For genuinely new logic, the useful evidence is a durable executable contract,
not a forced failure caused by code that does not exist yet.

1. Define success, boundary, and error cases.
2. Add the test class and implementation in the order that makes the seam
   runnable with the least noise.
3. Verify the focused tests reach GREEN.
4. Check that tests assert observable behavior rather than merely construction,
   mocks, or implementation details.
5. Run relevant neighboring tests when shared behavior may be affected.

Missing-symbol or not-yet-wired failures may occur during construction, but do
not label them RED. A meaningful assertion RED is welcome when a runnable seam
already exists; it is not mandatory for new logic.

## UI feasibility and stop rule

Before adding a UI test, inspect the project for an established unit, snapshot,
component, instrumentation, simulator/emulator, or accessibility-driven test
path. Prefer deterministic state and stable selectors.

Attempt automated UI coverage when the existing harness can exercise the
behavior without disproportionate setup. Stop and downgrade when any applies:

- no maintained UI test target/framework exists;
- testing requires unapproved dependency, root configuration, CI, signing, or
  environment changes;
- two distinct, reasonable setup/runner attempts fail for harness reasons rather
  than product behavior;
- the test is inherently flaky or cannot assert the intended state reliably.

Downgrade in this order:

1. extract and unit-test ViewModel/presenter/reducer/state/business logic;
2. use an existing snapshot/component test path when stable;
3. build/typecheck plus preview/render/simulator smoke validation;
4. document a focused manual acceptance check and the automation gap.

Do not hide the downgrade: report what was attempted, why it stopped, and what
evidence replaced it.

## Test quality

- Assert user- or caller-observable behavior.
- Prefer real code; mock only external or nondeterministic boundaries.
- Cover success, boundary, and failure cases that matter to the contract.
- Keep tests deterministic, focused, and repeatable.
- Do not broaden production APIs solely to make a test convenient.

When writing or changing tests, mocks, fixtures, or test helpers, read
[writing-good-tests.md](writing-good-tests.md). Name the production change that
would make the test fail, assert real behavior, and keep test-only APIs out of
production code.

## Completion report

State which mode was used and provide the evidence:

```text
Mode: Regression TDD | Contract GREEN | Refactor GREEN | UI automated | UI downgraded | Infrastructure RED | Evaluation only
RED: <behavior failure observed> | not required | not observed with reason
GREEN: <command and result> | not applicable
Coverage boundary: <what is protected and what remains untested>
```
