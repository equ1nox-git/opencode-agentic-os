#!/bin/bash
# OpenCode Agentic Education OS - Machine Detector
# Detects which machine this is running on and outputs the profile name

set -e

get_machine_type() {
    local UNAME=$(uname -s)
    local ARCH=$(uname -m)
    local RAM_GB=$(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1024 / 1024 / 1024))
    
    # macOS detection
    if [[ "$UNAME" == "Darwin" ]]; then
        local CPU=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "unknown")
        # Check for Apple Silicon (M-series)
        if [[ "$CPU" == *"Apple"* ]] || [[ "$ARCH" == "arm64" ]]; then
            echo "macbook"
            return 0
        fi
    fi
    
    # Linux detection
    if [[ "$UNAME" == "Linux" ]]; then
        local RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo 0)
        RAM_GB=$((RAM_KB / 1024 / 1024))
        
        # Check for Lenovo Ideapad 320
        if [[ -f /sys/class/dmi/id/product_name ]]; then
            local PRODUCT=$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo "")
            if [[ "$PRODUCT" == *"ideapad"* ]] || [[ "$PRODUCT" == *"320"* ]]; then
                echo "lenovo"
                return 0
            fi
        fi
        
        # Check for specific CPU (AMD A12-9720P)
        local CPU_INFO=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d':' -f2 | xargs || echo "")
        if [[ "$CPU_INFO" == *"A12-9720P"* ]] || [[ "$RAM_GB" -lt 12 ]]; then
            echo "lenovo"
            return 0
        fi
        
        # Generic low-RAM Linux
        if [[ "$RAM_GB" -lt 12 ]]; then
            echo "lenovo"
            return 0
        fi
        
        # Higher RAM Linux desktop
        echo "desktop"
        return 0
    fi
    
    # Windows detection (via Git Bash, WSL, or MSYS)
    if [[ "$UNAME" == MINGW* ]] || [[ "$UNAME" == CYGWIN* ]] || [[ "$UNAME" == MSYS* ]]; then
        echo "desktop"
        return 0
    fi
    
    # WSL detection
    if [[ -f /proc/version ]] && grep -q Microsoft /proc/version 2>/dev/null; then
        echo "desktop"
        return 0
    fi
    
    # Fallback: use RAM as heuristic
    if [[ "$RAM_GB" -lt 12 ]]; then
        echo "lenovo"
    else
        echo "desktop"
    fi
}

MACHINE=$(get_machine_type)
echo "$MACHINE"
exit 0