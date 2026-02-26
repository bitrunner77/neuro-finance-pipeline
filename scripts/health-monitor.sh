#!/usr/bin/env bash
#
# System Health Monitor
# Monitors system health, disk usage, and provides security insights
# Uses skills: healthcheck
#

set -e

# Configuration
DISK_THRESHOLD=80       # Alert if disk usage > 80%
MEMORY_THRESHOLD=90     # Alert if memory usage > 90%
LOAD_THRESHOLD=2.0      # Alert if load avg > 2.0
CHECK_OPENCLAW=true     # Check OpenClaw status

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
}

print_section() {
    echo -e "${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}  ✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}  ✗ $1${NC}"
}

# Check disk usage
check_disk() {
    print_section "Disk Usage"
    
    local alerts=0
    
    # Get disk usage for all mounted filesystems
    df -h | grep -E '^/dev/' | while read -r filesystem size used avail percent mount; do
        local usage
        usage=$(echo "$percent" | tr -d '%')
        
        if [ "$usage" -ge "$DISK_THRESHOLD" ]; then
            print_error "$mount: $percent full ($used / $size)"
            ((alerts++))
        elif [ "$usage" -ge 70 ]; then
            print_warning "$mount: $percent full ($used / $size)"
        else
            print_success "$mount: $percent full ($used / $size)"
        fi
    done
    
    return $alerts
}

# Check memory usage
check_memory() {
    print_section "Memory Usage"
    
    # Get memory info
    local mem_total mem_used mem_free mem_available
    
    if [ -f /proc/meminfo ]; then
        mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        mem_used=$((mem_total - mem_available))
        
        local usage_percent
        usage_percent=$(echo "scale=0; $mem_used * 100 / $mem_total" | bc 2>/dev/null || echo "0")
        
        local mem_used_gb mem_total_gb
        mem_used_gb=$(echo "scale=1; $mem_used / 1024 / 1024" | bc 2>/dev/null || echo "N/A")
        mem_total_gb=$(echo "scale=1; $mem_total / 1024 / 1024" | bc 2>/dev/null || echo "N/A")
        
        if [ "$usage_percent" -ge "$MEMORY_THRESHOLD" ]; then
            print_error "Memory: ${usage_percent}% used (${mem_used_gb}GB / ${mem_total_gb}GB)"
            return 1
        elif [ "$usage_percent" -ge 75 ]; then
            print_warning "Memory: ${usage_percent}% used (${mem_used_gb}GB / ${mem_total_gb}GB)"
        else
            print_success "Memory: ${usage_percent}% used (${mem_used_gb}GB / ${mem_total_gb}GB)"
        fi
    else
        # macOS fallback
        local mem_pressure
        mem_pressure=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%' || echo "")
        if [ -n "$mem_pressure" ]; then
            local used=$((100 - mem_pressure))
            if [ "$used" -ge "$MEMORY_THRESHOLD" ]; then
                print_error "Memory: ${used}% used"
                return 1
            else
                print_success "Memory: ${used}% used"
            fi
        fi
    fi
    
    return 0
}

