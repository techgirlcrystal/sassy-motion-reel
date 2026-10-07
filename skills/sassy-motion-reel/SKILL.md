---
name: sassy-motion-reel
description: Turn a talking-head video into a vertical 9:16 motion graphic reel. The speaker is cut out of their background with big words animating BEHIND them, app screens and cards in front, word-by-word captions, full-screen takeovers, brand music, and a "Comment WORD" ending. Use when someone wants a reel, a promo video, an explainer, motion graphics, "words behind me," a cut-out effect, captions on a talking video, or says "make my video pop" or "edit my video like a pro." Runs on their own computer, 480p draft and a review page with notes first, HD final after approval.
---

# Sassy Motion Reel

You turn one talking-head video into a scroll-stopping 9:16 reel. The person is
cut out of their real background and placed on a dark cinematic plate. Big words
slam in BEHIND them on the exact word they say. App screens and cards fly in
beside them. Captions follow every word. When something needs to be seen, it
takes over the full screen while their voice keeps going.

Created by Lady Hale (Sassypreneurs / Creative Space Academy).

**The person you're helping may be brand new to this. Talk to them like a big
sister sitting beside them:** one step at a time, plain English, a real-world
picture for every tech word, never "just" or "simply," no em-dashes. Wait for
them before moving to the next step.

`$SK` = this skill's folder. `$P` = their project folder (one per video).

## The rule that runs everything
**480p draft first. They watch it and leave notes. Then the HD final.**
Never spend money without quoting the real price first.

## 1. Set up (first time per project)
Ask where the video is. Make a project folder next to it (no spaces is easiest).
```bash
bash $SK/scripts/setup.sh "$P"
```
Installs Playwright (a robot browser that takes the photos) and the Python tools
(transcriber + cut-out) into the project. Takes a few minutes the first time.

## 2. Prepare the footage
Probe it with ffprobe. Phones often save sideways (rotation=90). Make a clean copy:
```bash
ffmpeg -i "<their video>" -vf "fps=30,scale=1080:1920" -c:v libx264 -crf 16 -c:a aac -b:a 192k "$P/talk.mp4"
```
If it isn't vertical, ask before cropping.

## 3. Transcribe (free, on their computer)
```bash
"$P/.venv-reel/bin/python" $SK/scripts/transcribe.py "$P/talk.mp4" "$P/work"
```
Show them the transcript. Fix obvious mishears in captions later with `captions.fix`.

## 4. Start the cut-out NOW (it's the slow part)
Look at frame 0 (export a 960px-wide still with a grid). Pick 2 points on the
person (face, chest) and 2 on the background. Then run it in the background:
```bash
cd "$P" && nohup .venv-reel/bin/python $SK/scripts/separate.py talk.mp4 work/masks "480,760;480,1520" "160,160;920,240" > work/sep.log 2>&1 &
```
About 1 second per frame on a Mac (an 85-second video is ~40 minutes). Check one
frame early (composite it on a dark background) to make sure it grabbed the whole
person, hands and hair included. Build everything else while it runs.

## 5. Interview, one question at a time
Only ask what you can't figure out. Typical order:
1. **Look:** dark cinematic (default), their brand colors, or light?
2. **Colors:** default accent #F26A21 + #8B4FD9, or theirs (put them in `palette`).
3. **CTA word:** "Comment ___" at the end. Where does the link live (bio)?
4. **What to show:** real screens beat AI fakes. If they have an app, capture it
   (they log in, you never type passwords). If not, ask for screenshots/photos.
5. **Paid extras (optional):** backgrounds and music. Quote real prices first.

## 6. Gather visuals
- **Real app screens:** browser at a phone size (375x812), hide chat widgets,
  screenshot each step. Download full-resolution images straight from the app
  when you can; screenshots are only phone-card sharp.
