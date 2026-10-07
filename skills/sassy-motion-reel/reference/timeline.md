# timeline.json — the fill-in-the-blanks file

Everything on screen comes from `motion/timeline.json`. Paths are relative to the
project folder. Times are seconds, taken from `work/words.json` (put each change
on the word it belongs to). Frame size is always 1080x1920.

## Top level

| Key | What it is |
|---|---|
| `end` | Video length in seconds |
| `subjectOffsetY` | How far the cut-out person is shifted down (default 300) |
| `palette` | `accent` (loudest color), `accent2` (support), `soft` (light tint) |
| `plates` | Background images: `{src, from, to}`. Empty = free brand gradient |
| `words` | Big words. Behind the person by default |
| `takeovers` | Full-screen moments. Person hidden, voice keeps playing |
| `cards` | Things in front of the person, at the edges |
| `captions` | `{words, fix, drop, hideAfter, top, off}` |

## words

`{"text","in","out","y","size","color","style","glow","strike","layer"}`
- `color`: `white`, `accent`, `accent2`, `soft`, `outline` (hollow step number), or a hex.
- `style: "serif"` = Playfair italic accent word. Use for one punch word, not every line.
- `strike`: time a bar slashes through it ("you don't need ChatGPT").
- `layer: "front"` puts it on top (use during takeovers, when the person is hidden).
- Behind-words live in y 230–700 so they show above and around the head.
- Long words auto-shrink to stay inside the safe width.

## takeovers

- `pan`: `{src, in, out, num, title, keys:[[t,zoom,x,y]], pill:{text,in}}`. A wide image
  (set sheet, screenshot) that zooms into areas on the beat.
- `flip`: `{images:[[t,src],...], in, out, num, title}`. Vertical images that flip on words.
- `frames`: `{dir, count, in, out, num, title, tag, rec, stamp:{text,in}}`. Plays a video
  as a JPG sequence (see SKILL.md step 6). `rec:false` swaps the red dot for a sparkle.

## cards

All take `x, y, in, out, rot` and optional `w, h, from` (`left|right|bottom|top`).
- `phone`: `{src}`, an app screenshot in a phone frame (250px wide).
- `image`: `{src, w, h}`.
- `frames`: `{dir, count, w, h, tag}`, a small playing clip.
- `strip`: `{srcs:[...]}`, a vertical column of thumbnails.
- `pill`: `{text, icon, accent}`. Icons: arrow, check, x, plus, folder, terminal,
  file, pencil, coin, clock, chip, sparkle, search.
- `stamp`: `{text}`, a big check-mark stamp ("Kept", "Done").
- `tool`: `{text, bg, fg, xAt}`, a brand name in its colors; `xAt` = time the orange X lands.
- `cta`: `{label, word, sub}`, the end card ("Comment the word" / CREATE / Link in bio).
- `sparkle`: `{color, size}`. Two per video, max.

## Safe zone (Instagram + TikTok)

Keep everything that matters inside x 60–940 and y 230–1580. Below y 1100 the
right edge stops at ~940 (like/comment/share buttons). Cards at the edges:
left cards x≈60, right cards x≈740 for 240px wide. Never on the face.

See `examples/production-house/timeline.json` for a full, working 85-second reel.
