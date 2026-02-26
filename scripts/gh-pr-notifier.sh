#!/usr/bin/env bash
#
# GitHub PR Notifier with Weather
# A helper script that checks GitHub PRs and provides weather info
# Uses skills: github, weather
#

set -e

# Configuration
REPOS=()  # Add your repos here: "owner/repo"
LOCATION="Beijing"  # Default location for weather
NOTIFY_VOICE=false  # Set to true to enable voice notifications

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if gh CLI is installed
check_gh() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed"
        echo "Install it from: https://cli.github.com/"
        return 1
    fi
    
    if ! gh auth status &> /dev/null; then
        print_error "Not authenticated with GitHub"
        echo "Run: gh auth login"
        return 1
    fi
    
    return 0
}

# Check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed"
        return 1
    fi
    return 0
}

# Get weather information
get_weather() {
    local location="${1:-$LOCATION}"
    
    print_header "🌤️  WEATHER for $location"
    
    # URL encode spaces
    local encoded_location="${location// /+}"
    
    # Get compact weather info
    local weather
    weather=$(curl -s "wttr.in/${encoded_location}?format=%l:+%c+%t+%h+%w" 2>/dev/null || echo "Weather service unavailable")
    
    echo "$weather"
    echo ""
    
    # Get one-liner summary
    local summary
    summary=$(curl -s "wttr.in/${encoded_location}?format=3" 2>/dev/null || echo "N/A")
    echo "Summary: $summary"
    echo ""
}

# Get open PRs for a repository
get_prs() {
    local repo="$1"
    
    echo -e "${YELLOW}Repository: $repo${NC}"
    
    # Get open PRs with JSON output
    local prs
    prs=$(gh pr list --repo "$repo" --json number,title,author,createdAt,url,headRefName --limit 10 2>/dev/null || echo "[]")
    
    if [ "$prs" = "[]" ] || [ -z "$prs" ]; then
        print_success "No open PRs"
        return
    fi
    
    # Count PRs
    local count
    count=$(echo "$prs" | grep -o '"number":' | wc -l)
    
    if [ "$count" -eq 0 ]; then
        print_success "No open PRs"
        return
    fi
    
    print_warning "$count open PR(s) found"
    
    # Display PR details
    echo "$prs" | while read -r line; do
        if echo "$line" | grep -q '"number":'; then
            local num title author created url branch
            num=$(echo "$line" | grep -o '"number":[0-9]*' | cut -d: -f2)
            title=$(echo "$line" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
            author=$(echo "$line" | grep -o '"author":{"login":"[^"]*"' | cut -d'"' -f4)
            created=$(echo "$line" | grep -o '"createdAt":"[^"]*"' | cut -d'"' -f4 | cut -dT -f1)
            url=$(echo "$line" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
            branch=$(echo "$line" | grep -o '"headRefName":"[^"]*"' | cut -d'"' -f4)
            
            echo ""
            echo -e "  ${GREEN}PR #$num${NC}: $title"
            echo -e "  Author: $author | Created: $created"
            echo -e "  Branch: $branch"
            echo -e "  URL: $url"
        fi
    done
    
    echo ""
}

# Check CI status for recent PRs
check_ci_status() {
    local repo="$1"
    
    echo -e "${YELLOW}Recent CI Status for $repo${NC}"
    
    # Get recent workflow runs
    local runs
    runs=$(gh run list --repo "$repo" --limit 5 --json name,status,conclusion,createdAt,url 2>/dev/null || echo "[]")
    
    if [ "$runs" = "[]" ] || [ -z "$runs" ]; then
        echo "  No recent workflow runs"
        return
    fi
    
    # Display runs
    echo "$runs" | grep -o '{[^}]*}' | while read -r run; do
        local name status conclusion created url
        name=$(echo "$run" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        status=$(echo "$run" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        conclusion=$(echo "$run" | grep -o '"conclusion":"[^"]*"' | cut -d'"' -f4)
        created=$(echo "$run" | grep -o '"createdAt":"[^"]*"' | cut -d'"' -f4 | cut -dT -f1)
        
        local icon
        if [ "$conclusion" = "success" ]; then
            icon="${GREEN}✓${NC}"
        elif [ "$conclusion" = "failure" ]; then
            icon="${RED}✗${NC}"
        else
            icon="${YELLOW}○${NC}"
        fi
        
        echo -e "  $icon $name - ${status}${conclusion:+ ($conclusion)} - $created"
    done
    
    echo ""
}

# Voice notification using SAG (if available)
notify_voice() {
    if [ "$NOTIFY_VOICE" != "true" ]; then
        return
    fi
    
    if ! command -v sag &> /dev/null; then
        return
    fi
    
    local message="$1"
    sag "$message" 2>/dev/null || true
}

# Main execution
main() {
    print_header "📊 GitHub PR Notifier - $(date '+%Y-%m-%d %H:%M')"
    
    # Check dependencies
    check_curl || exit 1
    
    # Get weather
    get_weather "$LOCATION"
    
    # Check GitHub CLI
    if ! check_gh; then
        print_warning "Skipping GitHub checks"
        exit 0
    fi
    
    # Check if repos are configured
    if [ ${#REPOS[@]} -eq 0 ]; then
        print_warning "No repositories configured"
        echo "Edit this script and add repos to the REPOS array:"
        echo '  REPOS=("owner/repo1" "owner/repo2")'
        echo ""
        
        # Show example with user's own repos if available
        echo "Your accessible repositories (sample):"
        gh repo list --limit 5 2>/dev/null || echo "  (unable to list)"
        exit 0
    fi
    
    # Process each repository
    print_header "🔀 PULL REQUESTS"
    
    local total_prs=0
    
    for repo in "${REPOS[@]}"; do
        echo ""
        get_prs "$repo"
        check_ci_status "$repo"
    done
    
    # Summary
    print_header "📋 SUMMARY"
    echo "Checked ${#REPOS[@]} repository(ies)"
    echo "Location: $LOCATION"
    echo "Time: $(date)"
    
    # Voice notification
    notify_voice "GitHub PR check complete. Checked ${#REPOS[@]} repositories."
}

# Help message
show_help() {
    cat << 'EOF'
GitHub PR Notifier with Weather

Usage: ./gh-pr-notifier.sh [options]

Options:
  -l, --location CITY    Set location for weather (default: Beijing)
  -r, --repo OWNER/REPO  Add a repository to check (can be used multiple times)
  -v, --voice            Enable voice notifications (requires SAG)
  -h, --help             Show this help message

Examples:
  ./gh-pr-notifier.sh
  ./gh-pr-notifier.sh -l "New York" -r "torvalds/linux"
  ./gh-pr-notifier.sh --location London --repo "facebook/react" --voice

Configuration:
  Edit the script to set default values:
    REPOS=("owner/repo1" "owner/repo2")
    LOCATION="Your City"
    NOTIFY_VOICE=true

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--location)
            LOCATION="$2"
            shift 2
            ;;
        -r|--repo)
            REPOS+=("$2")
            shift 2
            ;;
        -v|--voice)
            NOTIFY_VOICE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main function
main
