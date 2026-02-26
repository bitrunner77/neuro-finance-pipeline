# Summarize Skill Summary

**Name:** summarize  
**Emoji:** 🧾  
**Requires:** `summarize` binary (install via `brew install steipete/tap/summarize`)

## Purpose
Fast CLI to summarize URLs, local files, and YouTube links. Great fallback for "transcribe this YouTube/video" requests.

## Trigger Phrases
Use immediately when user asks:
- "use summarize.sh"
- "what's this link/video about?"
- "summarize this URL/article"
- "transcribe this YouTube/video"

## Key Capabilities

### URL Summarization
- Summarize any web article or page
- Extract text only (without summarizing)
- Handle blocked sites via Firecrawl fallback

### File Summarization
- Summarize local PDFs, text files, documents
- Support for various file formats

### YouTube Transcription
- Extract transcripts from YouTube videos
- Best-effort transcript extraction (no yt-dlp needed)
- Apify fallback if APIFY_API_TOKEN is set

## Usage Examples

```bash
# Summarize a URL
summarize "https://example.com" --model google/gemini-3-flash-preview

# Summarize a local file
summarize "/path/to/file.pdf" --model google/gemini-3-flash-preview

# YouTube summary
summarize "https://youtu.be/dQw4w9WgXcQ" --youtube auto

# YouTube transcript only
summarize "https://youtu.be/dQw4w9WgXcQ" --youtube auto --extract-only

# Control output length
summarize "https://example.com" --length short  # short|medium|long|xl|xxl
```

## API Keys
Set one of these for your chosen provider:
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `XAI_API_KEY`
- `GEMINI_API_KEY` (aliases: `GOOGLE_GENERATIVE_AI_API_KEY`, `GOOGLE_API_KEY`)

Default model: `google/gemini-3-flash-preview`

## Useful Flags
- `--length short|medium|long|xl|xxl|<chars>` - Control summary length
- `--max-output-tokens <count>` - Limit output tokens
- `--extract-only` - Extract text without summarizing (URLs only)
- `--json` - Machine-readable output
- `--firecrawl auto|off|always` - Fallback extraction for blocked sites
- `--youtube auto` - Enable YouTube fallback via Apify

## Optional Services
- `FIRECRAWL_API_KEY` - For blocked/paywalled sites
- `APIFY_API_TOKEN` - For YouTube fallback

## Config File
Optional: `~/.summarize/config.json`
```json
{ "model": "openai/gpt-5.2" }
```

## Use Cases for Coder Agent
- Summarize documentation URLs before implementing features
- Extract transcripts from tutorial videos
- Quickly understand articles without reading full text
- Process PDF documentation

## Notes
- If transcript is huge, return a tight summary first, then ask which section to expand
- No yt-dlp required for YouTube - uses built-in extraction
