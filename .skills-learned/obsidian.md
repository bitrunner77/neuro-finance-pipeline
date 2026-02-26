# Obsidian Skill Summary

## Overview

The Obsidian skill enables interaction with **Obsidian vaults** — plain Markdown note collections stored as normal folders on disk. It uses the `obsidian-cli` tool to search, create, move, and manage notes programmatically.

---

## What It Does

- **Vault Management**: Work with Obsidian vaults (folders containing `.md` files + `.obsidian/` config)
- **Note Operations**: Search, create, move, rename, and delete notes
- **Link Maintenance**: Automatically updates `[[wikilinks]]` and Markdown links when moving/renaming notes
- **Content Search**: Search both note names and content within notes

---

## Tools/Commands Provided

### Vault Discovery
- `obsidian-cli print-default` — Show default vault
- `obsidian-cli print-default --path-only` — Get vault path only
- `obsidian-cli set-default "<vault-name>"` — Set default vault

### Search
- `obsidian-cli search "query"` — Search note names
- `obsidian-cli search-content "query"` — Search inside note content (shows snippets + line numbers)

### Note Management
- `obsidian-cli create "Folder/New note" --content "..." --open` — Create a new note
- `obsidian-cli move "old/path" "new/path"` — Move/rename with automatic link updates
- `obsidian-cli delete "path/note"` — Delete a note

### Direct File Access
- Notes are plain `.md` files — can be read/written directly with standard file tools
- Obsidian will auto-detect changes made outside the app

---

## Configuration

### Prerequisites
- **Binary**: `obsidian-cli` (install via `brew install yakitrak/yakitrak/obsidian-cli`)
- **Obsidian Desktop**: For URI handling (`obsidian://...`) when using `--open` flag

### Vault Configuration
- Vaults tracked in: `~/Library/Application Support/obsidian/obsidian.json`
- Vault name = folder name (path suffix)
- Multiple vaults supported (work/personal, iCloud vs local, etc.)
- Avoid hardcoding vault paths; read from config or use `print-default`

---

## Common Use Cases

1. **Daily Notes Automation** — Create dated notes with templates
2. **Knowledge Base Search** — Quickly find notes by name or content
3. **Note Refactoring** — Safely move/rename notes without breaking links
4. **Content Ingestion** — Programmatically create notes from external sources
5. **Vault Organization** — Bulk operations on note collections

---

## Key Notes

- Vaults are **plain folders** — no proprietary format
- `.obsidian/` folder contains workspace settings (usually don't touch from scripts)
- Supports Canvas files (`.canvas` — JSON format)
- Attachments stored in configurable folder (images, PDFs, etc.)
- Avoid creating notes under hidden dot-folders via URI (Obsidian may refuse)
