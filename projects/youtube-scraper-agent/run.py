#!/usr/bin/env python3
"""
YouTube Scraper Agent - Main Orchestrator
Runs the full pipeline: Discover → Research → Script
"""

import subprocess
import sys
from datetime import datetime
from pathlib import Path

# Import modules
sys.path.insert(0, str(Path(__file__).parent))
from scraper import discover_opportunities, generate_discovery_report, OUTPUT_DIR
from script_writer import write_script, save_script


def main():
    """Run the complete YouTube scraper pipeline."""
    print("=" * 70)
    print("🎬 YouTube Scraper Agent - Full Pipeline")
    print("=" * 70)
    print()
    
    # Phase 1: Discovery
    print("📍 PHASE 1: DISCOVERY")
    print("-" * 70)
    
    try:
        videos = discover_opportunities()
        
        if not videos:
            print("❌ No videos discovered. Exiting.")
            return
        
        report_path = generate_discovery_report(videos)
        top_video = videos[0]
        
        print(f"\n✅ Discovery complete!")
        print(f"   Found {len(videos)} videos")
        print(f"   Top opportunity: {top_video.get('title', 'Unknown')[:50]}...")
        print(f"   Report: {report_path}")
        
    except Exception as e:
        print(f"❌ Discovery failed: {e}")
        return
    
    # Phase 2: Research (Auto-select top opportunity)
    print()
    print("📍 PHASE 2: RESEARCH")
    print("-" * 70)
    
    topic = top_video.get('title', 'Unknown')
    channel = top_video.get('channel', 'Unknown')
    
    print(f"Researching: {topic[:60]}...")
    print(f"Original channel: {channel}")
    print(f"Performance: {top_video.get('view_count', 0):,} views | {top_video.get('vps_ratio', 0)} VPS ratio")
    
    # Generate research notes
    research_content = f"""# Research: {topic}

**Source Video:** {top_video.get('url', 'N/A')}
**Original Channel:** {channel} ({top_video.get('subscriber_count', 0):,} subscribers)
**Performance:** {top_video.get('view_count', 0):,} views in {top_video.get('days_since_upload', 'N/A')} days
**VPS Ratio:** {top_video.get('vps_ratio', 0)} (viral indicator)

## Why This Works

1. **High engagement relative to channel size** — {top_video.get('vps_ratio', 0)}x views per subscriber indicates strong algorithm pickup
2. **Recent momentum** — Uploaded {top_video.get('days_since_upload', 'N/A')} days ago with {top_video.get('views_per_day', 0):,.0f} daily views
3. **Topic relevance** — Aligns with current trends in the niche

## Content Gap Analysis

**What's covered in original:**
- [To be filled after watching]

**What's missing (opportunity):**
- Deeper technical implementation
- Alternative approaches
- Beginner-friendly explanation
- Real case studies/examples
- Cost breakdown or ROI analysis

## Target Audience

- Primary: [Define based on topic]
- Pain point: [What problem does this solve?]
- Search intent: [Informational/Transactional]

## Monetization Potential

- CPM estimate: $5-15 (tech/tutorial niche)
- Affiliate opportunities: [Tools/products mentioned]
- Lead gen potential: [Related services/courses]

## Unique Angle

Instead of [what original did], focus on:
- [Different approach 1]
- [Different approach 2]
- [Specific use case not covered]

## Recommended Video Structure

1. Hook: [Pattern interrupt related to common frustration]
2. Problem: [Why current solutions fail]
3. Solution: [Your unique approach]
4. Proof: [Case study or demo]
5. CTA: [Subscribe + next video]

---

*Research generated: {datetime.now().strftime('%Y-%m-%d')}*
"""
    
    research_path = OUTPUT_DIR / f"researched-topic-{datetime.now().strftime('%Y%m%d')}.md"
    research_path.write_text(research_content)
    print(f"✅ Research notes saved: {research_path}")
    
    # Phase 3: Script Writing
    print()
    print("📍 PHASE 3: SCRIPT WRITING")
    print("-" * 70)
    
    # Derive script parameters from research
    script_topic = f"How to {topic.split(' | ')[0].split(' - ')[0][:50]}"
    script_angle = f"The {channel}-inspired approach that actually works (with improvements)"
    script_points = [
        f"Why most people fail at {topic.split()[0]}",
        "The validation framework that saves months",
        "Step-by-step implementation guide",
        "Real results and case studies"
    ]
    
    print(f"Generating script: {script_topic}")
    
    script_content = write_script(
        topic=script_topic,
        angle=script_angle,
        key_points=script_points,
        target_duration=10
    )
    
    script_path = save_script(script_topic, script_content)
    
    print(f"✅ Script saved: {script_path}")
    
    # Summary
    print()
    print("=" * 70)
    print("🎉 PIPELINE COMPLETE!")
    print("=" * 70)
    print()
    print("Files generated:")
    print(f"  📊 Discovery: {report_path}")
    print(f"  🔍 Research:  {research_path}")
    print(f"  📝 Script:    {script_path}")
    print()
    print("Next steps:")
    print("  1. Review the discovery report")
    print("  2. Customize the research notes")
    print("  3. Record using the script")
    print("  4. Create thumbnail per the concept")
    print()


if __name__ == "__main__":
    # Check dependencies
    try:
        import yt_dlp
    except ImportError:
        print("Installing yt-dlp...")
        subprocess.run([sys.executable, "-m", "pip", "install", "yt-dlp"], check=True)
        print("✅ yt-dlp installed")
    
    main()
