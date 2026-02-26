# Agent Communication Protocol

## Overview
This document defines how sub-agents communicate with each other and the Project Manager.

## Agent Roles

### Project Manager (agent: planner)
- Coordinates all sub-agents
- Tracks project status
- Assigns tasks
- Reviews daily reports

### Researcher (agent: researcher)
- Gathers information
- Learns new skills
- Shares findings with PM

### Coder (agent: coder)
- Implements solutions
- Writes code
- Reports progress to PM

## Communication Methods

### 1. Direct Messaging (sessions_send)
Agents can send messages to each other:
```
sessions_send(sessionKey="agent:main:subagent:<id>", message="...")
```

### 2. Shared Memory (memory/ directory)
Agents write to shared files:
- `memory/agent-status/<agent-id>.md` - Current status
- `memory/agent-reports/<date>-<agent>.md` - Daily reports
- `memory/projects/<project-name>/` - Project files

### 3. Daily Standups (cron)
Each agent runs a daily cron job to report status.

## Message Format

```markdown
**From:** <agent-name>
**To:** <recipient-or-all>
**Type:** [status|request|response|learning|blocker]
**Timestamp:** <ISO-8601>

## Content
...

## Action Items
- [ ] ...
```

## Daily Workflow

1. **Morning (09:00)**: PM sends daily goals
2. **Throughout day**: Agents work and post updates
3. **Evening (18:00)**: Agents submit daily reports
4. **PM reviews**: Consolidates and plans next day

## Improvement Loop

Agents improve by:
1. Reading each other's reports
2. Learning from shared findings
3. Requesting help when blocked
4. Suggesting improvements to PM
