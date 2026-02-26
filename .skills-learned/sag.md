# SAG Skill Summary

## What It Does

SAG ("say" spelled backwards) is an ElevenLabs text-to-speech (TTS) CLI tool that provides macOS-style `say` command UX for generating high-quality AI voices. It enables local audio playback and file generation from text using ElevenLabs' voice models.

## Tools/Commands Provided

### Basic Commands
- `sag "Hello there"` - Speak text using default voice
- `sag speak -v "VoiceName" "Hello"` - Speak with specific voice
- `sag voices` - List available voices
- `sag prompting` - Show model-specific prompting tips

### Output Options
- `sag -o /path/to/output.mp3 "Text to speak"` - Save to file instead of playing
- `sag -v VoiceID "Text"` - Use specific voice ID

### Advanced Options
- `--normalize auto|off` - Normalize numbers/units/URLs
- `--lang en|de|fr|...` - Set language bias for normalization
- Model selection via flags (default: `eleven_v3`)

## Configuration

### Required Environment Variables
- `ELEVENLABS_API_KEY` (preferred) - Your ElevenLabs API key
- `SAG_API_KEY` - Alternative API key variable (also supported by CLI)

### Optional Environment Variables
- `ELEVENLABS_VOICE_ID` or `SAG_VOICE_ID` - Set default voice

### Installation
```bash
brew install steipete/tap/sag
```

## Voice Models

| Model | Description |
|-------|-------------|
| `eleven_v3` | Default, expressive, best quality |
| `eleven_multilingual_v2` | Stable, reliable |
| `eleven_flash_v2_5` | Fast, lower latency |

## Voice Control Features

### Audio Tags (v3 model, place at start of line)
- **Volume/Style**: `[whispers]`, `[shouts]`, `[sings]`
- **Emotions**: `[laughs]`, `[sighs]`, `[excited]`, `[curious]`, `[sarcastic]`, `[crying]`, `[mischievously]`
- **Actions**: `[starts laughing]`, `[exhales]`

### Pause Controls
- v3: `[pause]`, `[short pause]`, `[long pause]` (SSML `<break>` not supported)
- v2/v2.5: SSML `<break time="1.5s" />` supported

### Pronunciation Tips
1. First fix: respell (e.g., "key-note"), add hyphens, adjust casing
2. Use `--normalize auto` for numbers/units/URLs
3. Use `--lang` to guide language bias

## Common Use Cases

1. **Quick TTS Playback**: `sag "Your text here"` - Instantly hear text spoken
2. **Voice Responses**: Generate audio files for chat replies with character voices
3. **Content Creation**: Create audio files for videos, podcasts, presentations
4. **Accessibility**: Convert text to speech for visually impaired users
5. **Character Voices**: Use audio tags for storytelling, gaming, creative projects
6. **Multilingual Content**: Support for multiple languages with language bias flags

## Example Usage Patterns

```bash
# Basic usage
sag "Hello world"

# With voice and output file
sag -v "Roger" -o greeting.mp3 "Hello there"

# With emotion tags
sag "[excited] Welcome everyone! [short pause] Let's get started."

# Whisper mode
sag "[whispers] This is a secret message."
```

## Notes
- Always confirm voice + speaker before generating long output
- Default voice for Clawd: `lj2rcrvANS3gaWWnczSX` (or use `-v Clawd`)
- v3 model does NOT support SSML `<break>` tags; use pause tags instead
