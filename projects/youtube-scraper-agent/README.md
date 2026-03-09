# YouTube Scraper Agent

Find viral video opportunities, research them, and write complete scripts — no API keys needed.

## What It Does

1. **Discovers** trending and high-performing videos in your target niches
2. **Analyzes** view velocity, engagement ratios, and viral indicators
3. **Researches** content gaps and unique angles
4. **Writes** complete video scripts with hooks, structure, and thumbnail concepts

## Installation

```bash
# Install dependencies
pip install yt-dlp

# Or run the setup script
python run.py  # Auto-installs yt-dlp if missing
```

## Usage

### Quick Start

```bash
cd /root/.openclaw/workspace/projects/youtube-scraper-agent
python run.py
```

This runs the full pipeline:
- Discovers 20+ video opportunities
- Generates discovery report
- Researches the top opportunity
- Writes a complete script

### Individual Modules

**Discovery only:**
```bash
python scraper.py
```

**Write a custom script:**
```bash
python script_writer.py
```

## How It Works

### Scoring Algorithm

Videos are scored (0-100) based on:

| Factor | Weight | Why It Matters |
|--------|--------|----------------|
| VPS Ratio | 30% | Views per subscriber — viral indicator |
| Views/Day | 25% | Current momentum |
| Recency | 20% | Fresh content = less competition |
| Duration | 15% | Sweet spot for monetization (8-15 min) |
| SEO Tags | 10% | Algorithm optimization |

**VPS Ratio Explained:**
- >10 = Viral (small channel, huge reach)
- 5-10 = Strong performer
- 2-5 = Good engagement
- <2 = Normal performance

### Target Niches

Default niches researched:
- AI tools tutorial
- SaaS startup
- No-code automation
- Productivity workflow
- Chrome extension
- Passive income
- Indie hacker

Edit `scraper.py` → `TARGET_NICHES` to customize.

## Output Files

| File | Description |
|------|-------------|
| `discovery-report-YYYY-MM-DD.md` | Top 10 opportunities with metrics |
| `researched-topic-YYYYMMDD.md` | Deep-dive on best opportunity |
| `script-[topic].md` | Complete video script ready to record |

## Script Template Includes

- **Hook** (30 sec): Pattern interrupt + curiosity gap
- **Intro** (30-60 sec): Credibility + promise
- **Main Content** (3-5 points): Value-dense teaching
- **Bonus Tactic**: Step-by-step actionable tip
- **CTA**: Subscribe, comment, next video
- **Thumbnail Concept**: Visual + text overlay ideas
- **Recording Notes**: Tone, pacing, B-roll suggestions
- **Tags & Metrics**: SEO and success benchmarks

## Customization

### Change Target Niches

Edit `scraper.py`:
```python
TARGET_NICHES = [
    "your niche 1",
    "your niche 2",
    # ...
]
```

### Adjust Scoring Weights

Edit `scorer_opportunity()` in `scraper.py` to change what signals matter most to you.

### Custom Script Parameters

Edit `script_writer.py` → `main()` to change:
- Topic
- Angle/positioning
- Key points
- Target duration

## Rate Limiting

This tool uses `yt-dlp` which scrapes YouTube directly. To avoid rate limits:
- Run once per hour max
- Use `--sleep-requests` if adding to cron
- Consider rotating User-Agent if scaling

## Troubleshooting

**"yt-dlp not found"**
```bash
pip install yt-dlp
```

**"No videos found"**
- Check internet connection
- YouTube may be rate-limiting — wait 30 minutes
- Try with VPN if region-blocked

**"Videos have 0 views"**
- YouTube sometimes returns partial data
- Retry in a few minutes

## Future Enhancements

- [ ] Comment sentiment analysis
- [ ] Competitor channel tracking
- [ ] Trend forecasting
- [ ] A/B thumbnail testing suggestions
- [ ] Integration with video editing tools

## License

MIT — Use freely, modify as needed.

---

*Built for the Empire. 🎬*
