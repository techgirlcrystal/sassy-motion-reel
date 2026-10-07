#!/bin/bash
# One-time setup inside a project folder. Usage: bash setup.sh <project_dir>
set -e
P="${1:-.}"; SK="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$P"/{motion,work,bg,music,assets,ui,draft,final}
for c in node python3 ffmpeg; do command -v $c >/dev/null || { echo "Missing: $c  (Mac: brew install $c)"; exit 1; }; done
ffmpeg -hide_banner -encoders 2>/dev/null | grep -q prores_ks || echo "Heads up: this ffmpeg has no prores_ks encoder. Install with: brew install ffmpeg"
cp "$SK"/engine/reel.html "$SK"/engine/motion.js "$P"/motion/; cp -R "$SK"/engine/fonts "$P"/motion/
cp "$SK"/scripts/render-layer.js "$SK"/scripts/stills.js "$P"/motion/
cd "$P"/motion
[ -d node_modules/playwright ] || { echo '{"private":true}' > package.json; npm install --silent playwright; npx playwright install chromium; }
cd ..
[ -d .venv-reel ] || { python3 -m venv .venv-reel; .venv-reel/bin/pip -q install faster-whisper "av<14" torch torchvision transformers opencv-python-headless pillow numpy; }
echo "Ready. Project: $(pwd)"
