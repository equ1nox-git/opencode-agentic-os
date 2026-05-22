# OpenCode Agentic OS

35 specialist AI agents for [OpenCode](https://opencode.ai) — drop them in and every task routes to the right expert automatically.

Education tutors, senior engineers, DevOps automators, sales coaches, product managers, QA specialists. Each agent has a focused role, a clear system prompt, and fits the OpenCode agent spec out of the box. A zero-LLM math calculator answers arithmetic and unit conversions in under 100ms without touching a model at all.

![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)
![Agents](https://img.shields.io/badge/agents-35-6366f1?style=flat-square)
![OpenCode](https://img.shields.io/badge/platform-OpenCode-black?style=flat-square)
![Models](https://img.shields.io/badge/models-cloud%20%7C%20local-orange?style=flat-square)

---

## What it does

**35 focused specialists, not one generalist.** A single catch-all model tries to do everything adequately. This system gives each domain its own expert — a coding tutor who only teaches, a deal strategist who only closes, a QA agent who only finds bugs.

**Zero-LLM math.** `sqrt 196`, `cbrt -125`, `convert 5 miles to km` — answered instantly from precomputed lookup tables. No API call, no latency, no hallucination.

**Quality-ranked model fallback.** Behind each agent is a fallback chain ranked by benchmark score. Primary + parallel models fire simultaneously (`race` mode). If both fail, it drops to a Groq fallback, then emergency Llama 70B. You always get a response.

**Per-device optimization.** Ships with three profiles: MacBook M4 (24 GB, hybrid local+cloud), desktop (16 GB, lighter local models), and a cloud-only profile for low-RAM machines. Install detects your hardware automatically.

**One-command install.** A single script copies agents, config, and cache files to `~/.config/opencode/`. Works on Mac, Linux, and Windows.

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        YOUR QUERY                            │
└──────────────────────────────┬───────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                     EDUCATION ROUTER                         │
│                                                              │
│   regex match (0ms) → math-fast    ← sqrt / cbrt / convert  │
│   regex match       → math-k12     ← algebra / fractions    │
│   regex match       → math-college ← calculus / proofs      │
│   LLM classify      → science      ← physics / chemistry    │
│   LLM classify      → coding       ← python / algorithms    │
│   LLM classify      → test-prep    ← SAT / ACT              │
└──────────────────────────────┬───────────────────────────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
      ┌─────────────────────┐  ┌───────────────────────┐
      │    ZERO-LLM PATH    │  │     LLM AGENT PATH    │
      │                     │  │                       │
      │  math-cache.json    │  │  PRIMARY + PARALLEL   │
      │  unit-conv.json     │  │  models fire (race)   │
      │                     │  │                       │
      │  < 100ms            │  │  answer-reviewer      │
      │  exact values only  │  │  quality gates output │
      └─────────────────────┘  └───────────────────────┘
```

---

## Agents

### Education (8 agents)

| Agent | Role |
|-------|------|
| `education-router` | Classifies query, dispatches to right tutor |
| `math-fast` | Instant calculator — zero LLM, exact values |
| `math-tutor-k12` | Algebra, geometry, arithmetic, fractions |
| `math-tutor-college` | Calculus, linear algebra, proofs, ODEs |
| `science-tutor` | Physics, chemistry, biology |
| `coding-tutor` | Programming, algorithms, data structures |
| `test-prep-sat` | SAT/ACT strategy and drill |
| `answer-reviewer` | Quality gate — checks every tutor response |

### Engineering (8 agents)

| Agent | Role |
|-------|------|
| `senior-developer` | Full-stack implementation — Laravel, Livewire, Three.js |
| `frontend-developer` | React, Vue, Angular, CSS, performance |
| `backend-architect` | System design, APIs, databases, cloud |
| `code-reviewer` | Correctness, security, maintainability review |
| `devops-automator` | CI/CD, infrastructure, container orchestration |
| `security-engineer` | Threat modeling, vulnerability assessment, secure code review |
| `ai-engineer` | ML model development, deployment, integration |
| `database-optimizer` | Schema design, query tuning, indexing — Postgres, MySQL |

### Sales (4 agents)

| Agent | Role |
|-------|------|
| `sales-coach` | Rep development, pipeline review, call coaching |
| `deal-strategist` | MEDDPICC qualification, competitive positioning |
| `sales-engineer` | Technical discovery, demo engineering, POC scoping |
| `account-strategist` | Land-and-expand, QBR facilitation, NRR |

### Marketing (4 agents)

| Agent | Role |
|-------|------|
| `growth-hacker` | User acquisition, viral loops, funnel optimization |
| `content-creator` | Editorial calendar, copy, multi-platform campaigns |
| `seo-specialist` | Technical SEO, content optimization, link building |
| `paid-media-auditor` | Google Ads, Meta, Microsoft Ads — 200+ checkpoint audit |

### Product & Design (3 agents)

| Agent | Role |
|-------|------|
| `product-manager` | Discovery, roadmap, go-to-market, outcome measurement |
| `ui-designer` | Design systems, component libraries, pixel-perfect UI |
| `ux-researcher` | Usability testing, behavior analysis, insights |

### Data (2 agents)

| Agent | Role |
|-------|------|
| `data-engineer` | Pipelines, lakehouse architecture, data infrastructure |
| `analytics-reporter` | Dashboards, KPIs, statistical analysis, business insights |

### Delivery (4 agents)

| Agent | Role |
|-------|------|
| `project-shepherd` | Cross-functional coordination, timeline management |
| `jira-workflow-steward` | Git workflow enforcement, traceable commits, release branches |
| `evidence-collector` | QA — screenshot-based bug finding, visual proof required |
| `reality-checker` | Production readiness gate — defaults to NEEDS WORK |

### Orchestrators (2 agents)

| Agent | Role |
|-------|------|
| `plan` | Primary planner — breaks down tasks, delegates to specialists |
| `build` | Primary builder — writes code, delegates to specialists |

---

## Model fallback

Quality-ranked, benchmark-scored, task-aware:

| Tier | Coding | Reasoning | Tutoring |
|------|--------|-----------|----------|
| Primary | MiniMax M2.5 (80.2%) | GLM 5 (77.8%) | Kimi K2.5 (76.8%) |
| Parallel | GLM 5 + Kimi | MiniMax + Kimi | GLM 5 + MiniMax |
| Fallback | Groq Qwen3 480B | OpenRouter QwQ | OpenRouter QwQ |
| Emergency | Groq Llama 70B | Groq Llama 70B | Groq Llama 70B |

Mode: `race` — primary and parallel models fire simultaneously, first clean response wins.

---

## Quick start

### Mac
```bash
git clone https://github.com/equ1nox-git/opencode-agentic-os.git
bash opencode-agentic-os/ai/install.sh
```

### Linux
```bash
git clone https://github.com/equ1nox-git/opencode-agentic-os.git
cd opencode-agentic-os
bash ai/install.sh
```

### Windows 11
```
Double-click install-windows.bat
```

Then open OpenCode and test:
```
sqrt 196              → instant: 14
cbrt -125             → instant: -5
convert 5 miles to km → instant: 8.04672
explain derivative    → college math tutor
python for loop       → coding tutor
```

---

## Per-device profiles

| Device | RAM | Local model | Cloud fallback |
|--------|-----|-------------|----------------|
| MacBook M4 | 24 GB | qwen2.5-coder:14b | Yes |
| Desktop (R5 3600) | 16 GB | qwen2.5-coder:7b | Yes |
| Lenovo IdeaPad | 8 GB | None | Cloud-only |

The install script detects your hardware and applies the right profile automatically.

---

## What gets installed

```
~/.config/opencode/
├── opencode.json              ← All 35 agents registered
├── rate-limit-fallback.json   ← Quality-ranked model chains
└── agents/                    ← OpenCode discovers these automatically
    ├── education-router.md
    ├── math-fast.md
    ├── math-tutor-k12.md
    ├── math-tutor-college.md
    ├── science-tutor.md
    ├── coding-tutor.md
    ├── test-prep-sat.md
    └── answer-reviewer.md
    └── ...
```

---

## Requirements

- [OpenCode](https://opencode.ai) installed
- API keys for your preferred cloud providers (optional — local models work too)

---

## License

MIT
