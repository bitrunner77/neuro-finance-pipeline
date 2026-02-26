# Slack Skill Summary

**Name:** slack  
**Emoji:** 💬  
**Requires:** Config `channels.slack`

## Purpose
Control Slack from OpenClaw via the slack tool - react to messages, manage pins, send/edit/delete messages, and fetch member info.

## Key Capabilities

### Message Reactions
- React to messages with emojis (✅, 👍, etc.)
- List existing reactions on a message

### Message Management
- Send messages to channels or users
- Edit existing messages
- Delete messages
- Read recent messages from channels

### Pins
- Pin important messages
- Unpin messages
- List all pinned items in a channel

### Member Info
- Get user information by ID
- List custom emoji

## Usage Examples

```json
// React to a message
{"action": "react", "channelId": "C123", "messageId": "1712023032.1234", "emoji": "✅"}

// Send a message
{"action": "sendMessage", "to": "channel:C123", "content": "Hello from OpenClaw"}

// Pin a message
{"action": "pinMessage", "channelId": "C123", "messageId": "1712023032.1234"}
```

## Use Cases for Coder Agent
- Post deployment notifications to Slack channels
- React with ✅ when tasks are completed
- Pin key decisions or weekly status updates
- Read messages to respond to mentions or requests

## Notes
- Uses bot token configured for OpenClaw
- Message timestamps serve as message IDs (e.g., `1712023032.1234`)
