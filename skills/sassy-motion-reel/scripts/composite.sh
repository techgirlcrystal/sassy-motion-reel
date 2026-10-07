#!/bin/bash
# Stack the layers: back (words) -> speaker cut-out -> front (cards, captions) + voice + music.
# Usage: composite.sh <project_dir> <scale 0.5|1> <back.mp4> <front.mov> <out.mp4> [music.mp3] [offsetY=300] [end]
set -e; P=$1; S=$2; BACK=$3; FRONT=$4; OUT=$5; MUS=${6:-}; OY=${7:-300}; END=${8:-}
cd "$P"
W=$(python3 -c "print(int(1080*$S))"); H=$(python3 -c "print(int(1920*$S))"); Y=$(python3 -c "print(int($OY*$S))")
[ -z "$END" ] && END=$(ffprobe -v error -show_entries format=duration -of csv=p=0 talk.mp4)
if [ -n "$MUS" ]; then MIN=(-i "$MUS"); AF="[1:a]aformat=channel_layouts=stereo[va];[4:a]atrim=0:$END,volume=0.16,afade=t=in:d=0.6,afade=t=out:st=$(python3 -c "print($END-1.8)"):d=1.8[ma];[va][ma]amix=inputs=2:duration=first:normalize=0[a]"; else MIN=(); AF="[1:a]aformat=channel_layouts=stereo[a]"; fi
ffmpeg -v error -stats -y -i "$BACK" -i talk.mp4 -framerate 30 -i work/masks/%05d.png -i "$FRONT" "${MIN[@]}" -filter_complex "\
[1:v]scale=$W:$H[hv];[2:v]scale=$W:$H,format=gray,gblur=sigma=$(python3 -c "print(2*$S)")[m];[hv][m]alphamerge[h];\
[0:v][h]overlay=0:$Y:shortest=1[bh];[bh][3:v]overlay=0:0,format=yuv420p[v];$AF" \
 -map "[v]" -map "[a]" -t "$END" -c:v libx264 -crf $([ "$S" = "1" ] && echo 18 || echo 22) -preset medium -c:a aac -b:a 192k -movflags +faststart "$OUT"
echo "made $OUT"
