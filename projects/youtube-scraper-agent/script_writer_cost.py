#!/usr/bin/env python3
"""
Script Writer Module for YouTube Scraper Agent - COST ANALYSIS CHANNEL
Writes product breakdown and cost analysis video scripts.
"""

from datetime import datetime
from pathlib import Path

OUTPUT_DIR = Path("/root/.openclaw/workspace/projects/youtube-scraper-agent")


def write_cost_analysis_script(product: str, retail_price: str, estimated_cost: str, 
                                key_components: list, target_duration: int = 12):
    """
    Write a complete COST BREAKDOWN video script.
    
    Args:
        product: Product name (e.g., "iPhone 16 Pro")
        retail_price: Retail price with currency (e.g., "$999")
        estimated_cost: Estimated production cost (e.g., "$450")
        key_components: List of cost components [(name, cost, percentage), ...]
        target_duration: Target video length in minutes
    """
    
    # Calculate margin
    try:
        retail = float(retail_price.replace('$', '').replace(',', ''))
        cost = float(estimated_cost.replace('$', '').replace(',', ''))
        margin = retail - cost
        margin_pct = (margin / retail) * 100
    except:
        margin = "TBD"
        margin_pct = "TBD"
    
    script = f"""# Cost Breakdown Script: {product}

**Product:** {product}
**Retail Price:** {retail_price}
**Est. Production Cost:** {estimated_cost}
**Est. Margin:** {margin} ({margin_pct}%)
**Target Duration:** {target_duration} minutes
**Generated:** {datetime.now().strftime('%Y-%m-%d')}

---

## 🎬 HOOK (First 45 seconds)

*[Visual: Product in hand / dramatic lighting / price tag visible]*

**Line 1 (Price Shock):**
"This [product] costs {retail_price}. But here's what nobody tells you — it only costs about {estimated_cost} to actually make."

*[Pause for effect]*

**Line 2 (Curiosity Gap):**
"So where does the other [margin] go? And more importantly — who's pocketing it?"

**Line 3 (Promise):**
"In the next {target_duration} minutes, I'm breaking down every single component, every hidden fee, and the shocking truth about why you're paying what you're paying."

*[Cut to animated cost breakdown graphic]*

---

## 📖 INTRO (45 seconds - 1.5 minutes)

*[Visual: You talking to camera with product on table]*

"Before we dive into the numbers, let me explain how I got these figures.

I spent [X hours/days] researching supply chain reports, tear-down analyses from [sources like iFixit, TechInsights], manufacturing cost estimates from industry insiders, and financial reports from [company].

These aren't exact figures — companies guard this stuff like state secrets — but they're based on the best available data.

Here's what we're covering:
"

*[Animated list appears on screen:]*
- The Bill of Materials — every component and its cost
- Manufacturing and assembly — where it's made and why that matters
- Research and development — the hidden cost of innovation
- Marketing and distribution — how much goes to ads and retail
- Profit margin — who's actually making money here

"Let's start with the most expensive part..."

---

## 💰 THE BILL OF MATERIALS (BOM)

*[Visual: Exploded view animation or component diagram]*

"The Bill of Materials — or BOM — is the complete list of every physical component in this product."

"""
    
    # Add each component
    for i, (component, cost, pct) in enumerate(key_components[:6], 1):
        script += f"""### {i}. {component}

*[Visual: Close-up of component / supplier footage]*

"The {component} costs approximately {cost} — that's about {pct} of the total production cost.

[Explain what this component does and why it costs what it costs]

**Key insight:** [Interesting fact about this component's sourcing or pricing]

---

"""
    
    script += f"""## 🏭 MANUFACTURING & ASSEMBLY

*[Visual: Factory footage / assembly line / location map]*

"So we've got all the parts. Now someone has to put them together.

This product is manufactured in [location] by [manufacturer if known]. The estimated assembly cost is [cost] per unit.

**Why [location]?**

[Explain labor costs, expertise, supply chain proximity, trade considerations]

**Labor cost breakdown:**
- Direct labor: [cost]
- Factory overhead: [cost]
- Quality control: [cost]

---

## 🔬 RESEARCH & DEVELOPMENT

*[Visual: R&D lab footage / patent diagrams / engineer interviews]*

"Here's where it gets interesting. That {estimated_cost} production cost? It doesn't include the billions spent on research and development.

[Company] spends approximately [R- figure] annually on R&D. Spread across [units sold], that's roughly [R&D per unit] per device.

**What you're actually paying for:**
- [Specific technology/feature 1]
- [Specific technology/feature 2]
- [Years of research]
- [Patent licensing fees]

---

## 📢 MARKETING & DISTRIBUTION

*[Visual: Ads / retail stores / shipping / unboxing]*

"Now let's talk about getting this product into your hands.

**Marketing costs:** Approximately [cost] per unit
- Digital advertising
- Retail partnerships
- Launch events
- Influencer campaigns

**Distribution costs:** Approximately [cost] per unit
- Shipping from factory
- Warehousing
- Retail markup (if applicable)
- Last-mile delivery

**The retail reality:**
[Explain retail margins — Apple Store vs carrier vs Amazon, etc.]

---

## 💵 THE FINAL BREAKDOWN

*[Visual: Animated pie chart or stacked bar showing full breakdown]*

"Let's put it all together. For every {retail_price} {product} sold:

| Category | Cost | % of Retail |
|----------|------|-------------|
"""
    
    # Add component rows
    for component, cost, pct in key_components[:5]:
        script += f"| {component} | {cost} | {pct} |\n"
    
    script += f"""| Assembly | [cost] | [%] |
| R&D (amortized) | [cost] | [%] |
| Marketing | [cost] | [%] |
| Distribution | [cost] | [%] |
| **TOTAL COST** | **{estimated_cost}** | **[~X%]** |
| **PROFIT MARGIN** | **~{margin}** | **~{margin_pct}%** |

---

## 🤔 THE BIGGER PICTURE

*[Visual: Industry comparison / competitor analysis]*

"So is this a fair price? Let's look at the context.

**Industry comparison:**
- [Competitor 1]: [X]% margin
- [Competitor 2]: [Y]% margin
- Industry average: [Z]%

**What you're REALLY paying for:**
1. **Brand premium** — [Company] charges more because they can
2. **Ecosystem lock-in** — You're buying into [ecosystem]
3. **Status signal** — Let's be honest, part of the price is the logo
4. **Convenience** — Integration, support, warranty

**The counter-argument:**
[Company defenders would say... R&D investment, quality, innovation, etc.]

---

## 🎯 VERDICT

*[Visual: You with product, summary graphic]*

"So what's the verdict? Is the {product} worth {retail_price}?

**If you value:** [List what the product delivers]
**Then yes.** You're paying for [key benefits].

**But if you:** [Alternative use case]
**Consider:** [Cheaper alternative]

The {margin} margin isn't pure profit — it funds next year's innovation, pays for [company's] ecosystem, and yes, rewards shareholders.

But now you know exactly where your money goes."

---

## 🎬 CTA / OUTRO (30 seconds)

*[Visual: Product lineup / channel branding]*

"What product should I break down next? Drop it in the comments — I'll research the most requested one.

And if you want to see how much [related product] costs to make, watch this video next.

Hit subscribe for more cost breakdowns that pull back the curtain on what you're really paying for.

See you in the next one."

---

## 🖼️ THUMBNAIL CONCEPT

**Primary Visual:** 
- Product on left side, clearly visible
- Your face on right with "shocked" or "thinking" expression
- Price tag or dollar sign element

**Text Overlay:**
- Line 1: "${retail_price} Retail"
- Line 2: "${estimated_cost} To Make"
- Line 3: "The Truth"

**Color Scheme:** 
- High contrast (red for cost, green for retail, or vice versa)
- Bold, readable font
- Arrow or graphic showing the gap

**Thumbnail Formula:** [Product] + [Price Contrast] + [Curiosity Hook]

---

## 📋 RESEARCH CHECKLIST

Before recording, verify:
- [ ] Component costs from [iFixit / TechInsights / supply chain reports]
- [ ] Manufacturing location and labor costs
- [ ] Company R&D spending (annual report)
- [ ] Marketing spend estimates
- [ ] Competitor pricing for comparison
- [ ] Recent news about supply chain changes
- [ ] Exchange rates (if manufacturing overseas)

## 🏷️ SUGGESTED TAGS

{product.lower()}, cost breakdown, how much does it cost, manufacturing cost, bill of materials, supply chain, why is {product.lower()} so expensive, profit margin, business analysis, teardown

## 📊 SUCCESS METRICS TO TRACK

- CTR target: 10%+ (price in title drives clicks)
- AVD target: 50%+ (cost breakdowns have high retention)
- Like rate: 5%+
- Comment rate: 2%+ (people debate the numbers)
- **Key metric:** Comment quality — are people sharing insider info?

---

*Script generated by YouTube Scraper Agent — Cost Analysis Edition*
"""
    
    return script


def save_script(product: str, script_content: str):
    """Save script to file."""
    # Clean filename
    clean_product = "".join(c if c.isalnum() or c in (' ', '-') else '_' for c in product)
    clean_product = clean_product.replace(' ', '-').lower()[:50]
    
    filename = f"script-cost-breakdown-{clean_product}.md"
    filepath = OUTPUT_DIR / filename
    
    filepath.write_text(script_content)
    print(f"✅ Cost analysis script saved: {filepath}")
    return filepath


# Example usage
if __name__ == "__main__":
    # Example: iPhone cost breakdown
    example_components = [
        ("Display", "$110", "24%"),
        ("Processor", "$70", "16%"),
        ("Camera System", "$60", "13%"),
        ("Storage", "$45", "10%"),
        ("Battery", "$15", "3%"),
        ("Other Components", "$150", "34%")
    ]
    
    script = write_cost_analysis_script(
        product="iPhone 16 Pro",
        retail_price="$999",
        estimated_cost="$450",
        key_components=example_components,
        target_duration=12
    )
    
    save_script("iPhone 16 Pro Cost Breakdown", script)
    print("\n💰 Sample cost analysis script generated!")
