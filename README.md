# Neuro-Finance Pipeline

[![Pipeline](https://github.com/bitrunner77/neuro-finance-pipeline/actions/workflows/pipeline.yml/badge.svg)](https://github.com/bitrunner77/neuro-finance-pipeline/actions/workflows/pipeline.yml)

Automated video production pipeline for the Neuro-Finance YouTube channel — where behavioral finance meets psychology.

## 🎯 What This Does

1. **Idea Mining** — AI agents scan YouTube, Reddit, and X for trending behavioral finance topics
2. **Content Scoring** — Ranks ideas by engagement potential and competition
3. **Script Generation** — AI writes video scripts based on top-ranked ideas
4. **Video Production** — FFmpeg pipeline for thumbnails, clips, and post-processing

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/bitrunner77/neuro-finance-pipeline.git
cd neuro-finance-pipeline

# Set up environment
cp .env.example .env
# Edit .env with your API keys

# Install dependencies
pip install -r requirements.txt

# Run idea mining
python agents/idea_mining.py

# Generate thumbnails from video
python scripts/video_pipeline.py video.mp4 --thumbnails --out-dir ./thumbs
```

## 📁 Structure

```
neuro-finance-pipeline/
├── agents/              # AI agents for research and scoring
│   ├── idea_mining.py      # Main idea mining orchestrator
│   ├── RESEARCH-AGENT.md   # Research agent spec
│   ├── SCORING-AGENT.md    # Scoring agent spec
│   └── YT-AGENT.md         # YouTube analysis agent spec
├── scripts/             # Production scripts
│   ├── video_pipeline.py   # FFmpeg video processing
│   └── generate-thumbnails.sh
├── templates/           # Video templates and assets
├── output/              # Generated content (gitignored)
└── .github/workflows/   # CI/CD automation
```

## 🤖 GitHub Actions

| Workflow | Trigger | Description |
|----------|---------|-------------|
| **Validate** | Push/PR | Lint and test Python scripts |
| **Idea Mining** | Daily 6 AM UTC | Run agents and commit results |
| **Test Pipeline** | Manual | Test FFmpeg video processing |
| **Release** | Version tag | Create GitHub release |

## 🔧 Required Secrets

Set these in GitHub repo Settings → Secrets:

- `OPENAI_API_KEY` — For script generation
- `YOUTUBE_API_KEY` — For comment/competitor analysis
- `ANTHROPIC_API_KEY` — Alternative LLM (optional)

## 📝 Content Pillars

1. **Cognitive Biases in Trading** — Why your brain sabotages trades
2. **Market Psychology** — Fear, greed, and herd behavior
3. **Money Mindset** — Scarcity vs. abundance, wealth psychology

## 📊 Success Metrics

| Milestone | Target | Timeline |
|-----------|--------|----------|
| First video | 1 published | Week 1 |
| 10 videos | 10 published | Month 1 |
| Monetization | 4K watch hours | Month 3 |
| $1K/month | Ad + affiliate | Month 4 |

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch
3. Make changes
4. Push and open a PR

The CI will validate your Python code automatically.

## 📜 License

MIT — See [LICENSE](LICENSE) for details.

---

*Part of the Money Business Empire*
