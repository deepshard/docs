# Truffle Weekly Email — README

A markdown-driven email template. Edit `updates/current.md`, refresh `Truffle Weekly Email.html`, and when ready click **Download HTML** to get a self-contained file (no preview bar, no fetches, logo inlined) you can paste/send as the actual email.

---

## File layout

```
Truffle Weekly Email.html   ← open this in your browser
updates/current.md          ← this is what you edit every week
assets/truffle-logo.png     ← logo (inlined automatically on download)
```

## Markdown structure

A weekly update file has three parts, in order:

```
1. Front matter   (top block between --- lines)
2. Sections       (# Software, # Hardware, # Firmware, # FYI)
3. Sign-off       (after a lone --- separator)
```

### 1 · Front matter

Between two `---` lines at the top:

```md
---
dates: Apr 13 — Apr 19
greeting: Hey Monsieur Victor
intro: Quick note from Brooklyn — short summary below; scroll down for details.
---
```

| Key        | What it does                                             |
|------------|----------------------------------------------------------|
| `dates`    | Shown at the top-right next to the logo                  |
| `greeting` | Opening line (e.g. "Hey Monsieur Victor")                |
| `intro`    | Short paragraph under the greeting                       |

> You can include old keys like `issue:` / `week:` — they are ignored now.

### 2 · Sections

Each section is a `#` heading. Three are recognized for updates:

```md
# Software
# Hardware
# Firmware
```

…plus a free-form one for anything else:

```md
# FYI
```

(`# Note` or `# Notes` use the same card style if you prefer that heading.)

**Empty sections are automatically hidden.** If there's no hardware news this week, just leave `# Hardware` empty (or delete it).

### 3 · Update entries

Inside `# Software` / `# Hardware` / `# Firmware`, add any number of `## Update` entries:

```md
## Update
title: The weird model responses should be much better.
version: truffle-os v3.8.2
body: We rebuilt the sampling loop and tightened a few things in the routing layer.

If you were seeing occasional off-topic replies, please try it again.
```

| Field     | Notes                                                                 |
|-----------|-----------------------------------------------------------------------|
| `title`   | One-line headline for the update                                      |
| `version` | Small mono label on the right (e.g. `truffle-os v3.8.2`, `rolling`)   |
| `body`    | Paragraph(s). Blank line between paragraphs. Supports inline markdown |
| `images`  | Optional image URLs (one per line or `- https://...`). Max 3 per row |
| `videos`  | Optional video URLs (one per line or `- https://...`). Max 3 per row |

Example with media:

```md
## Update
title: SDK refresh with visual examples.
version: sdk
body: Added docs and walkthrough clips.
images:
  - https://example.com/screenshot-1.jpg
  - https://example.com/screenshot-2.jpg
videos:
  - https://example.com/demo.mp4
```

Media cards are rounded, and clicking any image/video opens the original URL in full size.

### 4 · FYI (generic free-form blocks)

Inside `# FYI`, add any number of `## FYI` entries with a free `title` and `body`. Use this for install instructions, call-booking, reminders, anything that isn't software / hardware / firmware:

```md
# FYI

## FYI
title: How to install
body: If your Truffle was plugged in today, it's already updated. Otherwise power it on and let it download — takes about **10 minutes**.

## FYI
title: Have you scheduled a call with us yet?
body: We do not collect any analytics — one-on-one chats are our only way to iterate.

[Book a call →](https://cal.com/truffle)
```

The `##` heading can also be `## Note` when the section is `# Note` or `# Notes`; the renderer treats `# FYI`, `# Note`, and `# Notes` as the same “tinted card” layout.

### 5 · Sign-off

After a lone `---` line at the bottom, add the closing:

```md
---

signoff: Please let us know any feedback — if there are issues we'll get them sorted. Thanks for all your support.
sign_warm: Lots of love,
sign_name: — Team Truffle
```

---

## Inline markdown

These work anywhere — titles, bodies, greetings, the `dates` field, sign-off lines, everywhere:

| Syntax             | Result            |
|--------------------|-------------------|
| `[text](url)`      | link              |
| `**text**`         | **bold**          |
| `` `text` ``       | `mono / code`     |

Blank line between paragraphs = new paragraph.

---

## Downloading the final email

1. Open `Truffle Weekly Email.html` in the browser (through a local server, not `file://`).
2. Edit `updates/current.md` and refresh to preview.
3. Click the red **Download HTML** button at the top.
4. You'll get `truffle-weekly.html` — fully self-contained, no preview bar, logo baked in. Open it to double-check, then send.

---

## Quick example

```md
---
dates: Apr 13 — Apr 19
greeting: Hey Monsieur Victor
intro: Quick note from LA — new update is out.
---

# Software

## Update
title: Stable inference — much better weird-response behavior.
version: truffle-os v3.8.2
body: Rebuilt the sampling loop. Please [let us know](#) how it feels.

# Hardware

# Firmware

## Update
title: Small firmware bump, bundled with the OS update.
version: 0x4A17 · rolling
body: Minor wake-behavior tweaks. Installs in the same 10-minute window.

# FYI

## FYI
title: How to install
body: Power on your Truffle and let it download. About **10 minutes**.

---

signoff: Thanks for all your support.
sign_warm: Lots of love,
sign_name: — Team Truffle
```
