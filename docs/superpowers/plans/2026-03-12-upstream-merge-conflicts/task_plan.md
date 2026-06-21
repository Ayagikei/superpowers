# Task Plan: Resolve `upstream/main` merge conflicts

## Goal
Resolve the `upstream/main` merge conflicts in `superpowers/` while preserving fork-specific behavior, stage only the allowed files, and finish the merge commit cleanly.

## Current Phase
Phase 2

## Phases

### Phase 1: Requirements & Discovery
- [x] Confirm allowed edit scope and commit scope
- [x] Inspect merge state, conflict files, upstream branch, fork-only commits, and diff stats
- [x] Confirm planning file location under project docs
- **Status:** complete

### Phase 2: Conflict Resolution Strategy
- [ ] Decide resolution for each conflicted file
- [ ] Record fork-vs-upstream rationale
- [ ] Prepare scoped file edits
- **Status:** in_progress

### Phase 3: Apply Resolutions
- [ ] Edit the four allowed files only
- [ ] Re-check merge markers are gone
- [ ] Review scoped diff
- **Status:** pending

### Phase 4: Stage & Commit Merge
- [ ] Stage only required merge files
- [ ] Create merge commit without touching unrelated changes
- [ ] Verify merge completion and HEAD
- **Status:** pending

### Phase 5: Delivery
- [ ] Summarize each conflict resolution
- [ ] Report merge status, HEAD, and touched files
- **Status:** pending

## Key Questions
1. Which upstream changes can be adopted without overriding fork intent?
2. How do we keep the diff scoped when other agents are also editing this repo?

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| Store planning files in `docs/superpowers/plans/2026-03-12-upstream-merge-conflicts/` | Repo already uses `docs/superpowers/plans/` for plan artifacts |
| Limit edits to the four user-approved conflicted files | User explicitly constrained the writable scope |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| Initial multi-command shell quoting error | 1 | Re-ran discovery commands separately |
