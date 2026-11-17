---
name: visualize
description: Show charts, diagrams and comparisons inline in a T3 Code thread with the t3-code `html_preview` and `html_render` tools. Use whenever a reply carries data with a trend or comparison (timings, sizes, counts over time, before/after), an architecture or flow explanation, or the user asks to "show", "chart", "plot", "graph", "diagram" or "visualize" something in this thread. Not for a chart component in the user's codebase, an image to post elsewhere (write a .png instead), or saving into a site's own dashboard.
---

# Visualize

One self-contained HTML page, previewed headless, then rendered inline above the reply. The page inherits the user's live T3 theme, so it must be built from theme variables and nothing else.

## Workflow

1. **Decide the form** (chart type, diagram, table). For charts, load the `dataviz` skill for form and mark choices; this skill only covers the T3 mechanics.
2. **Write the page** to `<scratchpad>/viz/<slug>.html`, copied from the closest template (below). Start with `<!doctype html>`.
3. **Preview:** `html_preview {path, appearance:"dark", width:728}`. Read the PNG and `consoleMessages`. Fix errors, missing images, clipped labels.
4. **Check light + phone** when the page has colour logic or a wide layout: `appearance:"light"`, then `width:390`.
5. **Render:** `html_render {path, title, height: contentHeight}`. Title is a 2 to 5 word name.
6. **Reply** with only what the page does not say. Never describe or restate the visual.

Revising: edit the file, preview again, render again by `path`. A render is a snapshot; editing the file later changes nothing.

Tools are deferred in Claude Code: `ToolSearch select:mcp__t3-code__html_preview,mcp__t3-code__html_render` first.

## Hard rules (rejected or broken otherwise)

- **No `vh`/`svh`/`dvh`/`lvh`** anywhere in CSS. Error: "The page uses a viewport height unit". No `height:100%` on `html`/`body`; the frame grows to the page and loops.
- **No page background.** Leave `html`, `body` and the outer wrapper unpainted: no outer card, border, banner title, or side padding. T3 paints `--background` and adds an 8px gutter.
- **No hard-coded colours.** Never `#000`, `black`, `#fff`, `white`. Use the variables below.
- **Fixed pixel heights** for charts (`height:280px`), fluid widths (`width:100%`, viewBox SVG).
- **Self-contained.** Inline `<style>`/`<script>`. CDN scripts load (public network only, no localhost). Local images: absolute paths, auto-inlined (10 MiB each).
- **Sandbox:** opaque origin. No `localStorage`, cookies, `alert`, `window.open`, `<a download>`. Hover, tooltips, clicks, forms work.

## Theme variables

| Use | Variables |
|---|---|
| Text | `--foreground`, `--muted-foreground` |
| Surfaces (inner boxes only) | `--card`, `--muted`, `--secondary`, `--popover`, `--code-background` |
| Lines, grid | `--border`, `--input` |
| Series | `--chart-1` … `--chart-6` (1 = user's accent) |
| Status | `--success`, `--warning`, `--destructive`, `--info` (+ `-foreground`; warning/destructive/accent have `-surface`) |
| Shape, type | `--radius`, `--font-sans`, `--font-mono` |

An inner box that needs its own background gets `padding:16px; border-radius:var(--radius)`.

**Live theme switches** rewrite these variables in place. CSS and SVG `fill="var(--chart-1)"` follow automatically. Canvas/JS libraries that read colours once go stale: prefer SVG with CSS variables, or redraw on `message` events where `data.method === "ui/notifications/host-context-changed"`.

## Templates

All in `templates/`, previewed clean in dark, light, 728px and 390px. Edit the data block at the top of the script; keep the CSS.

| File | Use for |
|---|---|
| `base.html` | Empty skeleton: takeaway, slot, note |
| `bar.html` | Comparisons, rankings, before/after numbers. CSS-grid horizontal bars, `dim` class for context rows |
| `line.html` | Trends over time, up to 6 series. JS-drawn SVG sized to `clientWidth`, round ticks, end labels, hover tooltip |
| `flow.html` | Pipelines, request paths, architecture. Flex nodes + arrows, stacks vertically under 520px, `accent` marks the changed node |

## Choosing the medium

**Never use a fixed `viewBox` SVG with text in it.** It scales down at phone width and labels become unreadable. Draw SVG from JS at `svg.clientWidth` (as `line.html` does) or use CSS layout (as `bar.html` does).

| Need | Use |
|---|---|
| Bar, line, area, small multiples, ≤ ~500 points | The templates: CSS or JS-drawn SVG (no deps, theme-perfect) |
| Many points, zoom, complex axes | Chart.js or d3 from cdnjs, colours read from CSS vars + redraw on theme message |
| Flow, architecture, sequence | Inline SVG, or Mermaid from jsDelivr with `themeVariables` from CSS vars |
| Before/after, option compare | CSS grid of two columns, collapses to one under 520px |
| Image the user will post/send | Not this skill: write a `.png` and give its path |

## Layout

- Frame is 728px on desktop, ~360px on phones. Design at 728, verify at 390.
- Lead with the takeaway as a short `h3`-weight line in `--foreground`, axis labels and notes in `--muted-foreground`, 12px.
- Label series directly at line ends instead of a legend when there are 4 or fewer.
- Numbers in `font-variant-numeric: tabular-nums`.

## When not to use

- Refactoring or building a chart component in the project (ordinary code task).
- Faux product UI or marketing mockups: use `stageshow`.
- User asked for a file or an image to share: write it, give the path.
- One sentence covers it.
