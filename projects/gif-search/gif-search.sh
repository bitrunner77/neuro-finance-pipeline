#!/bin/bash
# gif-search.sh - A simple GIF search tool inspired by gifgrep
# Uses Tenor API (demo key)
# Features: search, download, extract stills/sheets

TENOR_API_KEY="${TENOR_API_KEY:-LIVDSRZULELA}"
DOWNLOAD_DIR="${HOME}/Downloads/gifs"
OUTPUT_DIR="${HOME}/Downloads/gif-extracts"

show_help() {
    cat << 'EOF'
🧲 gif-search.sh - GIF Search & Extract Tool

Usage: gif-search.sh [command] [options]

Commands:
  search <query>       Search for GIFs and display results
  download <url>       Download a GIF to ~/Downloads/gifs/
  still <file>         Extract a still frame from a GIF
  sheet <file>         Create a contact sheet (grid of frames)
  help                 Show this help message

Options:
  --max <n>            Maximum results (default: 5)
  --json               Output raw JSON
  --at <time>          Time offset for still extraction (default: 0.5s)
  --frames <n>         Number of frames for sheet (default: 9)
  --cols <n>           Columns in sheet grid (default: 3)
  -o <file>            Output filename

Examples:
  gif-search.sh search "cat"
  gif-search.sh search "hello" --max 10
  gif-search.sh download "https://media.tenor.com/xxx.gif"
  gif-search.sh still ./animation.gif --at 1.2s -o frame.png
  gif-search.sh sheet ./animation.gif --frames 12 --cols 4 -o overview.png

EOF
}

