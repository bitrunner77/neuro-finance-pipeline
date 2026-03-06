---
name: neuro-finance-research-agent
description: Research agent for the Neuro-Finance faceless channel. Analyzes AI trends, web signals, and X/Twitter data to identify emerging finance/psychology topics. Part of the Idea Mining workflow. Use when researching trending topics and market signals.
---

# Neuro-Finance Research Agent

Analyzes web and social signals to identify trending topics for the Neuro-Finance channel.

## Inputs

1. **AI Trends** — Emerging finance AI tools, automation
2. **Web Signals** — Google Trends, news, Reddit discussions
3. **X/Twitter** — Finance Twitter sentiment, viral threads

## Process

### Step 1: Trend Detection
- Monitor Google Trends for finance keywords
- Track Reddit r/wallstreetbets, r/personalfinance, r/Entrepreneur
- Scan X for viral finance threads

### Step 2: Signal Validation
- Cross-check multiple sources
- Verify trend longevity (not just a blip)
- Assess audience size

### Step 3: Content Opportunity
- Map trend to video format
- Identify unique angle
- Estimate production effort

## Output Format

```json
{
  "trends": [
    {
      "topic": "AI Trading Bots",
      "trend_velocity": "+340% (30 days)",
      "sources": ["X/Twitter", "Reddit", "Google Trends"],
      "content_angle": "Why AI bots fail (the psychology gap)",
      "confidence_score": 9.0,
      "urgency": "high (trending now)"
    }
  ]
}
```

## Tools

- `scripts/trend_scanner.py` — Multi-source trend detection
- `scripts/sentiment_analysis.py` — X/Twitter sentiment
- `scripts/validate_trend.py` — Check trend longevity