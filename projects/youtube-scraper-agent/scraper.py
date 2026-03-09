#!/usr/bin/env python3
"""
YouTube Scraper Agent
Finds viral video opportunities, researches them, and writes scripts.
Uses yt-dlp for extraction - no API keys needed.
"""

import json
import re
import subprocess
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional

# Configuration
OUTPUT_DIR = Path("/root/.openclaw/workspace/projects/youtube-scraper-agent")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Target niches to research - COST ANALYSIS / PRODUCT BREAKDOWN CHANNEL
TARGET_NICHES = [
    "how much does it cost to make",
    "product cost breakdown",
    "manufacturing cost analysis",
    "why is [product] so expensive",
    "cost of goods sold breakdown",
    "supply chain cost analysis",
    "iphone cost breakdown",
    "tesla cost to build",
    "sneaker manufacturing cost",
    "coffee shop cost breakdown",
    "restaurant food cost analysis",
    "ev battery cost breakdown",
    "pharmaceutical drug cost",
    "airline ticket cost breakdown",
    "streaming service cost breakdown"
]


def run_ytdlp(url: str, extract_comments: bool = False) -> Optional[dict]:
    """Extract video metadata using yt-dlp."""
    cmd = [
        "yt-dlp",
        "--dump-json",
        "--skip-download",
        "--no-warnings",
        url
    ]
    
    if extract_comments:
        cmd.extend(["--write-comments", "--no-download"])
    
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode == 0 and result.stdout:
            # yt-dlp outputs one JSON object per line
            lines = result.stdout.strip().split('\n')
            if lines:
                return json.loads(lines[0])
    except Exception as e:
        print(f"Error extracting {url}: {e}")
    
    return None


def search_youtube(query: str, max_results: int = 10) -> list:
    """Search YouTube and return video URLs."""
    # Use yt-dlp's search feature
    cmd = [
        "yt-dlp",
        "ytsearch{}:{}".format(max_results, query),
        "--get-id",
        "--no-warnings"
    ]
    
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=60
        )
        if result.returncode == 0:
            video_ids = [line.strip() for line in result.stdout.strip().split('\n') if line.strip()]
            return [f"https://youtube.com/watch?v={vid}" for vid in video_ids]
    except Exception as e:
        print(f"Error searching for '{query}': {e}")
    
    return []


def extract_trending_videos() -> list:
    """Get trending videos from YouTube."""
    cmd = [
        "yt-dlp",
        "https://www.youtube.com/feed/trending",
        "--flat-playlist",
        "--get-id",
        "--no-warnings"
    ]
    
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=60
        )
        if result.returncode == 0:
            video_ids = [line.strip() for line in result.stdout.strip().split('\n') if line.strip()][:20]
            return [f"https://youtube.com/watch?v={vid}" for vid in video_ids]
    except Exception as e:
        print(f"Error getting trending: {e}")
    
    return []


def analyze_video(video_data: dict) -> dict:
    """Extract key metrics from video data."""
    if not video_data:
        return {}
    
    # Parse upload date
    upload_date = video_data.get('upload_date', 'Unknown')
    if upload_date != 'Unknown':
        try:
            upload_dt = datetime.strptime(upload_date, '%Y%m%d')
            days_since_upload = (datetime.now() - upload_dt).days
        except:
            days_since_upload = None
    else:
        days_since_upload = None
    
    # Calculate performance metrics
    view_count = video_data.get('view_count', 0) or 0
    like_count = video_data.get('like_count', 0) or 0
    subscriber_count = video_data.get('channel_follower_count', 0) or 0
    
    # Views per subscriber ratio (viral indicator)
    vps_ratio = view_count / max(subscriber_count, 1)
    
    # Views per day (recency weighted)
    views_per_day = view_count / max(days_since_upload, 1) if days_since_upload else 0
    
    return {
        'title': video_data.get('title', 'Unknown'),
        'channel': video_data.get('channel', 'Unknown'),
        'channel_id': video_data.get('channel_id', ''),
        'video_id': video_data.get('id', ''),
        'url': video_data.get('webpage_url', ''),
        'upload_date': upload_date,
        'days_since_upload': days_since_upload,
        'duration': video_data.get('duration', 0),
        'view_count': view_count,
        'like_count': like_count,
        'subscriber_count': subscriber_count,
        'vps_ratio': round(vps_ratio, 2),
        'views_per_day': round(views_per_day, 0),
        'tags': video_data.get('tags', []),
        'description': video_data.get('description', '')[:500],
        'categories': video_data.get('categories', []),
        'thumbnail': video_data.get('thumbnail', '')
    }