# Check CPU load
check_load() {
    print_section "CPU Load"
    
    local load1 load5 load15
    
    if [ -f /proc/loadavg ]; then
        read -r load1 load5 load15 _ _ < /proc/loadavg
    else
        # macOS fallback
        load1=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1}' | tr -d ',')
        load5=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $2}' | tr -d ',')
        load15=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $3}')
    fi
    
    # Get number of CPUs
    local cpus
    cpus=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "1")
    
    # Calculate load percentage
    local load_percent
    load_percent=$(echo "scale=0; $load1 * 100 / $cpus" | bc 2>/dev/null || echo "0")
    
    if (( $(echo "$load1 > $LOAD_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        print_error "Load: $load1 (1min), $load5 (5min), $load15 (15min) - High load detected!"
        return 1
    else
        print_success "Load: $load1 (1min), $load5 (5min), $load15 (15min) - $cpus CPUs"
    fi
    
    return 0
}

# Check uptime
check_uptime() {
    print_section "Uptime"
    
    local uptime_str
    uptime_str=$(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\),.*/\1/')
    
    echo "  System up for: $uptime_str"
}

# Check listening ports
check_ports() {
    print_section "Listening Ports"
    
    local ports
    if command -v ss > /dev/null 2>&1; then
        ports=$(ss -ltnH 2>/dev/null | wc -l)
        echo "  TCP listening ports: $ports"
        ss -ltn 2>/dev/null | grep LISTEN | head -5 | while read -r line; do
            echo "    $line"
        done
    elif command -v netstat > /dev/null 2>&1; then
        ports=$(netstat -tln 2>/dev/null | grep -c LISTEN || echo "0")
        echo "  TCP listening ports: $ports"
    else
        echo "  (ss/netstat not available)"
    fi
}

# Check OpenClaw status
check_openclaw() {
    print_section "OpenClaw Status"
    
    if ! command -v openclaw > /dev/null 2>&1; then
        print_warning "OpenClaw CLI not found in PATH"
        return
    fi
    
    # Check gateway status
    if openclaw gateway status >/dev/null 2>&1; then
        print_success "Gateway: Running"
    else
        print_error "Gateway: Not running"
    fi
    
    # Check health
    local health
    health=$(openclaw health --json 2>/dev/null || echo '{"status":"unknown"}')
    echo "  Health: $(echo "$health" | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "unknown")"
    
    # Check version
    local version
    version=$(openclaw version 2>/dev/null || echo "unknown")
    echo "  Version: $version"
}

# Check for security updates (Linux)
check_updates() {
    print_section "System Updates"
    
    if command -v apt > /dev/null 2>&1; then
        local updates
        updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo "0")
        if [ "$updates" -gt 0 ]; then
            print_warning "$updates package(s) can be upgraded"
            echo "  Run: sudo apt update && sudo apt upgrade"
        else
            print_success "All packages up to date"
        fi
    elif command -v dnf > /dev/null 2>&1; then
        local updates
        updates=$(dnf check-update --quiet 2>/dev/null | wc -l || echo "0")
        if [ "$updates" -gt 0 ]; then
            print_warning "$updates package(s) can be upgraded"
        else
            print_success "All packages up to date"
        fi
    elif command -v brew > /dev/null 2>&1; then
        local updates
        updates=$(brew outdated 2>/dev/null | wc -l || echo "0")
        if [ "$updates" -gt 0 ]; then
            print_warning "$updates formula(s) outdated"
            echo "  Run: brew upgrade"
        else
            print_success "All packages up to date"
        fi
    else
        echo "  (Package manager not detected)"
    fi
}

# Generate summary report
generate_report() {
    local issues="$1"
    
    echo ""
    print_header "📋 SUMMARY REPORT"
    
    if [ "$issues" -eq 0 ]; then
        print_success "All systems healthy!"
    else
        print_error "$issues issue(s) detected - review above"
    fi
    
    echo ""
    echo "  Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "  Hostname: $(hostname)"
    echo "  OS: $(uname -s) $(uname -r)"
}

# Main function
main() {
    print_header "🏥 SYSTEM HEALTH MONITOR - $(date '+%Y-%m-%d %H:%M')"
    
    local issues=0
    
    # Run all checks
    check_disk || ((issues++))
    check_memory || ((issues++))
    check_load || ((issues++))
    check_uptime
    check_ports
    check_updates
    
    if [ "$CHECK_OPENCLAW" = "true" ]; then
        check_openclaw
    fi
    
    # Generate report
    generate_report "$issues"
    
    # Exit with appropriate code
    exit "$issues"
}

# Show help
show_help() {
    cat << 'EOF'
System Health Monitor

Usage: ./health-monitor.sh [options]

Options:
  -d, --disk-threshold %    Set disk usage alert threshold (default: 80)
  -m, --memory-threshold %  Set memory usage alert threshold (default: 90)
  -l, --load-threshold N    Set load average alert threshold (default: 2.0)
  --no-openclaw            Skip OpenClaw status check
  -h, --help               Show this help message

Examples:
  ./health-monitor.sh
  ./health-monitor.sh --disk-threshold 90 --memory-threshold 95
  ./health-monitor.sh --no-openclaw

Exit codes:
  0 - All checks passed
  N - Number of issues detected

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--disk-threshold)
            DISK_THRESHOLD="$2"
            shift 2
            ;;
        -m|--memory-threshold)
            MEMORY_THRESHOLD="$2"
            shift 2
            ;;
        -l|--load-threshold)
            LOAD_THRESHOLD="$2"
            shift 2
            ;;
        --no-openclaw)
            CHECK_OPENCLAW=false
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main
main
