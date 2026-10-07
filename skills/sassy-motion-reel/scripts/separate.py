"""Cut the speaker out of every frame with SAM 2.1, on this computer.
Usage: .venv-reel/bin/python separate.py talk.mp4 work/masks "x,y;x,y" "x,y;x,y"
  first list = points ON the person, second = points on the background (960px-wide coords of frame 0).
Writes one PNG mask per frame (white = person). Prints progress every 60 frames."""
import os, sys, time, numpy as np, torch, cv2
from transformers import Sam2VideoModel, Sam2VideoProcessor
VIDEO, OUT = sys.argv[1], sys.argv[2]
pos = [[int(v) for v in p.split(",")] for p in sys.argv[3].split(";")]
neg = [[int(v) for v in p.split(",")] for p in sys.argv[4].split(";")] if len(sys.argv) > 4 and sys.argv[4] else []
PTS, LBL = pos + neg, [1]*len(pos) + [0]*len(neg)
if torch.cuda.is_available(): dev, MODEL = "cuda", "facebook/sam2.1-hiera-large"
elif torch.backends.mps.is_available(): dev, MODEL = "mps", "facebook/sam2.1-hiera-base-plus"
else: dev, MODEL = "cpu", "facebook/sam2.1-hiera-tiny"
print("device", dev, MODEL, flush=True)
model = Sam2VideoModel.from_pretrained(MODEL).to(dev).eval(); proc = Sam2VideoProcessor.from_pretrained(MODEL); W = 960
END = int(cv2.VideoCapture(VIDEO).get(cv2.CAP_PROP_FRAME_COUNT)) - 1
def read(a, b):
    cap = cv2.VideoCapture(VIDEO); cap.set(cv2.CAP_PROP_POS_FRAMES, a); out = []
    for _ in range(a, b + 1):
        ok, im = cap.read()
        if not ok: break
        out.append(cv2.cvtColor(cv2.resize(im, (W, int(im.shape[0]*W/im.shape[1]))), cv2.COLOR_BGR2RGB))
    return out
def chunk(fr, mask=None):
    H = fr[0].shape[0]
    s = proc.init_video_session(video=fr, inference_device=dev, video_storage_device="cpu", inference_state_device="cpu", dtype=torch.float32)
    if mask is None: proc.add_inputs_to_inference_session(inference_session=s, frame_idx=0, obj_ids=1, input_points=[[PTS]], input_labels=[[LBL]])
    else: proc.add_inputs_to_inference_session(inference_session=s, frame_idx=0, obj_ids=1, input_masks=mask.astype(np.uint8))
    r = {}
    with torch.inference_mode():
        model(inference_session=s, frame_idx=0)
        for o in model.propagate_in_video_iterator(s, start_frame_idx=0):
            r[o.frame_idx] = proc.post_process_masks([o.pred_masks], original_sizes=[[H, W]], binarize=True)[0].squeeze().cpu().numpy().astype(bool)
    return r
os.makedirs(OUT, exist_ok=True); a, seed, t0 = 0, None, time.time()
while a < END:
    b = min(END, a + 60); fr = read(a, b); r = chunk(fr, seed)
    for k, m in r.items(): cv2.imwrite(f"{OUT}/{a+k:05d}.png", m.astype(np.uint8)*255)
    seed, a = r[len(fr)-1], b
    print(f"frames {b}/{END}  {time.time()-t0:.0f}s", flush=True)
print("DONE", flush=True)
