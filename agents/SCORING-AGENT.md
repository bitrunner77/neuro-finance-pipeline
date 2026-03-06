---
name: neuro-finance-scoring-agent
description: Scoring agent for the Neuro-Finance faceless channel. Cross-references signals from YT Agent and Research Agent, ranks video ideas by confidence. Part of the Idea Mining workflow. Use when synthesizing multiple signals into ranked video ideas.
---

# Neuro-Finance Scoring Agent

Cross-references YT Agent and Research Agent outputs to rank video ideas by confidence.

## Inputs

1. **YT Agent Output** — YouTube-specific signals
2. **Research Agent Output** — Web/trend signals

## Scoring Criteria

| Factor | Weight | Description |
|--------|--------|-------------|
| **Demand** | 30% | Audience interest, search volume |
| **Uniqueness** | 25% | Differentiation from competitors |
| **Trend Velocity** | 20% | How fast is this trending |
| **Production Feasibility** | 15% | Can we make this quickly |
| **Monetization Potential** | 10% | CPM, affiliate opportunities |

## Scoring Formula

```
Confidence Score = (
  Demand × 0.30 +
  Uniqueness × 0.25 +
  Trend Velocity × 0.20 +
  Production Feasibility × 0.15 +
  Monetization × 0.10
) × 10
```

## Output: Idea Mining Brief

```markdown
# Idea Mining Brief — YYYY-MM-DD

## Top 5 Video Ideas

### 1. [Title] — Score: 9.2/10
**Hook:** [One-sentence hook]
**Sources:** YT comments + X trend + Competitor gap
**Why it works:** [Explanation]
**Production notes:** [Script angle, visuals needed]

### 2. [Title] — Score: 8.7/10
...

## Batch Production Plan
- Priority 1: Ideas scoring 9.0+
- Priority 2: Ideas scoring 8.0-8.9
- Priority 3: Ideas scoring 7.0-7.9

## Content Calendar Suggestion
- Monday: [Idea 1]
- Wednesday: [Idea 2]
- Friday: [Idea 3]
```

## Tools

- `scripts/score_ideas.py` — Calculate confidence scores
- `scripts/cross_reference.py` — Match signals across sources
- `scripts/generate_brief.py` — Create Idea Mining Brief