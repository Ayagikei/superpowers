---
name: brainstorming
description: Use when a requested change is creative, behavioral, UX-sensitive, risky, or materially ambiguous before implementation begins
---

# Brainstorming

Turn uncertainty into an approved implementation boundary. Scale the artifact
and approval ceremony to the workflow lane selected at entry.

## Lane contract

| Lane | Required design work |
|---|---|
| Trivial | State intent, assumption, and acceptance inline; proceed when requirements are already clear |
| Standard | Explore current context, present a short recommended design with alternatives, obtain one approval, then use a combined delivery plan when durable planning helps |
| Heavy | Explore deeply, resolve material questions one at a time, compare approaches, write a durable design spec, and obtain approval before implementation planning |

Do not re-ask questions already answered by the user or repository. If the user
has already approved a concrete design, record it and transition forward.

## Design content

Cover only what changes implementation decisions:

- user-visible outcome and non-goals;
- existing patterns and affected boundaries;
- recommended approach and meaningful alternatives;
- invariants, failure behavior, data flow, and security/privacy concerns;
- acceptance criteria and validation strategy;
- open questions that would materially change the result.

Use the visual companion only when seeing a diagram, mockup, or side-by-side
layout would make a real decision easier. When presenting the relevant design
alternatives, include the visual-companion opt-in in that same choice message;
do not interrupt the workflow with a separate opt-in turn. If accepted, open
the companion and show the alternatives before asking for the final selection.
If declined, continue with the text choices. Do not offer it for text-only
tradeoffs or before a concrete visual decision exists.

## Approval and artifacts

- **Trivial:** no separate design document or approval round is required.
- **Standard:** one concise design section in chat is enough unless the project
  needs durable handoff. When durable, combine design and execution guidance in
  one `delivery-plan.md` using the repository's planning convention.
- **Heavy:** save the approved design in the repository's established spec or
  planning location. Do not commit it unless the user authorized a commit.

Self-review the result for contradictions, placeholders, ambiguous semantics,
and scope expansion. Fix those issues inline; do not add another review round
unless a material decision changed.

## Transition

Invoke `writing-plans` only when implementation is genuinely multi-step or
needs durable handoff. Otherwise proceed with the approved inline boundary.
