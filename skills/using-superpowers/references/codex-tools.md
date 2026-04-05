# Codex Tool Mapping

Skills use Claude Code tool names. When you encounter these in a skill, use your platform equivalent:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Task` tool (dispatch subagent) | `spawn_agent` (see [Named agent dispatch](#named-agent-dispatch)) |
| Multiple `Task` calls (parallel) | Multiple `spawn_agent` calls |
| Task returns result | `wait_agent` |
| Task completes automatically | `close_agent` to free slot |
| `TodoWrite` (task tracking) | `update_plan` |
| `Skill` tool (invoke a skill) | Skills load natively — just follow the instructions |
| `Read`, `Write`, `Edit` (files) | Use your native file tools |
| `Bash` (run commands) | Use your native shell tools |

## Subagent dispatch requires multi-agent support

Add to your Codex config (`~/.codex/config.toml`):

```toml
[features]
multi_agent = true
```

This enables `spawn_agent`, `wait_agent`, and `close_agent` for skills like `dispatching-parallel-agents` and `subagent-driven-development`.

## Canonical Codex Subagent Lifecycle

In Codex, subagent orchestration should use the agent lifecycle tools directly rather than shell waits, ad-hoc polling commands, or unrelated background-task patterns.

Use this minimum closed loop:

1. `spawn_agent(...)`
2. Record the returned `agent_id` plus the task target / ownership
3. When blocked on the result, call `wait_agent(...)`
4. If multiple agents are active, maintain a `pending` collection keyed by `agent_id`
5. Process whichever agent completes and remove it from `pending`
6. Once the result is integrated and the agent is no longer needed, call `close_agent(id)`

### Single-agent pattern

```text
agent_id = spawn_agent(...)
record { agent_id, target }

if blocked on the result:
  wait_agent([agent_id], timeout_ms=...)

when finished and no longer needed:
  close_agent(agent_id)
```

### Multi-agent pattern

```text
pending = { agent_id: target, ... }

while pending is not empty:
  completed = wait_agent(ids=[...pending.keys()], timeout_ms=...)
  process whichever agent finished
  remove finished agent from pending
  close_agent(agent_id) when its work is integrated and no follow-up is needed
```

### Codex-specific rules

- Do **not** substitute shell `wait`, sleep loops, `write_stdin` polling, or other generic command waits for subagent completion semantics
- Do **not** busy-poll in short intervals; if blocked, prefer a longer `wait_agent`
- If you can continue meaningful non-overlapping work, do that before waiting
- If you need the result immediately for the next step, `wait_agent` is the correct blocking primitive
- Finished agents still consume coordination overhead; close them promptly once they are no longer needed

## Named agent dispatch

Claude Code skills reference named agent types like `superpowers:code-reviewer`.
Codex does not have a named agent registry — `spawn_agent` creates generic agents
from built-in roles (`default`, `explorer`, `worker`).

When a skill says to dispatch a named agent type:

1. Find the agent's prompt file (e.g., `agents/code-reviewer.md` or the skill's
   local prompt template like `code-quality-reviewer-prompt.md`)
2. Read the prompt content
3. Fill any template placeholders (`{BASE_SHA}`, `{WHAT_WAS_IMPLEMENTED}`, etc.)
4. Spawn a `worker` agent with the filled content as the `message`

| Skill instruction | Codex equivalent |
|-------------------|------------------|
| `Task tool (superpowers:code-reviewer)` | `spawn_agent(agent_type="worker", message=...)` with `code-reviewer.md` content |
| `Task tool (general-purpose)` with inline prompt | `spawn_agent(message=...)` with the same prompt |

### Message framing

The `message` parameter is user-level input, not a system prompt. Structure it
for maximum instruction adherence:

```
Your task is to perform the following. Follow the instructions below exactly.

<agent-instructions>
[filled prompt content from the agent's .md file]
</agent-instructions>

Execute this now. Output ONLY the structured response following the format
specified in the instructions above.
```

- Use task-delegation framing ("Your task is...") rather than persona framing ("You are...")
- Wrap instructions in XML tags — the model treats tagged blocks as authoritative
- End with an explicit execution directive to prevent summarization of the instructions

### When this workaround can be removed

This approach compensates for Codex's plugin system not yet supporting an `agents`
field in `plugin.json`. When `RawPluginManifest` gains an `agents` field, the
plugin can symlink to `agents/` (mirroring the existing `skills/` symlink) and
skills can dispatch named agent types directly.

## Environment Detection

Skills that create worktrees or finish branches should detect their
environment with read-only git commands before proceeding:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR != GIT_COMMON` → already in a linked worktree (skip creation)
- `BRANCH` empty → detached HEAD (cannot branch/push/PR from sandbox)

See `using-git-worktrees` Step 0 and `finishing-a-development-branch`
Step 1 for how each skill uses these signals.

## Codex App Finishing

When the sandbox blocks branch/push operations (detached HEAD in an
externally managed worktree), the agent commits all work and informs
the user to use the App's native controls:

- **"Create branch"** — names the branch, then commit/push/PR via App UI
- **"Hand off to local"** — transfers work to the user's local checkout

The agent can still run tests, stage files, and output suggested branch
names, commit messages, and PR descriptions for the user to copy.
