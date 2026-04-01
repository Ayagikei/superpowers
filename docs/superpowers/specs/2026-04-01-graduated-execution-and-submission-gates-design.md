# Graduated Execution and Submission Gates

## Overview

Adjust superpowers from a mostly uniform process into a complexity-based process with three lanes:

1. **Trivial** — very small, low-risk changes
2. **Standard** — bounded but non-trivial work
3. **Heavy** — complex, cross-cutting, or architecture-sensitive work

The goal is to reduce friction for simple work without losing explicit risk visibility for larger work.

## Goals

- Let very simple UI / copy / narrow polish tasks skip full heavyweight ceremony
- Keep moderate tasks on a lightweight but explicit plan + review path
- Preserve full spec / plan / independent review gates for high-risk work
- Relax submission overrides so users do not need rigid magic phrases; explicit authorization language should be enough
- Keep readiness reporting visible even when gates are skipped by authorization

## Non-Goals

- Removing readiness scorecards entirely
- Removing review as a concept for all task types
- Replacing fork-first merge with rebase-first history rewriting
- Hiding skipped gates or treating local review as equivalent to independent review

## Complexity Model

### Trivial

Use for:
- copy tweaks
- narrow visual polish
- single-screen layout nudge
- one-file or two tightly related narrow files
- changes with no meaningful business-rule, state, or architecture impact

Process:
- brainstorming may produce a very short design acknowledgement instead of a full spec workflow
- after design acknowledgement, the task may either:
  - go directly to implementation, or
  - go through a mini plan path (2-5 bullets)
- planning-with-files artifacts are not required by default for the direct trivial path
- reviewer subagent is optional and off by default
- verification uses a lightweight readiness panel
- if an applicable gate is skipped, explicit user authorization to continue / commit is sufficient

### Standard

Use for:
- bounded feature adjustments
- small multi-file changes
- low-risk behavior changes with a small bounded rule or flow impact
- work that benefits from written steps but does not justify full ceremony

Process:
- require a lightweight plan
- require lightweight planning artifacts
- allow lightweight review by default
- reviewer subagent remains optional unless the user wants it or risk rises during execution
- verification uses a short but explicit readiness scorecard
- explicit user authorization can override a missing gate

### Heavy

Use for:
- new features
- broad refactors
- cross-module coordination
- state / data-flow changes
- architecture-sensitive work
- large or high-risk diffs

Process:
- keep full brainstorming -> spec -> writing-plans -> implementation flow
- default to independent spec review / plan review / code review
- if the harness requires explicit authorization for subagents, ask for that authorization instead of silently skipping review
- if the user authorizes skipping a gate, record it explicitly in readiness output

## Single Escalation Rule

If a task shows **any signal from a higher lane**, classify it into that higher lane.

In practice:
- start from `Trivial`
- if any `Standard` signal appears, upgrade to `Standard`
- if any `Heavy` signal appears, upgrade to `Heavy`

This rule is intentionally conservative. Borderline tasks should move up, not down.

## Boundary Examples

| Example | Lane | Why |
|---|---|---|
| Change one button label in one screen | Trivial | copy-only, no flow or rule impact |
| Adjust spacing and font size in one settings page file | Trivial | narrow visual polish only |
| Update two tightly related UI files for one small layout fix | Trivial | still narrow, no behavior/rule change |
| Add one small validation hint in an existing form flow | Standard | bounded behavior change, user flow impact |
| Modify one API handler and one test for a small rule tweak | Standard | small business-rule impact |
| Touch four files across one feature to adjust state handling | Standard | multi-file coordination but bounded |
| Introduce a new workflow, new state model, or cross-module data flow | Heavy | architecture/state impact |
| Refactor a shared skill contract used by multiple workflows | Heavy | broad coordination risk |
| Any task that starts small but grows in files, risk, or rules | Higher lane | escalation rule applies |

## Skill-Level Changes

### `skills/brainstorming/SKILL.md`

Change from a binary lightweight/heavy gate to a three-lane gate:

- **Trivial:** allow a short design summary and immediate transition to implementation or a mini plan
- **Standard:** require a short written design / plan handoff, but avoid mandatory spec-review subagent
- **Heavy:** preserve full written spec and independent spec review gate

The skill should still avoid implementation before design acknowledgement, but it should scale ceremony to complexity.

Trivial path must be explicit:
- `design acknowledgement -> implement`
- `design acknowledgement -> mini plan -> implement`

It must not force trivial work into the full spec-review path.

### `skills/writing-plans/SKILL.md`

Add matching plan modes:

- **Trivial:** mini plan allowed; may skip full implementation-plan document
- **Standard:** lightweight implementation plan required
- **Heavy:** full implementation plan with review loop

The skill should make clear that the plan artifact size depends on complexity, not a single default workflow for every task.

More specifically:
- **Trivial direct path:** no full implementation-plan document and no required planning-with-files artifacts
- **Trivial mini-plan path:** a short plan artifact is allowed but should stay lightweight
- **Standard:** planning-with-files remains required, but the plan can be short and tactical
- **Heavy:** full implementation plan and normal review loop

### `skills/requesting-code-review/SKILL.md`

Keep reviewer leaf-node constraints, but align invocation expectations with the new tiering:

