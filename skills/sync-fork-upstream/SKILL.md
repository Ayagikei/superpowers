---
name: sync-fork-upstream
description: Use when syncing a fork with upstream and the fork has local customizations, conflicts are likely, or the user expects fork changes to be preserved while absorbing upstream improvements.
---

# Sync Fork with Upstream (Prefer Fork Changes)

## Overview
Merge upstream into the fork with fork-first conflict resolution, while explicitly comparing fork-only commits and diff stats before changing history.

## Core Rules
- **Default strategy: merge** (avoid history rewrite unless user explicitly requests rebase).
- **Prefer fork changes** when conflicts arise; absorb upstream improvements only when they do not override fork intent.
- **Evidence before merge:** collect fork-only commit log and diff stats vs upstream to understand divergence.
- **No force push** unless user explicitly approves.

## Required Pre-Checks
1. `git status -sb` and `git diff` (ensure clean working tree).
2. Identify upstream default branch (`upstream/HEAD` → `upstream/main` or `upstream/master`).
3. **Collect comparison evidence:**
   - Fork-only commits: `git log --oneline upstream/main..HEAD`
   - Diff stats: `git diff --stat upstream/main...HEAD`

## Workflow (Merge-First)
1. `git fetch upstream`
2. Review fork-only commits and diff stats (required).
3. `git merge upstream/main`
4. Resolve conflicts preferring fork changes:
   - Keep fork behavior unless upstream fix is critical and non-breaking.
   - Document any upstream adoption that alters fork behavior.
5. Verify status and log summary.
6. Push to fork remote (no force).

## Quick Reference
| Situation | Action |
|---|---|
| User asks to rebase | Require explicit approval + explain history rewrite |
| Conflict ambiguity | Prefer fork; document why if choosing upstream |
| Upstream critical fix | Adopt only if compatible with fork intent |
| Unsure about divergence | Re-check fork-only log and diff stats |

## Rationalization Table
| Excuse | Reality |
|---|---|
| "Rebase is cleaner, just do it" | Default is merge to avoid rewriting history. |
| "Upstream probably right" | Fork intent is primary unless fix is critical and safe. |
| "Diff stats are optional" | Evidence is required to understand divergence. |

## Red Flags
- Skipping fork-only commit log
- Skipping diff stats vs upstream
- Choosing upstream by default in conflicts
- Force-pushing without explicit approval

## Common Mistakes
- Merging without confirming upstream default branch
- Resolving conflicts without documenting behavior changes
- Performing rebase without user permission

## Example
**Scenario:** Fork has custom workflow; upstream refactors scripts.  
**Action:** Review fork-only commits and diff stats, merge upstream, keep fork scripts where behavior differs, adopt upstream refactor only when it doesn't override fork intent, document the choice.
