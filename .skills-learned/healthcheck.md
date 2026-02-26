# Healthcheck Skill Summary

## What It Does

The Healthcheck skill provides **host security hardening and risk-tolerance configuration** for OpenClaw deployments. It helps assess and harden the machine running OpenClaw (laptop, workstation, Pi, VPS) while aligning security measures to a user-defined risk tolerance without breaking access.

## Tools/Commands Provided

### OpenClaw CLI Commands Used

| Command | Description |
|---------|-------------|
| `openclaw security audit` | Basic security audit (fast, non-probing) |
| `openclaw security audit --deep` | Comprehensive security audit |
| `openclaw security audit --json` | Structured JSON output |
| `openclaw security audit --fix` | Apply OpenClaw safe defaults |
| `openclaw update status` | Check OpenClaw version and update availability |
| `openclaw status` / `openclaw status --deep` | Gateway status check |
| `openclaw health --json` | Health check with JSON output |
| `openclaw cron add|list|runs|run` | Schedule periodic security checks |

### System Commands Used (Read-Only)

- **OS Detection**: `uname -a`, `sw_vers`, `cat /etc/os-release`
- **Listening Ports**: `ss -ltnup` (Linux), `lsof -nP -iTCP -sTCP:LISTEN` (macOS)
- **Firewall Status**: `ufw status`, `firewall-cmd --state`, `nft list ruleset`, `pfctl -s info`
- **Backups**: `tmutil status` (macOS Time Machine)

## Configuration

### Risk Profiles (User Selectable)

1. **Home/Workstation Balanced** (most common): Firewall on with reasonable defaults, remote access restricted to LAN or tailnet
2. **VPS Hardened**: Deny-by-default inbound firewall, minimal open ports, key-only SSH, no root login, automatic security updates
3. **Developer Convenience**: More local services allowed, explicit exposure warnings, still audited
4. **Custom**: User-defined constraints (services, exposure, update cadence, access methods)

### Cron Job Scheduling

- Uses `openclaw cron add` with stable job names:
  - `healthcheck:security-audit` - Periodic security audits
  - `healthcheck:update-status` - Version/update checks

### Required Confirmations

Explicit approval required for:
- Firewall rule changes
- Opening/closing ports
- SSH/RDP configuration changes
- Installing/removing packages
- Enabling/disabling services
- User/group modifications
- Scheduling tasks
- Update policy changes
- Access to sensitive files

## Common Use Cases

1. **Initial Security Audit** - Run `openclaw security audit --deep` to assess current security posture
2. **Applying Safe Defaults** - Run `openclaw security audit --fix` to tighten OpenClaw defaults and file permissions
3. **Version Management** - Check `openclaw update status` to stay current with updates
4. **Periodic Monitoring** - Schedule regular audits via `openclaw cron add` for ongoing security
5. **Risk Assessment** - Determine appropriate risk profile based on deployment context (local workstation vs headless server vs VPS)
6. **Hardening Guidance** - Get step-by-step remediation plans with rollback strategies

## Key Notes

- **Does NOT modify host firewall, SSH, or OS updates** - Only OpenClaw-specific settings
- Requires state-of-the-art model for best results (Opus 4.5, GPT 5.2+)
- All changes are reversible with staged rollout
- Access preservation is prioritized - never breaks remote access without confirmation
- Memory writes only in private/local workspaces with explicit opt-in