- Trivial work does not default to independent review
- Standard work allows local review or optional reviewer subagent
- Heavy work still defaults to independent reviewer

This preserves review quality rules without forcing the same review ceremony everywhere.

### `skills/verification-before-completion/SKILL.md`

Relax override parsing:

- valid override no longer requires a rigid quoted phrase
- any explicit user authorization that authorizes continuing with commit / merge should count
- examples should include natural Chinese variants such as:
  - “我授权你继续提交”
  - “我授权跳过这个 review，继续 commit”
  - “授权继续提交”
  - “授权，继续”

The readiness panel remains mandatory before commit / merge recommendations, but the override protocol becomes intent-based rather than phrase-based.

Also align readiness expectations with the three-lane model:

- trivial: lightweight readiness
- standard: short readiness scorecard
- heavy: full readiness scorecard

The override protocol should be relaxed in two specific ways:
- the user does **not** need a magic phrase
- the user does **not** need to enumerate every missing gate individually, as long as the authorization clearly refers to continuing / committing despite the shown gaps

## Classification Heuristics

The classification must be conservative but practical:

| Signal | Trivial | Standard | Heavy |
|---|---|---|---|
| Files touched | 1-2 narrow files | small bounded set | broad / cross-cutting |
| UI scope | one narrow polish | one bounded flow | many flows / UX model changes |
| Business logic | none / negligible | small bounded rule or flow change | new or changed core rules |
| Architecture risk | none | low | medium-high |
| Expected diff | very small | modest | large |
| Independent review value | low | situational | high |

Escalation rule:
- If a task starts as trivial or standard but grows in scope or risk, upgrade the lane in-flight.

Tie-breaker:
- if a task could plausibly fit two lanes, choose the higher lane

## Lane × Gate Matrix

| Gate | Trivial | Standard | Heavy |
|---|---|---|---|
| Design acknowledgement | Required | Required | Required |
| Full written spec | Skipped by default | Optional short design note | Required |
| Spec review subagent | Off by default | Optional | Required by default |
| Lightweight / full plan | Direct implement or mini plan | Lightweight plan required | Full plan required |
| planning-with-files artifacts | Not required by default | Required | Required |
| Plan review subagent | Off by default | Optional | Required by default |
| Independent code review | Optional by default | Conditional / lightweight by default | Hard Gate by default |
| Readiness panel | Lightweight | Short scorecard | Full scorecard |
| User authorization override | Allowed | Allowed | Allowed, but must be echoed clearly |

Interpretation:
- `Trivial` aims for minimal ceremony
- `Standard` keeps explicit planning and visible verification, but not full ceremony by default
- `Heavy` keeps the strongest default gates

## Readiness / Submission Model

### Trivial
- keep a very short scorecard
- if review is skipped, show it plainly
- accept explicit user authorization as override
- independent code review is optional by default, not a Hard Gate

### Standard
- keep a concise scorecard
- independent code review is conditional by default
- mark skipped independent review as optional or overridden, depending on applicability
- accept explicit user authorization as override

### Heavy
- require full scorecard
- missing hard gates remain blockers by default
- explicit authorization can still override, but the skipped gates and accepted risks must be echoed back

## Files Expected To Change

### `superpowers`
- `docs/superpowers/specs/2026-04-01-graduated-execution-and-submission-gates-design.md`
- `skills/brainstorming/SKILL.md`
- `skills/writing-plans/SKILL.md`
- `skills/requesting-code-review/SKILL.md`
- `skills/requesting-code-review/code-reviewer.md` (only if wording alignment is needed)
- `skills/subagent-driven-development/SKILL.md`
- `skills/subagent-driven-development/code-quality-reviewer-prompt.md` (if dispatch wording needs tier alignment)
- `skills/subagent-driven-development/spec-reviewer-prompt.md` (if dispatch wording needs tier alignment)
- `skills/verification-before-completion/SKILL.md`

### parent repo
- submodule pointer for `superpowers`
- submodule pointer for `skills/planning-with-files`

## Risks

- If “trivial” is defined too loosely, meaningful changes may skip needed review
- If override parsing is too loose, ambiguous user language may be misread as authorization
- Upstream merges may touch the same workflow files, requiring careful conflict resolution to preserve fork intent

## Mitigations

- Keep trivial classification narrow and conservative
- Require explicit authorization words such as “授权 / allow / approve / continue to commit” rather than vague urgency
- Preserve visible readiness output even when gates are skipped

## Success Criteria

- Very simple tasks can complete with minimal ceremony
- Moderate tasks get a lightweight but explicit plan / review path
- Complex tasks still benefit from full spec and review loops
- Users can authorize skipping gates without memorizing rigid phrases

## Appendix: Fork-First Sync Strategy For This Maintenance Round

This appendix is implementation context for the current fork maintenance task, not part of the long-term lane model itself.

For the current maintenance work on `superpowers` and `planning-with-files`:

1. Ensure each target submodule working tree is clean enough for merge
2. Fetch `upstream`
3. Inspect:
   - upstream default branch
   - fork-only commits
   - diff stats
4. Merge `upstream/<default-branch>`
5. On conflicts, preserve fork-specific workflow / policy choices unless upstream change is clearly compatible and superior
6. Verify and update parent repo submodule pointer
