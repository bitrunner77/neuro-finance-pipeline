# GitHub Skill Summary

## Overview
The GitHub skill enables interaction with GitHub repositories using the official `gh` CLI (GitHub CLI). It provides a command-line interface for managing issues, pull requests, CI/CD workflows, and making API calls.

## What It Does
- Manage GitHub repositories via command line
- Check PR status and CI checks
- List and view workflow runs
- Query GitHub API for advanced operations
- Work with issues and pull requests

## Tools/Commands Provided

### Pull Requests
- `gh pr checks <number> --repo owner/repo` - Check CI status on a PR
- `gh pr list --repo owner/repo` - List open PRs
- `gh pr view <number> --repo owner/repo` - View PR details

### Workflow Runs (CI/CD)
- `gh run list --repo owner/repo --limit 10` - List recent workflow runs
- `gh run view <run-id> --repo owner/repo` - View run details and failed steps
- `gh run view <run-id> --repo owner/repo --log-failed` - View logs for failed steps only

### API Access
- `gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'` - Make custom API queries
- Supports `--json` output and `--jq` filtering for structured data

### Issues
- `gh issue list --repo owner/repo --json number,title` - List issues with JSON output

## Configuration

### Prerequisites
- Requires `gh` CLI binary to be installed

### Installation Options
1. **macOS (Homebrew)**: `brew install gh`
2. **Ubuntu/Debian (apt)**: `apt install gh`

### Authentication
- Must authenticate with `gh auth login` before use
- Supports both HTTPS and SSH authentication methods

## Common Use Cases

1. **CI/CD Monitoring**
   - Check if PR checks are passing
   - View recent workflow runs
   - Debug failed CI steps

2. **Repository Management**
   - List and view pull requests
   - Query issues
   - Access advanced GitHub API features

3. **Automation & Scripting**
   - Use `--json` and `--jq` for structured data extraction
   - Chain commands for automated workflows
   - Query specific fields from GitHub objects

## Best Practices
- Always specify `--repo owner/repo` when not in a git directory
- Use `--json` with `--jq` for parsing output in scripts
- Use `--log-failed` to quickly identify CI issues