search_gifs() {
    local query="$1"
    local max="${2:-5}"
    local json_output="${3:-false}"
    
    # URL encode the query
    query=$(printf '%s' "$query" | sed 's/ /%20/g')
    
    local response=$(curl -s "https://g.tenor.com/v1/search?q=${query}&key=${TENOR_API_KEY}&limit=${max}")
    
    if [ "$json_output" = "true" ]; then
        echo "$response" | jq .
        return
    fi
    
    # Parse and display results
    echo "🔍 Found GIFs:"
    echo ""
    
    echo "$response" | jq -r '.results[] | 
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "🆔 ID: " + .id + "\n" +
        "📝 Title: " + (.content_description // "N/A") + "\n" +
        "🔗 URL: " + .media[0].gif.url + "\n" +
        "📐 Size: " + (.media[0].gif.dims | join("x")) + "\n" +
        "⏱️  Duration: " + (.media[0].gif.duration | tostring) + "s"
    '
}

download_gif() {
    local url="$1"
    local filename=$(basename "$url" | cut -d'?' -f1)
    
    mkdir -p "$DOWNLOAD_DIR"
    
    echo "📥 Downloading..."
    if curl -sL "$url" -o "${DOWNLOAD_DIR}/${filename}"; then
        echo "✅ Saved to: ${DOWNLOAD_DIR}/${filename}"
        ls -lh "${DOWNLOAD_DIR}/${filename}"
    else
        echo "❌ Download failed"
        return 1
    fi
}

extract_still() {
    local input_file="$1"
    local time_offset="${2:-0.5}"
    local output_file="$3"
    
    if [ -z "$output_file" ]; then
        local basename=$(basename "$input_file" .gif)
        output_file="${OUTPUT_DIR}/${basename}-still.png"
    fi
    
    mkdir -p "$OUTPUT_DIR"
    
    echo "🖼️  Extracting still frame at ${time_offset}s..."
    if ffmpeg -i "$input_file" -ss "00:00:${time_offset}" -vframes 1 -y "$output_file" 2>/dev/null; then
        echo "✅ Still frame saved to: $output_file"
        ls -lh "$output_file"
    else
        echo "❌ Extraction failed"
        return 1
    fi
}

create_sheet() {
    local input_file="$1"
    local frames="${2:-9}"
    local cols="${3:-3}"
    local output_file="$4"
    
    if [ -z "$output_file" ]; then
        local basename=$(basename "$input_file" .gif)
        output_file="${OUTPUT_DIR}/${basename}-sheet.png"
    fi
    
    mkdir -p "$OUTPUT_DIR"
    
    echo "📊 Creating contact sheet (${frames} frames, ${cols} cols)..."
    
    # Get GIF duration
    local duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$input_file" 2>/dev/null | cut -d. -f1)
    if [ -z "$duration" ] || [ "$duration" -eq 0 ]; then
        duration=1
    fi
    
    # Create temp directory for frames
    local temp_dir=$(mktemp -d)
    
    # Extract frames at evenly spaced intervals
    local interval=$(echo "scale=2; $duration / $frames" | bc 2>/dev/null || echo "0.1")
    
    for i in $(seq 0 $((frames - 1))); do
        local time=$(echo "scale=2; $i * $interval" | bc 2>/dev/null || echo "$i")
        ffmpeg -i "$input_file" -ss "$time" -vframes 1 -y "${temp_dir}/frame_$(printf %03d $i).png" 2>/dev/null
    done
    
    # Create montage using ffmpeg
    local rows=$(( (frames + cols - 1) / cols ))
    
    # Build filter complex for grid layout
    local filter=""
    local inputs=""
    for i in $(seq 0 $((frames - 1))); do
        if [ -f "${temp_dir}/frame_$(printf %03d $i).png" ]; then
            inputs="${inputs} -i ${temp_dir}/frame_$(printf %03d $i).png"
        fi
    done
    
    # Use ffmpeg to create the montage
    ffmpeg $inputs -filter_complex "
        $(for i in $(seq 0 $((frames - 1))); do echo -n "[$i:v]"; done)
        xstack=inputs=${frames}:layout=
        $(for row in $(seq 0 $((rows - 1))); do
            for col in $(seq 0 $((cols - 1))); do
                idx=$((row * cols + col))
                if [ $idx -lt $frames ]; then
                    x=$((col * 100))
                    y=$((row * 100))
                    echo -n "${idx}_${x}_${y}|"
                fi
            done
        done | sed 's/|$//')
        [out]" -map "[out]" -y "$output_file" 2>/dev/null
    
    # Cleanup
    rm -rf "$temp_dir"
    
    if [ -f "$output_file" ]; then
        echo "✅ Contact sheet saved to: $output_file"
        ls -lh "$output_file"
    else
        echo "❌ Sheet creation failed"
        return 1
    fi
}

# Main
case "${1:-}" in
    search)
        shift
        query=""
        max=5
        json_output=false
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                --max) max="$2"; shift 2 ;;
                --json) json_output=true; shift ;;
                *) 
                    if [ -z "$query" ]; then
                        query="$1"
                    fi
                    shift 
                    ;;
            esac
        done
        
        if [ -z "$query" ]; then
            echo "❌ Please provide a search query"
            exit 1
        fi
        
        search_gifs "$query" "$max" "$json_output"
        ;;
    download)
        shift
        if [ -z "$1" ]; then
            echo "❌ Please provide a URL"
            exit 1
        fi
        download_gif "$1"
        ;;
    still)
        shift
        input_file=""
        time_offset="0.5"
        output_file=""
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                --at) time_offset="$2"; shift 2 ;;
                -o) output_file="$2"; shift 2 ;;
                *) 
                    if [ -z "$input_file" ]; then
                        input_file="$1"
                    fi
                    shift 
                    ;;
            esac
        done
        
        if [ -z "$input_file" ]; then
            echo "❌ Please provide an input file"
            exit 1
        fi
        
        extract_still "$input_file" "$time_offset" "$output_file"
        ;;
    sheet)
        shift
        input_file=""
        frames=9
        cols=3
        output_file=""
        
        while [[ $# -gt 0 ]]; do
            case "$1" in
                --frames) frames="$2"; shift 2 ;;
                --cols) cols="$2"; shift 2 ;;
                -o) output_file="$2"; shift 2 ;;
                *) 
                    if [ -z "$input_file" ]; then
                        input_file="$1"
                    fi
                    shift 
                    ;;
            esac
        done
        
        if [ -z "$input_file" ]; then
            echo "❌ Please provide an input file"
            exit 1
        fi
        
        create_sheet "$input_file" "$frames" "$cols" "$output_file"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        ;;
esac
