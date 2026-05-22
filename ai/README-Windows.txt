# OpenCode Agentic Education OS
## Windows 11 Setup Guide

### Quick Start (PowerShell as Administrator)

```powershell
# 1. Plug in USB and copy files
$usbPath = (Get-Volume -FileSystemLabel sandisk).DriveLetter + ":\opencode-agentic-os"
$destPath = "$env:USERPROFILE\.config\opencode"
Copy-Item -Path "$usbPath\*" -Destination $destPath -Recurse -Force

# 2. Set execution policy for this session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# 3. Run the install script (PowerShell version)
& "$destPath\ai\install-windows.ps1"

# 4. Validate
& "$destPath\ai\scripts\validate-windows.ps1"
```

### What's Included

| Component | Description |
|-----------|-------------|
| `ai/profiles/desktop.json` | Optimized for 16GB RAM + RX 5700XT |
| `ai/cache/` | Precomputed math tables for instant answers |
| `ai/scripts/` | Install, validate, benchmark, detect |
| `agents/*.md` | 8 education specialist agents |
| `opencode.json` | Master config with all agents registered |
| `rate-limit-fallback.json` | Quality-ranked model fallback |

### Machine Profile: Tower (Desktop)

Your device is configured for **hybrid operation**:
- Local Ollama with `qwen2.5-coder:7b` for medium complexity
- Cloud models for complex tasks
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

### Ollama Setup (Local Models)

To install local models on this machine:

```powershell
# Option 1: Using install script (recommended)
& "$env:USERPROFILE\.config\opencode\ai\scripts\ollama-setup.ps1"

# Option 2: Manual install
# Download from https://ollama.com/download/windows
# Install and run: ollama pull qwen2.5-coder:7b
```

### Troubleshooting

**Q: SSH server not working**  
A: Open PowerShell as Admin and run: `Restart-Service sshd`

**Q: Scripts won't run**  
A: Make sure you run `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`

**Q: Ollama not found**  
A: Download from https://ollama.com/download/windows and install

**Q: Git Bash vs PowerShell**  
A: This package includes PowerShell scripts. Git Bash users can use the `.sh` scripts.

### Support

For issues, run the validator:
```powershell
& "$env:USERPROFILE\.config\opencode\ai\scripts\validate-windows.ps1"
```

Built: 2026-04-26 | Version: 1.0