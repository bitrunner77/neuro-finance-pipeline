---
name: neuro-finance-yt-agent
description: YouTube-focused agent for the Neuro-Finance faceless channel. Analyzes YouTube comments, competitor videos, and audience signals to identify high-potential video topics. Part of the Idea Mining workflow. Use when researching video ideas for finance/psychology content.
---

# Neuro-Finance YT Agent

Analyzes YouTube signals to identify video opportunities for the Neuro-Finance faceless channel.

## Inputs

1. **YouTube Comments** — Audience pain points, questions, requests
2. **Competitor Videos** — What's working in finance/psychology niche
3. **Trending Topics** — Real-time finance trends

## Process

### Step 1: Comment Mining
- Search finance channel comments for:
  - "Can you make a video about..."
  - "I don't understand..."
  - "What about [topic]?"
  - High-engagement threads

### Step 2: Competitor Analysis
- Identify top-performing finance/psychology videos
- Analyze thumbnails, titles, hooks
- Note content gaps (what they missed)

### Step 3: Trend Synthesis
- Cross-reference comments + competitors
- Identify recurring themes
- Score by: demand × uniqueness × production feasibility

## Output Format

```json
{
  "ideas": [
    {
      "title": "Why Your Brain Sabotages Your Trades",
      "hook": "90% of traders lose money because of this cognitive bias...",
      "source_signals": ["comments", "competitor_gap"],
      "confidence_score": 8.5,
      "estimated_views": "50K-100K",
      "production_complexity": "medium"
    }
  ]
}
```

## Tools

- `scripts/analyze_comments.py` — Parse YouTube comments
- `scripts/competitor_scan.py` — Analyze competitor videos
- `scripts/score_ideas.py` — Rank by confidence