def score_opportunity(video: dict) -> float:
    """Score a video opportunity for COST ANALYSIS channel (0-100)."""
    score = 0
    title = video.get('title', '').lower()
    tags = [t.lower() for t in video.get('tags', [])]
    description = video.get('description', '').lower()
    
    # COST ANALYSIS KEYWORDS - High priority
    cost_keywords = ['cost', 'breakdown', 'how much', 'expensive', 'price', 
                     'manufacturing', 'production', 'margin', 'profit', 'bill of materials',
                     'bom', 'supply chain', 'economics', 'business model']
    keyword_matches = sum(1 for kw in cost_keywords if kw in title or kw in description)
    score += min(keyword_matches * 8, 25)  # Up to 25 points for cost focus
    
    # High views with low subscribers = viral potential (strong for cost content)
    if video.get('vps_ratio', 0) > 10:
        score += 25
    elif video.get('vps_ratio', 0) > 5:
        score += 18
    elif video.get('vps_ratio', 0) > 2:
        score += 10
    
    # Recent uploads with high velocity (cost analysis ages well but fresh is better)
    if video.get('views_per_day', 0) > 10000:
        score += 20
    elif video.get('views_per_day', 0) > 5000:
        score += 15
    elif video.get('views_per_day', 0) > 1000:
        score += 10
    
    # Recency bonus - cost breakdowns of NEW products = high search
    if video.get('days_since_upload', 999) <= 7:
        score += 15
    elif video.get('days_since_upload', 999) <= 30:
        score += 12
    elif video.get('days_since_upload', 999) <= 90:
        score += 8
    
    # Duration sweet spot for cost analysis (10-20 min for depth)
    duration = video.get('duration', 0) or 0
    if 600 <= duration <= 1200:  # 10-20 minutes - ideal for cost breakdowns
        score += 15
    elif 480 <= duration <= 900:  # 8-15 minutes
        score += 12
    elif 300 <= duration <= 600:  # 5-10 minutes
        score += 8
    
    # Product/brand mentions = searchable content
    product_keywords = ['iphone', 'tesla', 'nike', 'apple', 'samsung', 'amazon', 
                        'starbucks', 'mcdonalds', 'airlines', 'pharma']
    product_matches = sum(1 for kw in product_keywords if kw in title or kw in tags)
    score += min(product_matches * 5, 15)
    
    return min(score, 100)


def discover_opportunities():
    """Main discovery function."""
    print("🔍 Starting YouTube opportunity discovery...")
    
    all_videos = []
    
    # 1. Get trending videos
    print("📈 Fetching trending videos...")
    trending_urls = extract_trending_videos()
    for url in trending_urls[:10]:
        data = run_ytdlp(url)
        if data:
            all_videos.append(analyze_video(data))
    
    # 2. Search target niches
    print("🎯 Searching target niches...")
    for niche in TARGET_NICHES[:4]:  # Limit to avoid rate limits
        print(f"  Searching: {niche}")
        urls = search_youtube(niche, max_results=5)
        for url in urls:
            data = run_ytdlp(url)
            if data:
                all_videos.append(analyze_video(data))
    
    # Score and rank
    print("📊 Scoring opportunities...")
    for video in all_videos:
        video['opportunity_score'] = score_opportunity(video)
    
    # Sort by score
    all_videos.sort(key=lambda x: x.get('opportunity_score', 0), reverse=True)
    
    return all_videos


