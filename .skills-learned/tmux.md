# TMUX Skill Summary

## What It Does

The tmux skill provides remote control of tmux sessions for running interactive CLIs (Command Line Interfaces). It allows OpenClaw to:

- Create and manage isolated tmux sessions
- Send keystrokes to interactive programs
- Capture and scrape output from terminal panes
- Run multiple coding agents or REPLs in parallel

**Key Principle**: Use tmux only for interactive TTY applications. For long-running, non-interactive tasks, prefer the standard `exec` tool with background mode.

## Tools/Commands Provided

### Core tmux Commands

| Command | Purpose |
|---------|---------|
| `tmux -S "$SOCKET" new -d -s <session>` | Create new detached session |
| `tmux -S "$SOCKET" send-keys -t <target> -l -- "<text>"` | Send literal text to pane |
| `tmux -S "$SOCKET" send-keys -t <target> Enter` | Send Enter key |
| `tmux -S "$SOCKET" send-keys -t <target> C-c` | Send Ctrl+C (interrupt) |
| `tmux -S "$SOCKET" capture-pane -p -J -t <target> -S -<lines>` | Capture pane output |
| `tmux -S "$SOCKET" list-sessions` | List all sessions |
| `tmux -S "$SOCKET" list-panes -a` | List all panes |
| `tmux -S "$SOCKET" attach -t <session>` | Attach to session (for monitoring) |
| `tmux -S "$SOCKET" kill-session -t <session>` | Kill a session |
| `tmux -S "$SOCKET" kill-server` | Kill all sessions on socket |

### Helper Scripts

| Script | Purpose |
|--------|---------|
| `{baseDir}/scripts/find-sessions.sh` | Find sessions on a socket or all sockets |
| `{baseDir}/scripts/wait-for-text.sh` | Poll pane for regex pattern with timeout |

## Configuration

### Socket Convention

```bash
# Environment variable (preferred)
SOCKET_DIR="${OPENCLAW_TMUX_SOCKET_DIR:-${CLAWDBOT_TMUX_SOCKET_DIR:-${TMPDIR:-/tmp}/openclaw-tmux-sockets}}"
SOCKET="$SOCKET_DIR/openclaw.sock"

# Create directory
mkdir -p "$SOCKET_DIR"
```

### Targeting Format

- Format: `session:window.pane` (defaults to `:0.0`)
- Keep names short, avoid spaces
- Examples: `myapp:0.0`, `agent-1`, `codex:1.2`

### Requirements

- **OS**: macOS or Linux (darwin/linux)
- **Binary**: `tmux` must be on PATH
- **Windows**: Use WSL with tmux installed inside

## Common Use Cases

### 1. Python REPL Session

```bash
SOCKET="${TMPDIR:-/tmp}/openclaw-tmux-sockets/openclaw.sock"
SESSION=openclaw-python

# Create session with Python REPL
tmux -S "$SOCKET" new -d -s "$SESSION" -n shell
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 -- 'PYTHON_BASIC_REPL=1 python3 -q' Enter

# Capture output
tmux -S "$SOCKET" capture-pane -p -J -t "$SESSION":0.0 -S -200
```

### 2. Running Interactive TUI Apps (Claude Code, Codex)

**Important**: Split text and Enter with a delay to avoid paste/multi-line issues:

```bash
# Send command
tmux -S "$SOCKET" send-keys -t target -l -- "$cmd" && sleep 0.1 && tmux -S "$SOCKET" send-keys -t target Enter

# Wait for completion (check for prompt)
{baseDir}/scripts/wait-for-text.sh -t session:0.0 -p '❯'

# Get results
tmux -S "$SOCKET" capture-pane -p -t session:0.0 -S -500
```

### 3. Parallel Coding Agents

```bash
SOCKET="${TMPDIR:-/tmp}/codex-army.sock"

# Spawn multiple agents
for i in 1 2 3 4 5; do
  tmux -S "$SOCKET" new-session -d -s "agent-$i"
done

# Launch different tasks
tmux -S "$SOCKET" send-keys -t agent-1 "cd /tmp/project1 && codex --yolo 'Fix bug X'" Enter
tmux -S "$SOCKET" send-keys -t agent-2 "cd /tmp/project2 && codex --yolo 'Fix bug Y'" Enter

# Check completion status
for sess in agent-1 agent-2; do
  if tmux -S "$SOCKET" capture-pane -p -t "$sess" -S -3 | grep -q "❯"; then
    echo "$sess: DONE"
  fi
done
```

### 4. Monitoring Commands

Always print these after starting a session:

```bash
echo "To monitor:"
echo "  tmux -S \"$SOCKET\" attach -t \"$SESSION\""
echo "  tmux -S \"$SOCKET\" capture-pane -p -J -t \"$SESSION\":0.0 -S -200"
```

## Best Practices

1. **Use isolated sockets** - Don't interfere with user's tmux sessions
2. **Set `PYTHON_BASIC_REPL=1`** - Required for Python REPLs to work with send-keys
3. **Split text + Enter** - For TUI apps, add a small delay (0.1s) between text and Enter
4. **Use wait-for-text.sh** - Poll for prompts or completion indicators
5. **Clean up sessions** - Kill sessions when done to free resources
6. **Check for prompts** - Use shell prompt characters (`❯`, `$`) to detect task completion
7. **Use git worktrees** - For parallel agents to avoid branch conflicts

## Cleanup Commands

```bash
# Kill specific session
tmux -S "$SOCKET" kill-session -t "$SESSION"

# Kill all sessions on socket
tmux -S "$SOCKET" list-sessions -F '#{session_name}' | xargs -r -n1 tmux -S "$SOCKET" kill-session -t

# Kill entire server
tmux -S "$SOCKET" kill-server
```
