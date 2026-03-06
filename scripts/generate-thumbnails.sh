#!/usr/bin/env bash
# Neuro-Finance Thumbnail Generator
# Extracts key frames from stock footage for AI-enhanced thumbnails

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: generate-thumbnails.sh <video-file> [options]

Generate thumbnail options from video footage for Neuro-Finance channel.

Options:
  --out-dir DIR       Output directory (default: ./thumbnails)
  --count N           Number of frames to extract (default: 5)
  --duration SECONDS  Video duration in seconds (auto-detect if not provided)
  --prefix NAME       Prefix for output files (default: thumb)

Examples:
  # Generate 5 thumbnail options from stock footage
  ./generate-thumbnails.sh stock-trading-footage.mp4

  # Generate 10 thumbnails with custom prefix
  ./generate-thumbnails.sh dopamine-animation.mp4 --count 10 --prefix dopamine

EOF
  exit 2
}

# Parse args
in="${1:-}"
if [[ "$in" == "" || "$in" == "-h" || "$in" == "--help" ]]; then
  usage
fi
shift || true

out_dir="./thumbnails"
count=5
duration=""
prefix="thumb"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      out_dir="${2:-}"
      shift 2
      ;;
    --count)
      count="${2:-}"
      shift 2
      ;;
    --duration)
      duration="${2:-}"
      shift 2
      ;;
    --prefix)
      prefix="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      ;;
  esac
done

# Validate input
if [[ ! -f "$in" ]]; then
  echo "Error: File not found: $in" >&2
  exit 1
fi

# Create output directory
mkdir -p "$out_dir"

# Get video duration if not provided
if [[ "$duration" == "" ]]; then
  duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$in" | cut -d. -f1)
  echo "📹 Detected duration: ${duration}s"
fi

# Calculate interval between frames
interval=$((duration / (count + 1)))

echo "🎬 Extracting $count frames from: $in"
echo "📁 Output: $out_dir"
echo "⏱️  Interval: ${interval}s"
echo ""

# Extract frames at calculated intervals
for i in $(seq 1 $count); do
  timestamp=$((i * interval))
  time_formatted=$(printf "%02d:%02d:%02d" $((timestamp/3600)) $(((timestamp%3600)/60)) $((timestamp%60)))
  
  out_file="${out_dir}/${prefix}-${i}-${time_formatted}.jpg"
  
  echo "  Frame $i/$count @ ${time_formatted} → ${out_file}"
  
  ffmpeg -hide_banner -loglevel error -y \
    -ss "$time_formatted" \
    -i "$in" \
    -frames:v 1 \
    -q:v 2 \
    "$out_file"
done

echo ""
echo "✅ Generated $count thumbnail options"
echo "📂 Location: $out_dir/"
echo ""
echo "Next steps:"
echo "  1. Review frames and select best composition"
echo "  2. Use AI (Midjourney/FLUX) to enhance selected frame"
echo "  3. Add text overlay and branding"
echo "  4. Export final thumbnail (1280x720)"