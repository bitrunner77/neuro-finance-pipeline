# Helper Scripts

This directory contains utility scripts created by the Coder agent based on skills learned by the Researcher.

## Scripts

### 1. `gh-pr-notifier.sh` - GitHub PR Notifier with Weather

A daily briefing script that combines GitHub and Weather skills.

**Features:**
- Checks open PRs in configured repositories
- Shows CI/CD workflow run status
- Displays current weather for your location
- Optional voice notifications (requires SAG)

**Usage:**
```bash
# Basic usage (shows weather, checks configured repos)
./gh-pr-notifier.sh

# Specify location and repositories
./gh-pr-notifier.sh -l "New York" -r "torvalds/linux" -r "facebook/react"

# Enable voice notifications
./gh-pr-notifier.sh --voice
```

**Configuration:**
Edit the script to set defaults:
```bash
REPOS=("owner/repo1" "owner/repo2")
LOCATION="Your City"
NOTIFY_VOICE=true
```

**Requirements:**
- `curl` (for weather)
- `gh` CLI with authentication (for GitHub)
- `sag` (optional, for voice notifications)

---

### 2. `health-monitor.sh` - System Health Monitor

A system monitoring script based on the Healthcheck skill patterns.

**Features:**
- Disk usage monitoring with configurable thresholds
- Memory usage tracking
- CPU load average checks
- Network port listing
- OpenClaw gateway status
- System update availability

**Usage:**
```bash
# Basic health check
./health-monitor.sh

# Custom thresholds
./health-monitor.sh --disk-threshold 90 --memory-threshold 95

# Skip OpenClaw check
./health-monitor.sh --no-openclaw
```

**Exit Codes:**
- `0` - All checks passed
- `N` - Number of issues detected

**Requirements:**
- Standard Unix tools (`df`, `free`/`vm_stat`, `uptime`, `ss`/`netstat`)
- `openclaw` CLI (optional, for OpenClaw status)
- `apt`/`dnf`/`brew` (optional, for update checks)

---

## Skills Used

These scripts leverage the following skills from `.skills-learned/`:

| Script | Skills Used |
|--------|-------------|
| `gh-pr-notifier.sh` | github, weather, sag |
| `health-monitor.sh` | healthcheck |

---

## Adding New Scripts

When creating new scripts:
1. Check `.skills-learned/` for relevant skills
2. Make scripts executable: `chmod +x script.sh`
3. Add usage documentation
4. Update this README
5. Update your agent status file
