#!/bin/bash
# Full HD final, both layers, split into 5 pieces each and rendered in parallel, then joined.
# Usage (from the project folder): bash render-final.sh <end_seconds> [port=8765]
set -e; END=$1; PORT=${2:-8765}; cd motion; mkdir -p ../final/parts
PTS=$(python3 -c "e=$END;import math;c=[round(e*i/5*30)/30 for i in range(6)];c[-1]=e;print(' '.join(f'{x:.4f}' for x in c))")
read -r -a C <<< "$PTS"
for L in back front; do EXT=mp4; [ $L = front ] && EXT=mov
  for i in 0 1 2 3 4; do NODE_PATH=./node_modules nohup node render-layer.js $L ../final/parts/$L-$i.$EXT 1 2 ${C[$i]} ${C[$((i+1))]} $PORT > ../final/parts/$L-$i.log 2>&1 & done; done
wait
cd ../final/parts
for L in back front; do EXT=mp4; [ $L = front ] && EXT=mov; : > $L.txt; for i in 0 1 2 3 4; do echo "file '$L-$i.$EXT'" >> $L.txt; done
  ffmpeg -v error -y -f concat -safe 0 -i $L.txt -c copy ../$L.$EXT; done
grep -h rendered *.log; echo "joined final/back.mp4 + final/front.mov"
