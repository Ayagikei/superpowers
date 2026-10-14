#!/usr/bin/env bash
# Behavioral recall test for the lean SDD contract.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
CLAUDE_PROMPT_TIMEOUT="${CLAUDE_PROMPT_TIMEOUT:-90}"

ask() { run_claude "$1" "$CLAUDE_PROMPT_TIMEOUT"; }

echo "=== Test: lean subagent-driven-development contract ==="

output=$(ask "When should subagent-driven-development be used instead of direct execution?")
assert_contains "$output" "benefit\|independent\|isolation\|bounded\|parallel" "Delegation has a benefit gate"
assert_contains "$output" "direct\|trivial\|tightly coupled" "Direct execution remains valid"

output=$(ask "What are the default and maximum delegation depths in subagent-driven-development?")
assert_contains "$output" "default.*1\|depth.*1" "Default depth is 1"
assert_contains "$output" "maximum.*2\|max.*2\|depth.*2" "Maximum depth is 2"

output=$(ask "Which workflow skills should an SDD worker load automatically?")
assert_contains "$output" "do not\|doesn't\|none\|not.*orchestration" "Workers skip orchestration skills"
assert_contains "$output" "domain\|debugging\|TDD\|named" "Domain skills remain available"

output=$(ask "Does SDD require an independent reviewer after every task? Explain the lane-based rule.")
assert_contains "$output" "no\|not.*every\|risk" "Per-task review is not mandatory"
assert_contains "$output" "Heavy\|heavy" "Heavy lane gets final review"

output=$(ask "After an SDD reviewer reports an open blocking finding, when should the original implementer be resumed, and when may it be replaced? What should the re-review cover?")
assert_contains "$output" "reliable\|trustworthy\|trust.*evidence\|evidence.*trust" "Original implementer is resumed only while evidence remains reliable"
assert_contains "$output" "replacement\|fresh.*worker\|new.*implementer" "Unreliable evidence permits a fresh replacement"
assert_contains "$output" "scoped\|finding.*fix\|fix.*finding\|open block" "Re-review is scoped to the blocker and fix"

output=$(ask "What is the SDD independent-review round limit, and does reaching that cap turn an unresolved blocker into approval?")
assert_contains "$output" "three\|3" "Independent review is capped at three rounds or the stricter runtime policy"
assert_contains "$output" "not.*approval\|not.*correctness\|bounded.*fix\|unresolved" "Review cap does not waive correctness or unresolved blockers"

output=$(ask "A worker reports the exact test command, exit code 0, key output, and no later code changed. Must the controller rerun that same targeted test?")
assert_contains "$output" "no\|reuse\|trust\|not rerun\|do not rerun" "Valid worker evidence is reused"

output=$(ask "What verification remains before SDD claims completion, and may a current worker result satisfy it?")
assert_contains "$output" "current\|still.valid\|reuse\|final verification" "One current final verification remains and valid evidence may satisfy it"

output=$(ask "May an SDD worker commit or push by default?")
assert_contains "$output" "no\|not.*unless\|explicit" "No commit or push without authorization"

echo "=== lean SDD contract passed ==="
