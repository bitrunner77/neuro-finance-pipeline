# Trello Skill Summary

**Name:** trello  
**Emoji:** 📋  
**Requires:** `jq`, env vars `TRELLO_API_KEY` and `TRELLO_TOKEN`

## Purpose
Manage Trello boards, lists, and cards via the Trello REST API.

## Setup
1. Get API key: https://trello.com/app-key
2. Generate token from that page
3. Set environment variables:
   ```bash
   export TRELLO_API_KEY="your-api-key"
   export TRELLO_TOKEN="your-token"
   ```

## Key Capabilities

### Boards
- List all boards for the user
- Get board details

### Lists
- List all lists in a board
- Get list details

### Cards
- List cards in a list
- Create new cards
- Move cards between lists
- Add comments to cards
- Archive cards

## Usage Examples

```bash
# List all boards
curl -s "https://api.trello.com/1/members/me/boards?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" | jq '.[] | {name, id}'

# List lists in a board
curl -s "https://api.trello.com/1/boards/{boardId}/lists?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" | jq '.[] | {name, id}'

# Create a card
curl -s -X POST "https://api.trello.com/1/cards?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  -d "idList={listId}" \
  -d "name=Card Title" \
  -d "desc=Card description"

# Move card to another list
curl -s -X PUT "https://api.trello.com/1/cards/{cardId}?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  -d "idList={newListId}"

# Archive a card
curl -s -X PUT "https://api.trello.com/1/cards/{cardId}?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  -d "closed=true"
```

## Use Cases for Coder Agent
- Create cards for new bugs/features
- Move cards between lists (To Do → In Progress → Done)
- Add comments with deployment notes
- Archive completed tasks

## Rate Limits
- 300 requests per 10 seconds per API key
- 100 requests per 10 seconds per token
- `/1/members` endpoints: 100 requests per 900 seconds

## Notes
- IDs can be found in Trello URLs or via list commands
- Keep API key and token secret - they provide full account access
