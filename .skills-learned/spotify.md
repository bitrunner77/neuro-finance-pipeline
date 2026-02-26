# Spotify Player Skill Summary

## Overview
The `spotify-player` skill provides terminal-based Spotify playback and search functionality. It supports two CLI tools: **spogo** (preferred) and **spotify_player** (fallback).

## What It Does
- Play, pause, skip, and control Spotify playback from the terminal
- Search for tracks, albums, artists, and playlists
- List and switch between Spotify Connect devices
- View current playback status
- Like/save tracks

## Tools/Commands Provided

### spogo (Preferred)
| Command | Description |
|---------|-------------|
| `spogo search track "query"` | Search for tracks |
| `spogo play` | Start/resume playback |
| `spogo pause` | Pause playback |
| `spogo next` | Skip to next track |
| `spogo prev` | Go to previous track |
| `spogo device list` | List available devices |
| `spogo device set "<name|id>"` | Switch to a specific device |
| `spogo status` | Show current playback status |

### spotify_player (Fallback)
| Command | Description |
|---------|-------------|
| `spotify_player search "query"` | Search for music |
| `spotify_player playback play` | Start playback |
| `spotify_player playback pause` | Pause playback |
| `spotify_player playback next` | Skip to next track |
| `spotify_player playback previous` | Go to previous track |
| `spotify_player connect` | Connect to a device |
| `spotify_player like` | Like the current track |

## Configuration

### Requirements
- **Spotify Premium account** (required)
- Either `spogo` or `spotify_player` installed

### Installation Options
**spogo (recommended):**
```bash
brew tap steipete/tap
brew install spogo
```

**spotify_player:**
```bash
brew install spotify_player
```

### Setup
- **spogo**: Import cookies from browser for authentication:
  ```bash
  spogo auth import --browser chrome
  ```
- **spotify_player**: Config located at `~/.config/spotify-player/app.toml`
  - For Spotify Connect integration, set a custom `client_id` in the config

## Common Use Cases

1. **Quick Playback Control**
   - Play/pause music without opening the Spotify app
   - Skip tracks while working in the terminal

2. **Music Discovery**
   - Search for new songs and artists directly from the command line
   - Find tracks to add to playlists

3. **Multi-Device Management**
   - Switch playback between computer, phone, and smart speakers
   - Control music playing on another device remotely

4. **Automation & Scripts**
   - Integrate Spotify controls into shell scripts
   - Set up keyboard shortcuts for common actions

5. **Headless/Server Environments**
   - Control Spotify on a remote machine without GUI

## Notes
- `spogo` is the preferred tool due to simpler syntax
- `spotify_player` includes a TUI (Terminal User Interface) with shortcuts available via `?`
- Both tools require an active internet connection and Spotify Premium
