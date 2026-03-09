# Video Script: "How to Build Your First MCP Server with Claude"

**Working Title:** Build an MCP Server in 25 Minutes (Connect Claude to ANYTHING)

**Video Length:** 25-28 minutes

**Target Audience:** Developers, technical founders, AI tool builders

**Niche:** AI Tools / Developer Tutorials / Claude

---

## 🎬 HOOK (0:00 - 0:45)

### Visual:
[Face to camera OR screen recording with face overlay. High energy. Fast cuts between: Claude interface, code editor, terminal showing "Connected"]

### Script:

"What if I told you that in the next 25 minutes, you'll give Claude superpowers?

[Pause - let that land]

Right now, Claude is trapped. It can only use what Anthropic gave it. But what if Claude could query your database? Browse the web? Control your GitHub repos? Read your Notion docs?

[Screen flash - show each tool appearing]

That's exactly what MCP does. Model Context Protocol is the USB-C for AI applications - one standard to connect any AI to any tool.

And here's the crazy part: GitHub, Microsoft, and AWS just went all-in on this. GitHub's official MCP server already has 15,000 stars.

[Show GitHub repo screenshot]

But here's the problem: almost nobody knows how to actually BUILD an MCP server. The tutorials are either 5-minute overviews or dense technical docs.

So today, we're building a REAL MCP server together. Not a toy example - something you can actually use.

By the end of this video, you'll have built a Hacker News AI Assistant that can fetch stories, search posts, and summarize discussions - all through Claude.

[Screen: Split view - code on left, Claude on right]

Let's code."

### Thumbnail Concept:
- **Visual:** Split screen - Claude logo on left, Code editor on right, "MCP" in big bold text in middle
- **Text overlay:** "25 MIN" and "FREE"
- **Expression:** Excited/surprised face (if on camera)
- **Colors:** Anthropic purple + Code editor dark theme

---

## 📖 INTRO (0:45 - 2:30)

### Visual:
[Screen recording. Clean desktop. Architecture diagram appears]

### Script:

"Before we start coding, let me explain WHY MCP is such a big deal - and why you should care.

[Switch to simple diagram]

Right now, every AI tool integration is custom. Want Claude to use your database? Write custom code. Want it to check GitHub? Different custom code. Want it to browse? More custom code.

It's a mess. And it's not secure - you're giving AI tools random access to your systems.

[Animation: Messy lines connecting AI to tools]

MCP fixes this. It's an open standard created by Anthropic that lets AI models connect to external tools through a standardized interface.

[Animation: Clean single connection]

Think of it like USB-C. Before USB-C, every device needed a different cable. Now? One cable, universal connection.

MCP is USB-C for AI.

[Show real examples]

With MCP, Claude can:
- Query your PostgreSQL database directly
- Review pull requests on GitHub
- Control a browser with Playwright
- Read and write to Notion
- Access Sentry error logs

[Show logos appearing]

And the best part? Write one MCP server, and it works with Claude Desktop, Cursor, Windsurf - any MCP-compatible client.

[Screen: List of MCP clients]

Today we're building something practical: a Hacker News MCP server.

Why Hacker News? Because it's a real API, it has interesting data, and you'll actually use this tool. Plus, it teaches you all the MCP patterns you'll need for any server.

[Show final result preview]

By the end, you'll be able to ask Claude things like:
- 'What's trending on Hacker News?'
- 'Find me posts about AI'
- 'Summarize the top comments on this story'

And Claude will use OUR server to get that information.

Let's set up your environment."

---

## 🛠️ SETUP (2:30 - 5:30)

### Visual:
[Terminal recording. Clean, readable font. Step-by-step commands]

### Script:

"First, let's get your environment ready. You need three things:

One: Python 3.10 or higher. Check your version:

[Type command: python --version]

Two: UV - this is a fast Python package manager. If you don't have it:

