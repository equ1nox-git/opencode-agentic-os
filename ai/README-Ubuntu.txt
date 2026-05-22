# OpenCode Agentic Education OS
## Ubuntu/Linux Setup Guide

### Quick Start (Copy-Paste These Commands)

```bash
# 1. Plug in USB and copy files
cp -r /media/$USER/sandisk/opencode-agentic-os/* ~/.config/opencode/

# 2. Run the installer
bash ~/.config/opencode/ai/install.sh

# 3. Validate everything works
bash ~/.config/opencode/ai/scripts/validate-setup.sh
```

### What's Included

| Component | Description |
|-----------|-------------|
| `ai/profiles/lenovo.json` | Optimized for 8GB RAM (cloud-only) |
| `ai/cache/` | Precomputed math tables for instant answers |
| `ai/scripts/` | Install, validate, benchmark, detect |
| `agents/*.md` | 8 education specialist agents |
| `opencode.json` | Master config with all agents registered |
| `rate-limit-fallback.json` | Quality-ranked model fallback |

### Machine Profile: Lenovo Ideapad 320

Your device is configured for **cloud-only operation**:
- No local Ollama (insufficient RAM)
- Uses fastest cloud models via OpenCode/Groq/OpenRouter
- Simple math queries bypass LLM entirely (<100ms)

### Test Commands

After installation, test with these queries in OpenCode:

```
sqrt 196                    → instant (math-fast)
cbrt -125                   → instant (math-fast)
convert 5 miles to km       → instant (math-fast)
solve for x: 2x+5=13        → math-tutor-k12
derivative of x^2           → math-tutor-college
explain photosynthesis      → science-tutor
python for loop             → coding-tutor
SAT reading strategy        → test-prep-sat
```

### API Keys Required (Free Tiers)

Your config uses these providers. Make sure you have keys:
- **OpenCode**: Built-in (free models)
- **Groq**: https://groq.com (free tier)
- **OpenRouter**: https://openrouter.ai (free tier)
- **Cloudflare Workers AI**: https://workers.cloudflare.com (free tier)

### Troubleshooting

**Q: SSH connection closes immediately**  
A: Check `PasswordAuthentication yes` in `/etc/ssh/sshd_config`

**Q: Ollama install fails**  
A: This machine doesn't run local models (8GB RAM). Skip Ollama.

**Q: Models are slow**  
A: Check internet connection. Fallback system will try alternative providers.

### Support

For issues, run the validator:
```bash
bash ~/.config/opencode/ai/scripts/validate-setup.sh
```

Built: 2026-04-26 | Version: 1.0