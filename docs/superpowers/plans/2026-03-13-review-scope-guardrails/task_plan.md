# Task Plan

## Goal
Update review/execution-related superpowers skills so agents do not expand scope beyond the approved plan, do not opportunistically "improve" unrelated logic without consent, and must explicitly report/record any approved scope additions.

## Extension (2026-03-14)
Harden the same skills against a second failure mode: reviewer-suggested legacy compensation/backfill/migration work being treated as a normal bugfix instead of a scope expansion that requires user approval.

## Scope
- In scope:
  - `/Users/kei/.agents/superpowers/skills/requesting-code-review/SKILL.md`
  - `/Users/kei/.agents/superpowers/skills/receiving-code-review/SKILL.md`
  - `/Users/kei/.agents/superpowers/skills/executing-plans/SKILL.md`
- Maybe in scope if clearly required for consistency:
  - Closely related templates or examples directly referenced by the three skills
- Out of scope:
  - Unrelated skill rewrites
  - Workflow changes not tied to scope control / consent / documentation requirements

## Phases
1. [completed] Create planning files and capture current constraints
2. [completed] Read target skills and gather baseline issues
3. [completed] Propose bounded design for updates and get user approval
4. [completed] Edit approved files only
5. [completed] Run scenario-based verification for new rules
6. [completed] Propose minimal hardening for legacy-compensation / backfill scope expansion
7. [completed] Edit approved files only for this extension
8. [completed] Re-run targeted verification

## Constraints
- Keep changes scoped to the user's requested skills
- Do not silently "improve" adjacent workflows
- If any new optimization/refactor idea is found, it must be framed as opt-in follow-up, not directly implemented
- Preserve existing valid review/execution workflow unless needed to enforce scope boundaries
- Treat backfill / migration / compensation / historical repair as scope-expanding by default unless the approved plan explicitly includes it

## Errors Encountered
- None yet
