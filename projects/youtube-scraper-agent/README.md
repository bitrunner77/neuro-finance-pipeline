# YouTube Scraper Agent — Cost Analysis Channel Edition

Find viral product cost breakdown opportunities, research them, and write complete cost analysis scripts — no API keys needed.

## What It Does

1. **Discovers** trending cost breakdown and "how much does it cost" videos
2. **Analyzes** view velocity, engagement ratios, and viral indicators
3. **Researches** content gaps and unique angles for cost analysis
4. **Writes** complete cost breakdown scripts with:
   - BOM (Bill of Materials) sections
   - Manufacturing cost analysis
   - R&D amortization breakdowns
   - Marketing & distribution costs
   - Profit margin calculations
   - Thumbnail concepts with price contrast

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
- Discovers 20+ cost breakdown video opportunities
- Generates discovery report
- Researches the top opportunity
- Writes a complete cost analysis script template

### Individual Modules

**Discovery only:**
```bash
python scraper.py
```

**Write a custom cost analysis script:**
```bash
python script_writer_cost.py
```

## How It Works

### Scoring Algorithm (Cost Analysis Optimized)

Videos are scored (0-100) based on:

| Factor | Weight | Why It Matters |
|--------|--------|----------------|
| Cost Keywords | 25% | "cost", "breakdown", "how much", "expensive" in title/desc |
| VPS Ratio | 25% | Views per subscriber — viral indicator |
| Views/Day | 20% | Current momentum |
| Recency | 15% | Fresh cost breakdowns of new products = high search |
| Duration | 15% | Sweet spot for depth (10-20 min) |

### Target Niches (Cost Analysis Focused)

- "how much does it cost to make"
- "product cost breakdown"
- "manufacturing cost analysis"
- "why is [product] so expensive"
- "cost of goods sold breakdown"
- "supply chain cost analysis"
- Product-specific: iPhone, Tesla, sneakers, coffee, airlines, pharma

Edit `scraper.py` → `TARGET_NICHES` to customize.

## Cost Analysis Script Template Includes

- **Hook (45 sec):** Price shock + curiosity gap
- **Intro (45-90 sec):** Research methodology + agenda
- **Bill of Materials:** Component-by-component cost breakdown
- **Manufacturing:** Location, labor, assembly costs
- **R&D:** Amortized research costs per unit
- **Marketing & Distribution:** Ads, retail, shipping
- **Final Breakdown:** Complete cost table with margins
- **The Bigger Picture:** Industry context, competitor comparison
- **Verdict:** Is it worth the price?
- **Thumbnail:** Price contrast visual (retail vs. cost)

## Output Files

| File | Description |
|------|-------------|
| `discovery-report-YYYY-MM-DD.md` | Top 10 cost breakdown opportunities |
| `researched-topic-YYYYMMDD.md` | Deep-dive on best opportunity |
| `script-cost-breakdown-[product].md` | Complete cost analysis script |

## Research Sources to Verify

Before recording, check:
- **iFixit** — Teardowns and component identification
- **TechInsights** — Detailed BOM cost estimates
- **Company annual reports** — R&D spending, unit sales
- **Supply chain reports** — Manufacturing locations, labor costs
- **Industry analysts** — Counterpoint Research, Omdia

## Customization

### Change Target Niches

Edit `scraper.py`:
```python
TARGET_NICHES = [
    "your cost niche 1",
    "your cost niche 2",
    # ...
]
```

### Adjust Scoring Weights

Edit `scorer_opportunity()` in `scraper.py` to prioritize different signals.

### Custom Script Parameters

Edit `script_writer_cost.py` → `main()` to change:
- Product name
- Retail price
- Estimated cost
- Key components
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

## Future Enhancements

- [ ] Automatic component cost lookup (iFixit API)
- [ ] Competitor cost comparison generator
- [ ] Inflation/currency adjustment calculator
- [ ] Supply chain disruption alerts
- [ ] Historical cost trend analysis

## License

MIT — Use freely, modify as needed.

---

*Built for the Empire. 💰*
