"""Word-level transcript, free and local. Usage: .venv-reel/bin/python transcribe.py talk.mp4 work/"""
import sys, json, subprocess, os
from faster_whisper import WhisperModel
video, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
wav = os.path.join(out, "audio.wav")
subprocess.run(["ffmpeg","-v","error","-y","-i",video,"-vn","-ac","1","-ar","16000",wav], check=True)
segs, _ = WhisperModel("small", compute_type="int8").transcribe(wav, word_timestamps=True)
W, lines = [], []
for s in segs:
    lines.append(f"[{s.start:6.2f}] {s.text.strip()}")
    W += [{"w": w.word, "s": round(w.start, 2), "e": round(w.end, 2)} for w in s.words]
json.dump(W, open(os.path.join(out, "words.json"), "w"))
open(os.path.join(out, "transcript.txt"), "w").write("\n".join(lines))
print("\n".join(lines))
