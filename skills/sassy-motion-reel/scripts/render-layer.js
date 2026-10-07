// Render one layer of the reel to video. Run from the project's motion/ folder with a server on the project root.
// node render-layer.js <back|front> <out> <scale 0.5|1> <subframes 1|2> [t0] [t1] [port=8765]
// back -> H.264 mp4 (opaque). front -> ProRes 4444 .mov (transparent). subframes 2 = motion blur (back layer only).
const {chromium}=require('playwright');const {spawn}=require('child_process');
(async()=>{
 const [layer,out,sc,K0,t0a,t1a,port]=process.argv.slice(2);const SCALE=+sc,K=+K0||1,FPS=30,PORT=port||8765;
 const W=Math.round(1080*SCALE),H=Math.round(1920*SCALE);
 const b=await chromium.launch();const p=await b.newPage({viewport:{width:W,height:H}});
 const errs=[];p.on('pageerror',e=>errs.push(e.message));p.on('console',m=>{if(m.type()==='error')errs.push(m.text())});
 await p.goto(`http://localhost:${PORT}/motion/reel.html?layer=${layer}&scale=${SCALE}`);await p.evaluate(()=>window.ready);
 const T0=+(t0a||0),T1=+(t1a||await p.evaluate(()=>window.DURATION));const N=Math.round((T1-T0)*FPS),sub=1/(FPS*2*K);
 const alpha=layer==='front';
 const vf=K>1?['-vf',`format=gbrap,tmix=frames=${K}:weights='${Array(K).fill(1).join(' ')}',select='eq(mod(n\\,${K})\\,${K-1})',setpts=N/(${FPS})/TB`]:[];
 const enc=alpha?['-c:v','prores_ks','-profile:v','4','-pix_fmt','yuva444p10le','-vendor','apl0']:['-c:v','libx264','-crf','16','-preset','fast','-pix_fmt','yuv420p'];
 const ff=spawn('ffmpeg',['-loglevel','error','-y','-f','image2pipe','-framerate',String(FPS*K),'-c:v','png','-i','-',...vf,'-r',String(FPS),...enc,out]);
 ff.stderr.on('data',d=>process.stderr.write(d));
 for(let f=0;f<N;f++){for(let k=0;k<K;k++){const t=T0+f/FPS+(K>1?(k-(K-1)/2)*sub:0);await p.evaluate(t=>window.seek(t),Math.max(0,t));
   const buf=await p.screenshot({type:'png',omitBackground:alpha});if(!ff.stdin.write(buf))await new Promise(r=>ff.stdin.once('drain',r));}
   if(f%300===0)console.log(layer,'frame',f,'/',N);}
 ff.stdin.end();await new Promise(r=>ff.on('close',r));await b.close();console.log('rendered',out,N,'frames',errs.length?'ERR '+errs.slice(0,3).join(' | '):'');
})();
