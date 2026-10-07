// Quick check: render both layers at chosen seconds and stack them (with the speaker if a cut-out PNG is given).
// node stills.js <out_prefix> <t1> <t2> ...   -> <prefix>_b<i>.png + <prefix>_f<i>.png at 270x480
const {chromium}=require('playwright');
(async()=>{const [out,...ts]=process.argv.slice(2);const b=await chromium.launch();const errs=[];const PORT=process.env.PORT||8765;
 const mk=async l=>{const p=await b.newPage({viewport:{width:270,height:480}});p.on('pageerror',e=>errs.push(e.message));await p.goto(`http://localhost:${PORT}/motion/reel.html?layer=${l}&scale=0.25`);await p.evaluate(()=>window.ready);return p};
 const bk=await mk('back'),fr=await mk('front');let i=0;
 for(const t of ts){await bk.evaluate(t=>seek(t),+t);await fr.evaluate(t=>seek(t),+t);await bk.screenshot({path:`${out}_b${i}.png`});await fr.screenshot({path:`${out}_f${i}.png`,omitBackground:true});i++}
 await b.close();console.log('ok',errs.join('|'))})();