[Type command: curl -LsSf https://astral.sh/uv/install.sh | sh]

Three: Claude Desktop - download it from anthropic.com if you haven't already.

[Show Claude Desktop interface]

Now let's create our project:

[Type commands]
```
mkdir hacker-news-mcp
cd hacker-news-mcp
uv init
```

Great. Now install the MCP SDK:

```
uv add mcp
```

[Wait for install]

While that's installing, let me explain what we're building.

[Switch to diagram]

Our MCP server will have three tools:
1. get_top_stories - fetch trending posts
2. search_stories - search by keyword
3. get_story_details - get full post + comments

Each tool is a Python function that Claude can call when it needs information.

[Back to terminal]

Installation done? Perfect. Create a new file called server.py:

```
touch server.py
```

Now open it in your code editor. I'll use Cursor, but use whatever you prefer."

---

## 💻 BUILDING THE SERVER (5:30 - 17:00)

### Visual:
[Code editor. Split screen: code on left, terminal on right. Type code live]

### Script:

"Let's build this server step by step.

First, the imports and basic setup:

[Type code slowly, explaining each line]

```python
import asyncio
import json
import urllib.request
from mcp.server import Server
from mcp.types import TextContent

# Create our server instance
app = Server("hacker-news")
```

The Server class is from the MCP SDK. 'hacker-news' is just a name - call it whatever you want.

Now let's add our first tool - getting top stories:

```python
@app.tool()
async def get_top_stories(limit: int = 10) -> list:
    """
    Get top stories from Hacker News.
    
    Args:
        limit: Number of stories to return (max 30)
    """
    # Hacker News API endpoint for top stories
    url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    
    with urllib.request.urlopen(url) as response:
        story_ids = json.loads(response.read())[:limit]
    
    stories = []
    for story_id in story_ids:
        story_url = f"https://hacker-news.firebaseio.com/v0/item/{story_id}.json"
        with urllib.request.urlopen(story_url) as response:
            story = json.loads(response.read())
            stories.append({
                "title": story.get("title", "No title"),
                "url": story.get("url", ""),
                "score": story.get("score", 0),
                "by": story.get("by", "unknown"),
                "id": story_id
            })
    
    return [TextContent(type="text", text=json.dumps(stories, indent=2))]
```

[Pause, explain]

Let me break this down:

The @app.tool() decorator tells MCP this is a tool Claude can use.

The docstring is CRITICAL - Claude reads this to understand when to use the tool. Be descriptive!

We're hitting the Hacker News Firebase API - it's free, no auth needed.

The function returns a list of TextContent objects. This is how MCP sends data back to the AI.

[Continue typing]

Now let's add search functionality:

```python
@app.tool()
async def search_stories(query: str, limit: int = 10) -> list:
    """
    Search Hacker News stories by keyword.
    Uses Algolia's HN Search API.
    
    Args:
        query: Search term (e.g., 'AI', 'Python', 'startup')
        limit: Maximum results to return
    """
    # Algolia HN Search API
    encoded_query = urllib.parse.quote(query)
    url = f"https://hn.algolia.com/api/v1/search?query={encoded_query}&hitsPerPage={limit}"
    
    with urllib.request.urlopen(url) as response:
        data = json.loads(response.read())
    
    hits = data.get("hits", [])
    stories = []
    for hit in hits:
        stories.append({
            "title": hit.get("title", "No title"),
            "url": hit.get("url", ""),
            "author": hit.get("author", "unknown"),
            "points": hit.get("points", 0),
            "created_at": hit.get("created_at", ""),
            "objectID": hit.get("objectID", "")
        })
    
    return [TextContent(type="text", text=json.dumps(stories, indent=2))]
```

[Explain]

This uses Algolia's HN Search API - much better than trying to search manually.

Notice the detailed docstring again. Claude uses this to decide which tool to call. The better your docstrings, the better Claude performs.

[Continue]

Finally, let's add a tool to get story details with comments:

```python
@app.tool()
async def get_story_details(story_id: int) -> list:
    """
    Get full details of a story including top comments.
    
    Args:
        story_id: The Hacker News story ID
    """
    # Get story details
    story_url = f"https://hacker-news.firebaseio.com/v0/item/{story_id}.json"
    
    with urllib.request.urlopen(story_url) as response:
        story = json.loads(response.read())
    
    result = {
        "title": story.get("title", "No title"),
        "url": story.get("url", ""),
        "text": story.get("text", ""),
        "by": story.get("by", "unknown"),
        "score": story.get("score", 0),
        "comments": []
    }
    
    # Get top-level comments (up to 10)
    kids = story.get("kids", [])[:10]
    for kid_id in kids:
        comment_url = f"https://hacker-news.firebaseio.com/v0/item/{kid_id}.json"
        try:
            with urllib.request.urlopen(comment_url) as response:
                comment = json.loads(response.read())
                if comment and not comment.get("deleted"):
                    result["comments"].append({
                        "by": comment.get("by", "unknown"),
                        "text": comment.get("text", "")[:500],  # Truncate long comments
                        "time": comment.get("time", 0)
                    })
        except:
            continue  # Skip deleted/invalid comments
    
    return [TextContent(type="text", text=json.dumps(result, indent=2))]
```

[Explain]

This one fetches the story plus its top comments. We're truncating long comments to keep the context manageable - Claude has token limits, remember.

Now let's add the server runner:

```python
async def main():
    # Run the server using stdio transport
    from mcp.server.stdio import stdio_server
    
    async with stdio_server(server=app) as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options()
        )

if __name__ == "__main__":
    asyncio.run(main())
```

[Explain]

The stdio transport means Claude Desktop will communicate with our server through standard input/output. This is the simplest way to get started.

[Save file]

Save this file. Now we need to tell Claude Desktop about our server."

---

## ⚙️ CONFIGURING CLAUDE DESKTOP (17:00 - 20:00)

### Visual:
[Claude Desktop interface. Config file editing]

### Script:

"Now let's connect our server to Claude Desktop.

Open Claude Desktop and go to Settings. Click on 'Developer' in the left sidebar, then 'Edit Config'.

[Show screen recording]

This opens a claude_desktop_config.json file. We need to add our server to it.

Add this configuration:

```json
{
  "mcpServers": {
    "hacker-news": {
      "command": "uv",
      "args": [
        "--directory",
        "/path/to/your/hacker-news-mcp",
        "run",
        "server.py"
      ]
    }
  }
}
```

[Highlight]

CRITICAL: Replace '/path/to/your/hacker-news-mcp' with your actual project path. It needs to be the absolute path.

[Show example]

For example, on Mac it might be:
'/Users/yourname/projects/hacker-news-mcp'

On Windows:
'C:\\Users\\YourName\\projects\\hacker-news-mcp'

Save the file and completely restart Claude Desktop. Not just close the window - fully quit and reopen.

[Show quitting and reopening]

When Claude restarts, you should see a hammer icon in the bottom right of the input box. Click it.

[Show hammer icon]

If you see 'hacker-news' listed with your three tools - get_top_stories, search_stories, and get_story_details - you're connected!

[Show tool list]

If you don't see it, check the logs. In Settings > Developer, click 'Open Logs'. Look for errors.

Common issues:
- Wrong path in config
- Python not found
- Missing dependencies

[Show log file]

Assuming you see the tools, let's test it!"

---

## 🧪 TESTING & DEMONSTRATION (20:00 - 24:00)

### Visual:
[Claude Desktop chat interface. Live interaction]

### Script:

"Let's test our MCP server with real queries.

[Type in Claude]

First, let's see what's trending:

'What's trending on Hacker News right now?'

[Wait for response]

Look at that! Claude recognized it needed current data and called our get_top_stories tool automatically.

[Show tool call happening]

See the tool call indicator? Claude fetched live data and gave us the top stories with links.

Now let's try search:

'Find me recent posts about AI agents on Hacker News'

[Wait]

Claude used our search_stories tool with the query 'AI agents'. It found relevant posts and summarized them.

[Show results]

Now for the real test - let's get details on an interesting story:

'Get the details and top comments for the AI agents story'

[Wait]

Claude used get_story_details and pulled the full post plus top comments. It even summarized the discussion.

[Show results]

This is LIVE data from Hacker News, accessed through OUR server. Claude didn't know any of this - it used our tool to get the information.

Let's try one more complex query:

'Summarize what people are saying about MCP on Hacker News this week'

[Wait]

Watch this - Claude might chain multiple tool calls. First search, then get details on relevant posts.

[Show chained tool calls]

Incredible. Claude searched for MCP posts, identified the most relevant ones, fetched their details and comments, then synthesized a summary.

This is the power of MCP. Claude becomes an interface to any data source you can code."

---

## 🚀 NEXT STEPS & OUTRO (24:00 - 26:30)

### Visual:
[Code editor showing completed project. Terminal. Back to face camera if applicable]

### Script:

"Congratulations! You just built a production-ready MCP server.

[Show completed code]

Let's recap what you learned:

1. MCP is the USB-C for AI - one standard to connect any AI to any tool
2. You built a server with three tools using the Python SDK
3. You connected it to Claude Desktop
4. Claude can now fetch live Hacker News data through your server

But this is just the beginning. Here's what you can do next:

[Show list]

**Deploy your server:**
- Package it as a proper Python package
- Deploy to a server for team use
- Share it on GitHub

**Add more features:**
- User authentication
- Caching for faster responses
- More Hacker News endpoints
- Error handling and retries

**Build your own:**
- Connect to your company's API
- Query your database
- Control internal tools

**Resources:**

[Show on screen]
- Official MCP docs: modelcontextprotocol.io
- My GitHub repo with this code: [link in description]
- MCP Python SDK: github.com/modelcontextprotocol/python-sdk

[If on camera, direct address]

If you found this helpful, hit that like button. It tells YouTube to show this to more developers who need to learn MCP.

Subscribe if you want more tutorials like this - I'm planning videos on:
- Building MCP servers with TypeScript
- Advanced MCP patterns and best practices
- Connecting MCP to databases

[Point to screen]

Drop a comment if you build something cool with MCP. I read every single one.

Thanks for watching - now go build something amazing with MCP.

[End screen with subscribe button and related videos]"

---

## 🎨 THUMBNAIL CONCEPT

### Primary Thumbnail:
**Layout:** Split design
- **Left:** Claude logo (purple/white)
- **Right:** Code editor showing "@app.tool()" decorator
- **Center:** Large bold text "MCP SERVER" with arrow connecting both sides
- **Bottom:** "25 MIN" badge + "FREE CODE"

### Alternative Thumbnail:
**Layout:** Single focus
- **Background:** Dark gradient
- **Center:** 3D hammer icon (MCP tool icon) glowing
- **Text:** "Give Claude SUPERPOWERS"
- **Subtext:** "Build MCP Server Tutorial"

### Colors:
- Primary: Anthropic purple (#D4A5A5 or similar)
- Secondary: Code green (#4EC9B0)
- Accent: White text with dark background

---

## 📝 DESCRIPTION TEMPLATE

```
Learn how to build an MCP (Model Context Protocol) server and connect Claude to any API or tool. This step-by-step tutorial shows you how to create a production-ready Hacker News MCP server in 25 minutes.

🚀 What You'll Build:
• Hacker News AI Assistant MCP Server
• 3 tools: get_top_stories, search_stories, get_story_details
• Live integration with Claude Desktop

📚 Resources:
• GitHub Code: [LINK]
• MCP Documentation: https://modelcontextprotocol.io
• Python SDK: https://github.com/modelcontextprotocol/python-sdk

⏱️ Timestamps:
0:00 - What is MCP and why it matters
2:30 - Environment setup
5:30 - Building the server
17:00 - Configuring Claude Desktop
20:00 - Testing and demonstration
24:00 - Next steps and deployment

🛠️ Requirements:
• Python 3.10+
• UV package manager
• Claude Desktop

💡 What is MCP?
Model Context Protocol is an open standard by Anthropic that lets AI models connect to external tools through a standardized interface. Think USB-C for AI applications.

📈 Who uses MCP?
GitHub (15k+ stars), Microsoft, AWS, MongoDB, Sentry, and more.

🔔 Subscribe for more AI development tutorials!

#MCP #Claude #AI #Tutorial #Python #DeveloperTools #ModelContextProtocol #Anthropic
```

---

## 🏷️ TAGS

Primary: MCP, Model Context Protocol, Claude, AI Tutorial, Python
Secondary: Anthropic, Developer Tools, API Integration, Coding Tutorial, AI Agents
Long-tail: how to build MCP server, MCP tutorial 2025, Claude MCP tools, MCP Python SDK

---

## ✅ PRE-FLIGHT CHECKLIST

- [ ] Code tested and working
- [ ] Claude Desktop configured
- [ ] All three tools functional
- [ ] Screen recording software ready
- [ ] Audio levels tested
- [ ] Thumbnail designed
- [ ] Description written
- [ ] Tags researched
- [ ] End screen created
- [ ] GitHub repo with code ready

---

*Script Version: 1.0*
*Ready for production*
