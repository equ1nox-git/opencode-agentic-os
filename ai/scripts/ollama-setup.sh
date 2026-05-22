#!/bin/bash
# OpenCode Agentic Education OS - Ollama Setup
# Installs Ollama and pulls the appropriate model for this machine

set -e

MACHINE=$(bash "$(dirname "$0")/detect-machine.sh")
AI_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OLLAMA_MODEL=$(jq -r '.local_model.ollama_model' "$AI_DIR/profiles/$MACHINE.json" 2>/dev/null || echo "")

if [[ -z "$OLLAMA_MODEL" ]] || [[ "$OLLAMA_MODEL" == "null" ]]; then
    echo "No local model configured for $MACHINE. Skipping Ollama setup."
    exit 0
fi

echo "Setting up Ollama for $MACHINE..."
echo "Target model: $OLLAMA_MODEL"

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. Installing..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install ollama
        else
            echo "Homebrew not found. Please install from https://ollama.com/download/mac"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -fsSL https://ollama.com/install.sh | sh
    else
        echo "Unsupported OS: $OSTYPE"
        echo "Please install Ollama manually from https://ollama.com/download"
        exit 1
    fi
else
    echo "Ollama already installed."
fi

# Start Ollama service if not running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama service..."
    ollama serve &
    sleep 3
fi

# Pull the model
echo "Pulling model: $OLLAMA_MODEL"
ollama pull "$OLLAMA_MODEL"

echo "Ollama setup complete!"
echo "Model: $OLLAMA_MODEL"
echo "Test: ollama run $OLLAMA_MODEL"

exit 0