#!/bin/bash
# OpenCode Agentic Education OS - Universal Installer
# Works on macOS, Linux, and Windows (Git Bash/WSL)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"

echo "========================================"
echo "OpenCode Agentic Education OS Installer"
echo "========================================"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == MINGW* ]] || [[ "$OSTYPE" == CYGWIN* ]] || [[ "$OSTYPE" == MSYS* ]]; then
    OS="windows"
fi

echo "Detected OS: $OS"

# Create config directory
mkdir -p "$CONFIG_DIR"

# Copy root configs
echo "Installing config files..."
cp "$SCRIPT_DIR/../opencode.json" "$CONFIG_DIR/"
cp "$SCRIPT_DIR/../rate-limit-fallback.json" "$CONFIG_DIR/"

# Copy AI workspace
echo "Installing AI workspace..."
mkdir -p "$CONFIG_DIR/ai"
cp -r "$SCRIPT_DIR"/* "$CONFIG_DIR/ai/"

# Copy agents
echo "Installing agent definitions..."
mkdir -p "$CONFIG_DIR/agents"
cp -r "$SCRIPT_DIR/../agents"/* "$CONFIG_DIR/agents/"

# Detect machine and show profile
if [[ -f "$CONFIG_DIR/ai/scripts/detect-machine.sh" ]]; then
    MACHINE=$(bash "$CONFIG_DIR/ai/scripts/detect-machine.sh")
    echo ""
    echo "Machine profile: $MACHINE"
    
    if [[ -f "$CONFIG_DIR/ai/profiles/$MACHINE.json" ]]; then
        RAM=$(jq -r '.ram_gb' "$CONFIG_DIR/ai/profiles/$MACHINE.json" 2>/dev/null || echo "?")
        LOCAL=$(jq -r '.local_model.enabled' "$CONFIG_DIR/ai/profiles/$MACHINE.json" 2>/dev/null || echo "false")
        echo "RAM: ${RAM}GB"
        echo "Local model: $LOCAL"
    fi
fi

# Run validation
echo ""
echo "Running validation..."
if [[ -f "$CONFIG_DIR/ai/scripts/validate-setup.sh" ]]; then
    bash "$CONFIG_DIR/ai/scripts/validate-setup.sh" || true
fi

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Test commands:"
echo "  sqrt 196                    -> instant"
echo "  cbrt -125                   -> instant"
echo "  convert 5 miles to km       -> instant"
echo "  explain derivative          -> college tutor"
echo "  python for loop             -> coding tutor"
echo ""

# OS-specific next steps
case $OS in
    macos)
        echo "macOS setup: Run 'opencode' to start"
        ;;
    linux)
        echo "Linux setup: Run 'opencode' to start"
        ;;
    windows)
        echo "Windows setup:"
        echo "  1. Install Ollama from https://ollama.com/download/windows"
        echo "  2. Run: ollama pull qwen2.5-coder:7b"
        echo "  3. Open PowerShell and run: opencode"
        ;;
esac

echo ""

exit 0