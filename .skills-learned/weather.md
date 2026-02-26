# Weather Skill Summary

## Overview
The Weather skill provides current weather and forecast information using free services that require no API keys.

## What It Does
- Retrieves current weather conditions for any location
- Provides weather forecasts
- Supports multiple output formats (one-liner, compact, full forecast, PNG images)
- Uses geolocation (city names, airport codes, coordinates)

## Tools/Commands

### Primary: wttr.in
A command-line weather service with rich formatting options.

**Quick one-liner:**
```bash
curl -s "wttr.in/London?format=3"
# Output: London: ⛅️ +8°C
```

**Compact format (customizable):**
```bash
curl -s "wttr.in/London?format=%l:+%c+%t+%h+%w"
# Output: London: ⛅️ +8°C 71% ↙5km/h
```

**Full forecast:**
```bash
curl -s "wttr.in/London?T"
```

**Format codes:**
- `%c` - condition (emoji/icon)
- `%t` - temperature
- `%h` - humidity
- `%w` - wind
- `%l` - location
- `%m` - moon phase

**Tips:**
- URL-encode spaces: `wttr.in/New+York`
- Airport codes work: `wttr.in/JFK`
- Units: `?m` (metric), `?u` (USCS)
- Today only: `?1`, Current only: `?0`
- PNG output: `wttr.in/Berlin.png`

### Fallback: Open-Meteo
JSON-based API for programmatic use.

```bash
curl -s "https://api.open-meteo.com/v1/forecast?latitude=51.5&longitude=-0.12&current_weather=true"
```

Returns JSON with temperature, windspeed, and weathercode.

## Configuration
- **No configuration required** - no API keys needed
- **Dependency:** Requires `curl` binary

## Common Use Cases
1. **Quick weather check** - One-liner for current conditions
2. **Daily briefings** - Compact format with key metrics
3. **Travel planning** - Full forecast with `?T` flag
4. **Automation/scripts** - Open-Meteo JSON for parsing
5. **Visual displays** - PNG output for dashboards
6. **Airport/travel** - Use airport codes (JFK, LHR, etc.)

## Homepage
https://wttr.in/:help
