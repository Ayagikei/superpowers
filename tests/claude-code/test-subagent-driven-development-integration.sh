#!/usr/bin/env bash
# End-to-end smoke test for bounded SDD execution.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

TEST_PROJECT=$(create_test_project)
trap 'cleanup_test_project "$TEST_PROJECT"' EXIT
cd "$TEST_PROJECT"

mkdir -p src test docs/plans
cat > package.json <<'JSON'
{"name":"sdd-smoke","version":"1.0.0","type":"module","scripts":{"test":"node --test"}}
JSON
cat > docs/plans/delivery-plan.md <<'PLAN'
# Math delivery plan

Goal: export add and multiply with focused tests. Do not add other operations.

Files: src/math.js, test/math.test.js

Acceptance:
- add(2, 3) = 5
- multiply(2, 3) = 6
- npm test passes

Validation: npm test
PLAN

git init -q
git config user.email test@example.com
git config user.name Test
git add .
git commit -qm initial

PLUGIN_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
OUTPUT_FILE="$TEST_PROJECT/claude-output.txt"
PROMPT='Execute docs/plans/delivery-plan.md using subagent-driven-development.
Use bounded delegation only where beneficial. Do not commit. Reuse complete worker
test evidence, inspect the integrated diff, and run one fresh final verification.'

timeout 1800 claude -p "$PROMPT" --plugin-dir "$PLUGIN_DIR" \
  --allowed-tools=all --permission-mode bypassPermissions 2>&1 | tee "$OUTPUT_FILE"

npm test
test -f src/math.js
test -f test/math.test.js
grep -q 'export function add' src/math.js
grep -q 'export function multiply' src/math.js
! grep -Eq 'export function (divide|power|subtract)' src/math.js

commit_count=$(git rev-list --count HEAD)
test "$commit_count" -eq 1

echo "PASS: bounded SDD delivered working code without unauthorized commits"
