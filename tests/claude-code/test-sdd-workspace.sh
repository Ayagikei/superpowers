#!/usr/bin/env bash
# Tests for the SDD workspace: scripts/sdd-workspace resolves a self-ignoring,
# PER-PLAN working-tree directory for SDD artifacts, and the SDD scripts write
# into their plan's directory.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SDD_SCRIPTS="$REPO_ROOT/skills/subagent-driven-development/scripts"

FAILURES=0
TEST_ROOT=""

pass() { echo "  [PASS] $1"; }
fail() {
    echo "  [FAIL] $1"
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    if [[ -n "$TEST_ROOT" && -d "$TEST_ROOT" ]]; then
        rm -rf "$TEST_ROOT"
    fi
}

main() {
    echo "=== Test: sdd-workspace ==="

    TEST_ROOT="$(mktemp -d)"
    trap cleanup EXIT

    # Resolve repo to its physical path so string comparisons match the
    # helper's output (git rev-parse --show-toplevel resolves symlinks; on
    # macOS mktemp lives under /var -> /private/var).
    git init -q -b main "$TEST_ROOT/repo"
    local repo
    repo="$(cd "$TEST_ROOT/repo" && git rev-parse --show-toplevel)"

    cat > "$repo/plan-a.md" <<'PLAN'
# Plan A

## Task 1: First thing

Do the first thing.
PLAN
    cat > "$repo/plan-b.md" <<'PLAN'
# Plan B

## Task 1: Other thing

Do the other thing.
PLAN
    mkdir -p "$repo/a" "$repo/b"
    cp "$repo/plan-a.md" "$repo/a/shared.md"
    cp "$repo/plan-a.md" "$repo/b/shared.md"

    # --- argument validation ---
    local rc=0
    (cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" >/dev/null 2>&1) || rc=$?
    if [[ "$rc" -eq 2 ]]; then
        pass "sdd-workspace without a plan errors with exit 2"
    else
        fail "sdd-workspace without a plan errors with exit 2"
        echo "    exit: $rc"
    fi

    rc=0
    (cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" no-such-plan.md >/dev/null 2>&1) || rc=$?
    if [[ "$rc" -eq 2 ]]; then
        pass "sdd-workspace with a missing plan file errors with exit 2"
    else
        fail "sdd-workspace with a missing plan file errors with exit 2"
        echo "    exit: $rc"
    fi

    # --- per-plan resolution ---
    local dir_a dir_b
    dir_a="$(cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" plan-a.md)"
    dir_b="$(cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" plan-b.md)"

    if [[ "$dir_a" == "$repo/.superpowers/sdd/plan-a-"* ]]; then
        pass "prints <repo-root>/.superpowers/sdd/<plan-basename>-<path-hash>"
    else
        fail "prints <repo-root>/.superpowers/sdd/<plan-basename>-<path-hash>"
        echo "    got: $dir_a"
    fi

    if [[ "$dir_a" != "$dir_b" && -d "$dir_a" && -d "$dir_b" ]]; then
        pass "two plans resolve to two distinct directories"
    else
        fail "two plans resolve to two distinct directories"
        echo "    a: $dir_a"
        echo "    b: $dir_b"
    fi

    local shared_a shared_b
    shared_a="$(cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" a/shared.md)"
    shared_b="$(cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" b/shared.md)"
    if [[ "$shared_a" != "$shared_b" ]]; then
        pass "same-basename plans in different paths resolve distinctly"
    else
        fail "same-basename plans in different paths resolve distinctly"
        echo "    a: $shared_a"
        echo "    b: $shared_b"
    fi

    # --- canonical path: symlink cwd and alternate spellings share one workspace ---
    local link="$TEST_ROOT/repo-link"
    ln -s "$repo" "$link"
    local via_link via_abs via_dotdot
    via_link="$(cd "$link" && "$SDD_SCRIPTS/sdd-workspace" a/shared.md)"
    via_abs="$(cd "$link" && "$SDD_SCRIPTS/sdd-workspace" "$link/a/shared.md")"
    via_dotdot="$(cd "$link/b" && "$SDD_SCRIPTS/sdd-workspace" ../a/shared.md)"
    local canon
    canon="$(cd "$repo" && pwd -P)"
    if [[ "$via_link" == "$shared_a" && "$via_abs" == "$shared_a" && "$via_dotdot" == "$shared_a" \
        && "$via_link" == "$canon/.superpowers/sdd/shared-"* && "$via_link" != *$'\n'* ]]; then
        pass "symlink cwd and alternate spellings resolve to one canonical workspace"
    else
        fail "symlink cwd and alternate spellings resolve to one canonical workspace"
        echo "    physical: $shared_a"
        echo "    link:     $via_link"
        echo "    abs:      $via_abs"
        echo "    dotdot:   $via_dotdot"
        echo "    canon:    $canon"
    fi

    mkdir -p "$TEST_ROOT/decoy/a"
    printf 'decoy\n' > "$TEST_ROOT/decoy/a/shared.md"
    local via_cdpath cdpath_rc=0
    via_cdpath="$(cd "$link" && CDPATH="$TEST_ROOT/decoy:." "$SDD_SCRIPTS/sdd-workspace" a/shared.md 2>"$TEST_ROOT/cdpath.err")" || cdpath_rc=$?
    if [[ "$cdpath_rc" -eq 0 && "$via_cdpath" == "$shared_a" && "$via_cdpath" != *$'\n'* ]]; then
        pass "CDPATH does not redirect or pollute canonical workspace resolution"
    else
        fail "CDPATH does not redirect or pollute canonical workspace resolution"
        echo "    rc:  $cdpath_rc"
        echo "    got: $via_cdpath"
        echo "    err: $(cat "$TEST_ROOT/cdpath.err" 2>/dev/null)"
    fi

    mkdir -p "$TEST_ROOT/outside"
    printf '# Out\n\n## Task 1: Out\n\nOut.\n' > "$TEST_ROOT/outside/plan.md"
    ln -s "$TEST_ROOT/outside" "$repo/outside-link"
    rc=0
    (cd "$repo" && "$SDD_SCRIPTS/sdd-workspace" outside-link/plan.md >/dev/null 2>&1) || rc=$?
    if [[ "$rc" -eq 2 ]]; then
        pass "a plan whose physical path is outside the repo is rejected"
    else
        fail "a plan whose physical path is outside the repo is rejected"
        echo "    exit: $rc"
    fi

    if [[ -f "$repo/.superpowers/sdd/.gitignore" && "$(cat "$repo/.superpowers/sdd/.gitignore")" == "*" ]]; then
        pass "self-ignoring .gitignore created at .superpowers/sdd/ with '*'"
    else
        fail "self-ignoring .gitignore created at .superpowers/sdd/ with '*'"
    fi

    printf 'x\n' > "$dir_a/artifact.md"
    local status
    status="$(cd "$repo" && git status --porcelain)"
    # plan-a.md/plan-b.md are intentionally untracked fixture files; only the
    # workspace must be invisible.
    if [[ "$status" != *".superpowers"* ]]; then
        pass "workspace invisible to git status"
    else
        fail "workspace invisible to git status"
        echo "    status: $status"
    fi

    ( cd "$repo" && git add -A )
    local staged
    staged="$(cd "$repo" && git diff --cached --name-only)"
    if [[ "$staged" != *".superpowers"* ]]; then
        pass "git add -A does not stage the workspace"
    else
        fail "git add -A does not stage the workspace"
        echo "    staged: $staged"
    fi

    # --- task-brief lands in its plan's directory ---
    local brief_out brief_path
    brief_out="$(cd "$repo" && "$SDD_SCRIPTS/task-brief" plan-a.md 1)"
    brief_path="$(printf '%s\n' "$brief_out" | sed -n 's/^wrote \(.*\): [0-9][0-9]* lines$/\1/p')"
    if [[ "$brief_path" == "$dir_a/task-1-brief.md" ]]; then
        pass "task-brief writes its brief under the plan's workspace"
    else
        fail "task-brief writes its brief under the plan's workspace"
        echo "    got: $brief_path"
    fi

    # --- review-package takes the plan first and lands in its directory ---
    local git_id=(-c user.email=t@example.com -c user.name=t -c commit.gpgsign=false)
    ( cd "$repo" \
        && git "${git_id[@]}" commit -qm c1 \
        && printf 'y\n' > f && git add f \
        && git "${git_id[@]}" commit -qm c2 )
    local rp_out rp_path
    rp_out="$(cd "$repo" && "$SDD_SCRIPTS/review-package" plan-a.md HEAD~1 HEAD)"
    rp_path="$(printf '%s\n' "$rp_out" | sed -n 's/^wrote \(.*\): [0-9].*$/\1/p')"
    case "$rp_path" in
        "$dir_a/review-"*.diff)
            pass "review-package writes its diff under the plan's workspace" ;;
        *)
            fail "review-package writes its diff under the plan's workspace"
            echo "    got: $rp_path"
            ;;
    esac

    rc=0
    (cd "$repo" && "$SDD_SCRIPTS/review-package" HEAD~1 HEAD >/dev/null 2>&1) || rc=$?
    if [[ "$rc" -eq 2 ]]; then
        pass "review-package without a plan errors with exit 2"
    else
        fail "review-package without a plan errors with exit 2"
        echo "    exit: $rc"
    fi

    local rp_explicit
    rp_explicit="$(cd "$repo" && "$SDD_SCRIPTS/review-package" plan-a.md HEAD~1 HEAD "$TEST_ROOT/explicit.diff")"
    if [[ -s "$TEST_ROOT/explicit.diff" && "$rp_explicit" == *"$TEST_ROOT/explicit.diff"* ]]; then
        pass "review-package honors an explicit OUTFILE"
    else
        fail "review-package honors an explicit OUTFILE"
        echo "    got: $rp_explicit"
    fi

    # --- range guards: BASE must be an ancestor of HEAD, range must be non-empty ---
    local divergent
    divergent="$(cd "$repo" && git "${git_id[@]}" commit-tree 'HEAD~1^{tree}' -p 'HEAD~1' -m divergent)"
    rc=0
    local guard_err
    guard_err="$(cd "$repo" && "$SDD_SCRIPTS/review-package" plan-a.md "$divergent" HEAD 2>&1 >/dev/null)" || rc=$?
    if [[ "$rc" -eq 3 && "$guard_err" == *"not a descendant"* ]]; then
        pass "review-package rejects a BASE that is not an ancestor of HEAD with exit 3"
    else
        fail "review-package rejects a BASE that is not an ancestor of HEAD with exit 3"
        echo "    exit: $rc"
        echo "    stderr: $guard_err"
    fi

    rc=0
    guard_err="$(cd "$repo" && "$SDD_SCRIPTS/review-package" plan-a.md HEAD HEAD 2>&1 >/dev/null)" || rc=$?
    if [[ "$rc" -eq 3 && "$guard_err" == *"empty commit range"* ]]; then
        pass "review-package rejects an empty BASE..HEAD range with exit 3"
    else
        fail "review-package rejects an empty BASE..HEAD range with exit 3"
        echo "    exit: $rc"
        echo "    stderr: $guard_err"
    fi

    # --- Worktree isolation: a linked worktree resolves its own workspace ---
    local wt="$TEST_ROOT/wt"
    ( cd "$repo" && git worktree add -q "$wt" -b wt-feature )
    local wt_root wt_dir
    wt_root="$(cd "$wt" && git rev-parse --show-toplevel)"
    wt_dir="$(cd "$wt" && "$SDD_SCRIPTS/sdd-workspace" plan-a.md)"
    if [[ "$wt_dir" == "$wt_root/.superpowers/sdd/plan-a-"* && "$wt_dir" != "$dir_a" ]]; then
        pass "linked worktree resolves its own distinct workspace"
    else
        fail "linked worktree resolves its own distinct workspace"
        echo "    main: $dir_a"
        echo "    wt:   $wt_dir"
    fi

    printf 'y\n' > "$wt_dir/artifact.md"
    local wt_status
    wt_status="$(cd "$wt" && git status --porcelain)"
    if [[ "$wt_status" != *".superpowers"* ]]; then
        pass "worktree workspace invisible to git status"
    else
        fail "worktree workspace invisible to git status"
        echo "    status: $wt_status"
    fi

    # --- helpers survive a mode-stripping extractor dropping exec bits (#2040) ---
    local stripped="$TEST_ROOT/stripped-scripts"
    mkdir -p "$stripped"
    cp "$SDD_SCRIPTS/sdd-workspace" "$SDD_SCRIPTS/task-brief" "$SDD_SCRIPTS/review-package" "$stripped/"
    chmod -x "$stripped"/*
    local noexec_out noexec_rc=0
    noexec_out="$(cd "$repo" && bash "$stripped/task-brief" plan-b.md 1 2>&1)" || noexec_rc=$?
    if [[ "$noexec_rc" -eq 0 && -f "$dir_b/task-1-brief.md" ]]; then
        pass "task-brief works with no exec bit on sdd-workspace"
    else
        fail "task-brief works with no exec bit on sdd-workspace"
        echo "    rc: $noexec_rc"
        echo "    output: $noexec_out"
    fi

    local rp_noexec rp_noexec_rc=0 rp_noexec_path
    rp_noexec="$(cd "$repo" && bash "$stripped/review-package" plan-b.md HEAD~1 HEAD 2>&1)" || rp_noexec_rc=$?
    rp_noexec_path="$(printf '%s\n' "$rp_noexec" | sed -n 's/^wrote \(.*\): [0-9].*$/\1/p')"
    if [[ "$rp_noexec_rc" -eq 0 && -f "$rp_noexec_path" && "$rp_noexec_path" == "$dir_b"/review-*.diff ]]; then
        pass "review-package works with no exec bit on sdd-workspace"
    else
        fail "review-package works with no exec bit on sdd-workspace"
        echo "    rc: $rp_noexec_rc"
        echo "    output: $rp_noexec"
    fi

    # --- A repo's own committed .superpowers/sdd/.gitignore is left alone ---
    git init -q -b main "$TEST_ROOT/own-ignore"
    local own own_ignore
    own="$(cd "$TEST_ROOT/own-ignore" && git rev-parse --show-toplevel)"
    own_ignore=$'*\n!.gitignore\n!*/\n!*/progress.md'
    mkdir -p "$own/.superpowers/sdd"
    printf '%s\n' "$own_ignore" > "$own/.superpowers/sdd/.gitignore"
    printf '# Plan\n\n## Task 1: One\n\nOne.\n' > "$own/plan.md"
    (cd "$own" && git add -A && git -c user.name=t -c user.email=t@t commit -qm init)
    (cd "$own" && "$SDD_SCRIPTS/sdd-workspace" plan.md >/dev/null)
    if [[ "$(cat "$own/.superpowers/sdd/.gitignore")" == "$own_ignore" \
        && -z "$(cd "$own" && git status --porcelain -- .superpowers/sdd/.gitignore)" ]]; then
        pass "an existing .superpowers/sdd/.gitignore is not overwritten"
    else
        fail "an existing .superpowers/sdd/.gitignore is not overwritten"
        echo "    now: $(cat "$own/.superpowers/sdd/.gitignore")"
    fi

    echo ""
    if [[ "$FAILURES" -ne 0 ]]; then
        echo "FAILED: $FAILURES assertion(s)."
        exit 1
    fi
    echo "PASS"
}

main "$@"
