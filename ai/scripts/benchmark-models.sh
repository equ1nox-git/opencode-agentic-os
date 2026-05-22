#!/bin/bash
# OpenCode Agentic Education OS - Model Benchmark
# Tests latency for available models on this machine

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_DIR="$(dirname "$SCRIPT_DIR")"
MACHINE=$(bash "$SCRIPT_DIR/detect-machine.sh")

echo "========================================"
echo "Model Latency Benchmark"
echo "Machine: $MACHINE"
echo "========================================"
echo ""

# Test query
QUERY="What is 2+2?"

# Cloud models to test
MODELS=(
    "opencode:minimax-m2.5-free"
    "opencode:glm-5-free"
    "opencode:kimi-k2.5-free"
    "opencode:big-pickle"
    "groq:llama-3.3-70b-versatile"
)

for model in "${MODELS[@]}"; do
    PROVIDER=$(echo "$model" | cut -d':' -f1)
    MODEL_ID=$(echo "$model" | cut -d':' -f2-)
    
    echo "Testing: $PROVIDER/$MODEL_ID"
    
    START=$(date +%s%N)
    
    # Try a simple API call (this will vary by provider)
    # Placeholder - actual implementation depends on OpenCode CLI capabilities
    if opencode chat --model "$model" --message "$QUERY" > /dev/null 2>&1; then
        END=$(date +%s%N)
        LATENCY=$(( (END - START) / 1000000 ))
        echo "  Result: ${LATENCY}ms"
    else
        echo "  Result: FAILED or not available"
    fi
    echo ""
done

# Test local Ollama if available
LOCAL_ENABLED=$(jq -r '.local_model.enabled' "$AI_DIR/profiles/$MACHINE.json" 2>/dev/null || echo "false")
if [[ "$LOCAL_ENABLED" == "true" ]] && command -v ollama &> /dev/null; then
    OLLAMA_MODEL=$(jq -r '.local_model.ollama_model' "$AI_DIR/profiles/$MACHINE.json")
    echo "Testing local: ollama/$OLLAMA_MODEL"
    
    START=$(date +%s%N)
    if ollama run "$OLLAMA_MODEL" "$QUERY" > /dev/null 2>&1; then
        END=$(date +%s%N)
        LATENCY=$(( (END - START) / 1000000 ))
        echo "  Result: ${LATENCY}ms"
    else
        echo "  Result: FAILED"
    fi
fi

echo ""
echo "Benchmark complete."

exit 0