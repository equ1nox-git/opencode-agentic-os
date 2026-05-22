# OpenCode Agentic Education OS

A unified agentic workflow system for education with intelligent routing, quality-ranked model fallback, and per-device optimization.

## 🎯 What This Is

This system adds 8 education specialist agents to your OpenCode setup:

| Agent | Purpose | Speed |
|-------|---------|-------|
| `education-router` | Detects subject + level | ~100ms |
| `math-fast` | Calculator + conversions | **<100ms (zero LLM)** |
| `math-tutor-k12` | K-12 math (algebra, geometry) | ~3-5s |
| `math-tutor-college` | College math (calculus, proofs) | ~3-5s |
| `science-tutor` | Physics, chemistry, biology | ~3-5s |
| `coding-tutor` | Programming education | ~3-5s |
| `test-prep-sat` | SAT/ACT strategies | ~3-5s |
| `answer-reviewer` | Quality gate on every response | ~1-2s |

## 🚀 Quick Start

### macOS
```bash
bash ~/.config/opencode/ai/install.sh
```

### Ubuntu/Linux (Ideapad)
See `README-Ubuntu.txt`

### Windows 11 (Tower)
See `README-Windows.txt`

## 📁 Folder Structure

```
~/.config/opencode/
├── opencode.json                    ← Master config (all agents registered)
├── rate-limit-fallback.json         ← Quality-ranked fallback
├── ai/                              ← Our unified workspace
│   ├── profiles/
│   │   ├── macbook.json             ← M4, 24GB, local 14B model
│   │   ├── desktop.json             ← R5 3600, 16GB, local 7B model
│   │   └── lenovo.json              ← 8GB RAM, cloud-only
│   ├── cache/
│   │   ├── math-cache.json          ← Perfect squares, cubes, fractions
│   │   └── unit-conversions.json    ← Common conversions
│   ├── router/
│   │   └── keywords.json            ← Regex routing patterns
│   ├── scripts/
│   │   ├── install.sh               ← One-command setup
│   │   ├── detect-machine.sh        ← Auto-detect device
│   │   ├── validate-setup.sh        ← Check everything
│   │   ├── ollama-setup.sh          ← Install local models
│   │   └── benchmark-models.sh      ← Test latency
│   ├── README-Ubuntu.txt            ← Linux setup guide
│   └── README-Windows.txt           ← Windows setup guide
└── agents/                          ← OpenCode discovers these
    ├── education-router.md
    ├── math-fast.md
    ├── math-tutor-k12.md
    ├── math-tutor-college.md
    ├── science-tutor.md
    ├── coding-tutor.md
    ├── test-prep-sat.md
    └── answer-reviewer.md
```

## 🔄 Model Fallback Strategy

Quality-ranked, task-aware:

| Tier | Coding | Reasoning | Tutoring |
|------|--------|-----------|----------|
| Primary | MiniMax M2.5 (80.2%) | GLM 5 (77.8%) | Kimi K2.5 (76.8%) |
| Parallel | GLM 5 + Kimi | MiniMax + Kimi | GLM 5 + MiniMax |
| Fallback | Groq Qwen3 480B | OpenRouter QwQ | OpenRouter QwQ |
| Emergency | Groq Llama 70B | Groq Llama 70B | Groq Llama 70B |

**Mode**: `race` — Fire primary + parallel simultaneously, first good response wins.

## 🧪 Testing

After installation, try these:

```
sqrt 196                    → instant: 14
cbrt -125                   → instant: -5
convert 5 miles to km       → instant: 8.04672
(-4)^2                      → instant: 16
187 - 312                   → instant: -125

explain derivative          → college tutor
python for loop             → coding tutor
SAT strategy                → test prep
```

## 🔧 Per-Device Configs

| Device | RAM | Local Model | Strategy |
|--------|-----|-------------|----------|
| MacBook Neo (M4) | 24GB | qwen2.5-coder:14b | Hybrid (local + cloud) |
| Desktop (R5 3600) | 16GB | qwen2.5-coder:7b | Hybrid (local + cloud) |
| Ideapad 320 | 8GB | None | Cloud-only |

## 📝 Changelog

### v1.0 (2026-04-26)
- Initial release
- 8 education agents
- 3 machine profiles
- Quality-ranked fallback
- Zero-LLM math-fast agent

---

Built with OpenCode | Agentic Education OS v1.0