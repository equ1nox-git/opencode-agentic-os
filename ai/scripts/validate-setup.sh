#!/bin/bash
# OpenCode Agentic Education OS - Validation Script
# Checks that everything is set up correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$(dirname "$AI_DIR")"
MACHINE=$(bash "$SCRIPT_DIR/detect-machine.sh")

echo "========================================"
echo "Validation Report"
echo "========================================"
echo ""

ERRORS=0
WARNINGS=0

# 1. Check folder structure
echo "Checking folder structure..."
for dir in profiles cache scripts router; do
    if [[ -d "$AI_DIR/$dir" ]]; then
        echo "  [OK] ai/$dir/"
    else
        echo "  [FAIL] ai/$dir/ missing"
        ((ERRORS++))
    fi
done

# 2. Check cache files
echo ""
echo "Checking cache files..."
for file in math-cache.json unit-conversions.json; do
    if [[ -f "$AI_DIR/cache/$file" ]]; then
        echo "  [OK] cache/$file"
    else
        echo "  [FAIL] cache/$file missing"
        ((ERRORS++))
    fi
done

# 3. Check machine profile
echo ""
echo "Checking machine profile..."
if [[ -f "$AI_DIR/profiles/$MACHINE.json" ]]; then
    echo "  [OK] profiles/$MACHINE.json"
    RAM=$(jq -r '.ram_gb' "$AI_DIR/profiles/$MACHINE.json")
    LOCAL=$(jq -r '.local_model.enabled' "$AI_DIR/profiles/$MACHINE.json")
    echo "       RAM: ${RAM}GB | Local model: $LOCAL"
else
    echo "  [FAIL] profiles/$MACHINE.json missing"
    ((ERRORS++))
fi

# 4. Check root configs
echo ""
echo "Checking root configs..."
if [[ -f "$CONFIG_DIR/opencode.json" ]]; then
    echo "  [OK] opencode.json"
else
    echo "  [WARN] opencode.json not found"
    ((WARNINGS++))
fi

if [[ -f "$CONFIG_DIR/rate-limit-fallback.json" ]]; then
    echo "  [OK] rate-limit-fallback.json"
else
    echo "  [WARN] rate-limit-fallback.json not found"
    ((WARNINGS++))
fi

# 5. Check education agents
echo ""
echo "Checking education agents..."
AGENTS=("education-router" "math-fast" "math-tutor-k12" "math-tutor-college" "science-tutor" "coding-tutor" "test-prep-sat" "answer-reviewer")
for agent in "${AGENTS[@]}"; do
    if [[ -f "$CONFIG_DIR/agents/$agent.md" ]]; then
        echo "  [OK] agents/$agent.md"
    else
        echo "  [WARN] agents/$agent.md missing"
        ((WARNINGS++))
    fi
done

# 6. Check Ollama (if local enabled)
LOCAL_ENABLED=$(jq -r '.local_model.enabled' "$AI_DIR/profiles/$MACHINE.json" 2>/dev/null || echo "false")
if [[ "$LOCAL_ENABLED" == "true" ]]; then
    echo ""
    echo "Checking Ollama..."
    if command -v ollama &> /dev/null; then
        echo "  [OK] Ollama installed"
        OLLAMA_MODEL=$(jq -r '.local_model.ollama_model' "$AI_DIR/profiles/$MACHINE.json")
        if ollama list | grep -q "$OLLAMA_MODEL"; then
            echo "  [OK] Model $OLLAMA_MODEL pulled"
        else
            echo "  [WARN] Model $OLLAMA_MODEL not pulled yet"
            ((WARNINGS++))
        fi
    else
        echo "  [WARN] Ollama not installed (run ollama-setup.sh)"
        ((WARNINGS++))
    fi
fi

# 7. Summary
echo ""
echo "========================================"
if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    echo "All checks passed!"
    echo "========================================"
    exit 0
else
    echo "Errors: $ERRORS | Warnings: $WARNINGS"
    echo "========================================"
    if [[ $ERRORS -gt 0 ]]; then
        exit 1
    fi
    exit 0
fi