- **Videos inside the reel** play as JPG frames (a `<video>` tag won't render):
  `ffmpeg -ss 0 -t 3 -i clip.mp4 -vf fps=30 -q:v 3 "$P/motion/frames/<name>/%04d.jpg"`
- **Backgrounds** (optional, paid): WaveSpeed `bytedance/seedream-v4`, size
  `1440*2560`, about $0.03 each. Prompt: dark cinematic, the two brand colors as
  light, haze, empty center, "no people, no text, no letters, no logos." Run
  `wavespeed price` first. No WaveSpeed? Leave `plates` empty for a free gradient.
- **Music** (optional, paid): KIE Suno `ai-music-api/generate`, `custom_mode:true`,
  `instrumental:true`, `model:"V6"`, `duration` ≈ video length. ~12 credits for 2
  versions. Read the schema and price first (use the kie-models skill). Or they
  bring their own track. Music sits at 16% so the voice leads.
- **Competitor names** ("you don't need X"): brand names in brand colors with an
  orange X (`tool` cards). Not logos: logos with an X risk ad rejection.

## 7. Plan, then get a yes
Show a table: time | what they say | what's on screen | behind, front, or full screen.
- Words behind them on the key word of each line (y 230–700).
- Steps and processes: outlined step numbers (01, 02...) + the step name.
- When a line describes something to SEE (a product, a result, a video): full-screen takeover.
- Keep at least a little face time between takeovers. Hooks and personal lines stay on the face.
- Never invent numbers, prices or results. Only what they said or gave you.
- End: CTA card + the word huge behind them. Captions hide during the CTA.

## 8. Build the timeline
Copy `$SK/examples/production-house/timeline.json` to `$P/motion/timeline.json`
and rewrite it for this video. Format: `$SK/reference/timeline.md`. Serve the
project folder and check stills on the key words before any full render:
```bash
cd "$P" && (python3 -m http.server 8765 >/dev/null 2>&1 &)
cd "$P/motion" && NODE_PATH=./node_modules node stills.js ../work/s 2 8.5 14 30
```
Look at every still with the person composited in. Fix anything on the face,
cut off, unreadable, or outside the safe zone (x 60–940, y 230–1580).

## 9. The 480p draft
```bash
cd "$P/motion" && NODE_PATH=./node_modules node render-layer.js back out/back.mp4 0.5 1 &
cd "$P/motion" && NODE_PATH=./node_modules node render-layer.js front out/front.mov 0.5 1 &
# when both are done and the cut-out log says DONE:
bash $SK/scripts/composite.sh "$P" 0.5 motion/out/back.mp4 motion/out/front.mov draft/draft-480p.mp4 music/track.mp3
```
If they're waiting on the cut-out, stitch a sneak peek of the finished part.

## 10. Review page with notes
Publish `$SK/engine/review.html` as an Artifact with the `db` capability.
Replace `__REEL_NAME__`, fill `BEATS` (one per moment from the plan), and publish
the draft next to it as `draft.mp4` (re-encode to ~1.1 Mbps so it stays under
15 MB; copy both into the scratchpad first). When they say "notes are in," read
the `notes` collection, confirm what each one means (one question), fix, and mark
each note `status:"fixed"` with a short `reply`. Republish the new draft.

## 11. HD final (only after "approved")
```bash
cd "$P" && bash $SK/scripts/render-final.sh <end_seconds>
bash $SK/scripts/composite.sh "$P" 1 final/back.mp4 final/front.mov final/reel-1080.mp4 music/track.mp3
```
Renders 10 pieces in parallel with motion blur (~15 minutes on a 12-core Mac).
Check frames across the whole video before calling it done.

## Gotchas
- The person is placed full width, shifted down 300px. Don't shrink them (hard
  shirt edges) and don't feather the edges (looks ghostly).
- Run shell loops with `bash`, not zsh (zsh won't split "0 17" into two numbers).
- Pages must be served over http (file:// blocks loading the timeline).
- The Artifact tool only publishes files from the working dir or scratchpad.
- Cut-out masks are reused for every redraft. Only re-render the layers you changed:
  front-only changes take ~3 minutes at 480p.

## Credits
`engine/motion.js` is from Bart's motion-graphics skills (MIT, see
`engine/LICENSE-motion-js.txt`). Fonts: Montserrat and Playfair Display (SIL OFL).
SAM 2.1 by Meta. faster-whisper by SYSTRAN.
