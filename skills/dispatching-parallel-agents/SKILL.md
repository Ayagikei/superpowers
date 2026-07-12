---
name: dispatching-parallel-agents
description: Use when multiple workstreams are demonstrably independent, share no writable state, and parallel execution materially reduces wall-clock time
---

# Dispatching Parallel Agents

Parallelize independent work, not uncertainty. First group related failures or
tasks by likely shared cause; dispatch only groups that can complete without one
another's results.

## Gate

All must be true:

- at least two distinct outcomes can be described now;
- no shared files, mutable services, simulator/device, generated artifacts, or
  sequential design decision;
- each worker has a bounded scope and validation command;
- integration cost is lower than the expected time saved.

If root causes may overlap, use one explorer first. If edits may overlap, keep
implementation sequential and parallelize only read-only investigation.

## Depth and briefs

Default delegation depth is 1; maximum is 2. Give each worker its remaining
depth budget. A worker may use one read-only specialist only for a distinct
question; it may not create another coordinator or delegate its main outcome.

Each brief contains outcome, scope, constraints, acceptance, validation, and
the structured report expected. Workers do not load orchestration skills.

## Integration

When results return:

1. inspect actual diffs and scope, not summaries alone;
2. reject or resolve overlapping edits before continuing;
3. reuse complete worker validation evidence;
4. run one fresh final verification on the integrated result;
5. use risk-based final review rather than one reviewer per worker.

In Codex, track agent IDs and use the native wait/lifecycle tools. Do not replace
agent completion with shell sleeps or busy polling.