def generate_discovery_report(videos: list):
    """Generate markdown report of opportunities."""
    today = datetime.now().strftime('%Y-%m-%d')
    report_path = OUTPUT_DIR / f"discovery-report-{today}.md"
    
    content = f"""# YouTube Opportunity Discovery Report

**Generated:** {today}
**Total Videos Analyzed:** {len(videos)}

---

## Top 10 Opportunities

| Rank | Score | Title | Channel | Views | Subs | VPS | Days Old |
|------|-------|-------|---------|-------|------|-----|----------|
"""
    
    for i, video in enumerate(videos[:10], 1):
        title = video.get('title', 'Unknown')[:50].replace('|', '\\|')
        channel = video.get('channel', 'Unknown')[:20].replace('|', '\\|')
        content += f"| {i} | {video.get('opportunity_score', 0)} | {title}... | {channel} | {video.get('view_count', 0):,} | {video.get('subscriber_count', 0):,} | {video.get('vps_ratio', 0)} | {video.get('days_since_upload', 'N/A')} |\n"
    
    content += """
---

## Detailed Breakdown

"""
    
    for i, video in enumerate(videos[:5], 1):
        content += f"""### #{i}: {video.get('title', 'Unknown')[:60]}

- **URL:** {video.get('url', 'N/A')}
- **Channel:** {video.get('channel', 'Unknown')} ({video.get('subscriber_count', 0):,} subs)
- **Views:** {video.get('view_count', 0):,} ({video.get('views_per_day', 0):,.0f}/day)
- **VPS Ratio:** {video.get('vps_ratio', 0)} (views per subscriber)
- **Uploaded:** {video.get('upload_date', 'Unknown')} ({video.get('days_since_upload', 'N/A')} days ago)
- **Duration:** {video.get('duration', 0)//60}m {video.get('duration', 0)%60}s
- **Opportunity Score:** {video.get('opportunity_score', 0)}/100

**Tags:** {', '.join(video.get('tags', [])[:10])}

**Why it's an opportunity:**
"""
        # Auto-generate why
        reasons = []
        if video.get('vps_ratio', 0) > 5:
            reasons.append("Viral performance (high views relative to channel size)")
        if video.get('days_since_upload', 999) <= 30:
            reasons.append("Recent upload with momentum")
        if video.get('views_per_day', 0) > 5000:
            reasons.append("High daily view velocity")
        if not reasons:
            reasons.append("Strong overall engagement metrics")
        
        for reason in reasons:
            content += f"- {reason}\n"
        
        content += "\n---\n\n"
    
    content += """## Next Steps

1. **Pick the top 3 opportunities** based on your niche expertise
2. **Research the topic deeper** — what are people asking in comments?
3. **Find your unique angle** — what's missing from existing content?
4. **Write the script** using the script template

---

*Report generated by YouTube Scraper Agent*
"""
    
    report_path.write_text(content)
    print(f"✅ Discovery report saved: {report_path}")
    return report_path


def main():
    """Main entry point."""
    print("=" * 60)
    print("🎬 YouTube Scraper Agent")
    print("=" * 60)
    
    # Check if yt-dlp is installed
    try:
        result = subprocess.run(["yt-dlp", "--version"], capture_output=True, text=True)
        print(f"yt-dlp version: {result.stdout.strip()}")
    except FileNotFoundError:
        print("❌ yt-dlp not found. Installing...")
        subprocess.run(["pip", "install", "yt-dlp"], check=True)
        print("✅ yt-dlp installed")
    
    # Run discovery
    videos = discover_opportunities()
    
    if videos:
        report_path = generate_discovery_report(videos)
        print(f"\n📄 Report: {report_path}")
        print(f"🎯 Top opportunity: {videos[0].get('title', 'Unknown')[:50]}")
    else:
        print("❌ No videos found. Check connection or try again later.")


if __name__ == "__main__":
    main()
