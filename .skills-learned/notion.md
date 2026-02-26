# Notion Skill Summary

## What It Does

The Notion skill provides integration with the Notion API to create, read, update, and manage:
- **Pages** - Create and modify Notion pages
- **Data Sources (Databases)** - Create and query databases (called "data sources" in API v2025-09-03)
- **Blocks** - Add content blocks (paragraphs, headings, lists, etc.) to pages

## Tools/Commands Provided

The skill provides `curl`-based API examples for:

| Operation | Endpoint |
|-----------|----------|
| Search pages/databases | `POST /v1/search` |
| Get page | `GET /v1/pages/{page_id}` |
| Get page content (blocks) | `GET /v1/blocks/{page_id}/children` |
| Create page | `POST /v1/pages` |
| Query data source | `POST /v1/data_sources/{id}/query` |
| Create data source | `POST /v1/data_sources` |
| Update page | `PATCH /v1/pages/{page_id}` |
| Add blocks | `PATCH /v1/blocks/{page_id}/children` |

## Configuration

### Required Environment Variable
- `NOTION_API_KEY` - Your Notion integration API key

### Setup Steps
1. Create an integration at https://notion.so/my-integrations
2. Copy the API key (starts with `ntn_` or `secret_`)
3. Store it: `echo "ntn_your_key" > ~/.config/notion/api_key`
4. **Important:** Share target pages/databases with your integration via "..." → "Connect to"

### API Headers Required
```bash
-H "Authorization: Bearer $NOTION_KEY"
-H "Notion-Version: 2025-09-03"
-H "Content-Type: application/json"
```

## Common Use Cases

1. **Task Management** - Create/update tasks in a Notion database
2. **Note Taking** - Add structured notes to pages with blocks
3. **Data Logging** - Log events/metrics to a database
4. **Content Creation** - Programmatically create pages from templates
5. **Database Queries** - Search and filter database entries

## Key Property Types

- `title` - Page titles
- `rich_text` - Formatted text
- `select` / `multi_select` - Dropdown options
- `date` - Date ranges
- `checkbox` - Boolean values
- `number` - Numeric values
- `url` / `email` - Links and contacts
- `relation` - Links to other pages

## Important Notes (API v2025-09-03)

- **Databases are now "Data Sources"** - Use `/data_sources/` endpoints
- **Two IDs exist:** `database_id` (for creating pages) and `data_source_id` (for queries)
- Rate limit: ~3 requests/second average
- Database view filters are UI-only (cannot set via API)
- Use `is_inline: true` for embedded databases
