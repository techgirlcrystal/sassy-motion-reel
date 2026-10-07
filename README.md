# Sassy Motion Reel 🎬

**Turn one talking video into a reel that stops the scroll.**

You talk to your phone. This skill cuts you out of your background, puts big
words *behind* you right when you say them, slides your app screens in beside
you, adds captions to every word, and ends with "Comment ___" so people
actually reach out.

You're not learning to edit. You're learning to direct. Claude Code does the
wiring while you call the shots.

Made by **Lady Hale** · Sassypreneurs · Creative Space Academy

---

## What you get

- **You, cut out cleanly** from your real background (hair, braids, hands, all of it), on a dark cinematic stage
- **Big words behind you**, timed to the exact word you say
- **Your screens and photos** flying in at the edges, never on your face
- **Full-screen moments** when something needs to be seen, while your voice keeps going
- **Word-by-word captions** for everybody scrolling with the sound off
- **A "Comment WORD" ending** that turns viewers into leads
- **Safe-zone layout,** so Instagram and TikTok buttons never cover your words
- **A review page** where you leave notes on each moment, and Claude fixes them

## How it works

1. **480p draft first.** Cheap and fast, so you can see it before you commit.
2. **You leave notes** on a review page, moment by moment.
3. **Claude fixes every note** and marks it fixed.
4. **HD final** (1080x1920) only after you say "approved."

The slow part (cutting you out) runs **on your own computer for free.** Nothing
gets uploaded.

## Install

You need **Claude Code**, plus three free tools: Node, Python 3, and ffmpeg.
On a Mac, install the tools with Homebrew:

```bash
brew install node python ffmpeg
```

Then add the skill:

```bash
npx skills add techgirlcrystal/sassy-motion-reel
```

Or copy the `skills/sassy-motion-reel` folder into `~/.claude/skills/`.

## Use it

Open Claude Code in the folder with your video and type:

```
/sassy-motion-reel
```

Claude asks one question at a time: your colors, your "Comment ___" word, what
to show. Then it builds your draft. That's the whole job for you: answer, watch,
leave notes.

## What it costs

| Piece | Cost |
|---|---|
| Transcript, cut-out, graphics, rendering | **Free.** Runs on your computer |
| Cinematic backgrounds (optional, WaveSpeed) | About 3 cents each |
| Custom music (optional, Suno via KIE) | About 6 cents for two versions |

No WaveSpeed or KIE account? You still get a free brand-color background, and
you can bring your own music. Claude always tells you the real price before
spending anything.

## Good to know

- **A Mac with Apple Silicon** cuts you out at about 1 second per frame. An
  85-second video takes about 40 minutes, and Claude builds everything else
  while you wait.
- **Film vertical** (phone held up), face the light, keep your whole head in frame.
- **Your first video sets up the tools** (a few minutes). After that it's quick.

## Credits

- Motion engine helpers from [Bart's motion-graphics skills](https://github.com/Barty-Bart/motion-graphics) (MIT)
- Cut-out by SAM 2.1 (Meta), transcripts by faster-whisper
- Fonts: Montserrat and Playfair Display (SIL Open Font License)

## License

MIT. Use it, teach it, build on it.

---

**Errors are directions, not failures.** If something breaks, paste the error
into Claude Code and say "help me fix this." That's how we learn over here. 💜
