#!/usr/bin/env python3
"""
Neuro-Finance Video Pipeline
Automated video production helper using video-frames skill.
"""

import argparse
import os
import subprocess
import sys
from datetime import datetime

def extract_frame(video_path, timestamp, output_path):
    """Extract a single frame at timestamp."""
    cmd = [
        'ffmpeg', '-hide_banner', '-loglevel', 'error', '-y',
        '-ss', timestamp,
        '-i', video_path,
        '-frames:v', '1',
        '-q:v', '2',
        output_path
    ]
    subprocess.run(cmd, check=True)
    return output_path

def generate_thumbnail_batch(video_path, output_dir, count=5):
    """Generate multiple thumbnail options."""
    os.makedirs(output_dir, exist_ok=True)
    
    # Get duration
    result = subprocess.run(
        ['ffprobe', '-v', 'error', '-show_entries', 'format=duration',
         '-of', 'csv=p=0', video_path],
        capture_output=True, text=True, check=True
    )
    duration = int(float(result.stdout.strip()))
    
    interval = duration // (count + 1)
    thumbnails = []
    
    print(f"🎬 Video duration: {duration}s")
    print(f"📸 Extracting {count} frames at {interval}s intervals\n")
    
    for i in range(1, count + 1):
        timestamp_sec = i * interval
        hours = timestamp_sec // 3600
        minutes = (timestamp_sec % 3600) // 60
        seconds = timestamp_sec % 60
        timestamp = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        
        output_file = f"thumb-{i:02d}-{timestamp.replace(':', '-')}.jpg"
        output_path = os.path.join(output_dir, output_file)
        
        print(f"  [{i}/{count}] {timestamp} → {output_file}")
        extract_frame(video_path, timestamp, output_path)
        thumbnails.append(output_path)
    
    return thumbnails

def create_video_clip(video_path, start_time, duration, output_path):
    """Extract a short clip from video."""
    cmd = [
        'ffmpeg', '-hide_banner', '-loglevel', 'error', '-y',
        '-ss', start_time,
        '-t', str(duration),
        '-i', video_path,
        '-c', 'copy',
        output_path
    ]
    subprocess.run(cmd, check=True)
    return output_path

def main():
    parser = argparse.ArgumentParser(
        description='Neuro-Finance Video Pipeline'
    )
    parser.add_argument('video', help='Input video file')
    parser.add_argument('--thumbnails', '-t', action='store_true',
                       help='Generate thumbnail options')
    parser.add_argument('--clip', '-c', action='store_true',
                       help='Extract a clip')
    parser.add_argument('--start', default='00:00:00',
                       help='Clip start time (HH:MM:SS)')
    parser.add_argument('--duration', type=int, default=10,
                       help='Clip duration in seconds')
    parser.add_argument('--out-dir', default='./output',
                       help='Output directory')
    parser.add_argument('--count', type=int, default=5,
                       help='Number of thumbnails to generate')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.video):
        print(f"❌ Error: Video not found: {args.video}")
        sys.exit(1)
    
    os.makedirs(args.out_dir, exist_ok=True)
    
    if args.thumbnails:
        print("🎞️  Neuro-Finance Thumbnail Generator\n")
        thumbs = generate_thumbnail_batch(
            args.video, args.out_dir, args.count
        )
        print(f"\n✅ Generated {len(thumbs)} thumbnails in: {args.out_dir}/")
        print("\nNext: Review and enhance with AI (Midjourney/FLUX)")
    
    elif args.clip:
        output_file = f"clip-{args.start.replace(':', '-')}-{args.duration}s.mp4"
        output_path = os.path.join(args.out_dir, output_file)
        
        print(f"✂️  Extracting clip: {args.start} +{args.duration}s")
        create_video_clip(args.video, args.start, args.duration, output_path)
        print(f"✅ Saved: {output_path}")
    
    else:
        print("Use --thumbnails or --clip")
        parser.print_help()

if __name__ == '__main__':
    main()