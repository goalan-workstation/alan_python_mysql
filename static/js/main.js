// 星空粒子 + 打字機 + 進場動畫 + 3D卡片 + 表單AJAX + 回頂部
(function(){
  // 粒子星空
  const cv = document.getElementById('stars');
  if(cv){
    const ctx = cv.getContext('2d');
    let W,H,ps=[];
    function rs(){W=cv.width=innerWidth;H=cv.height=innerHeight;}
    rs(); addEventListener('resize',rs);
    for(let i=0;i<130;i++) ps.push({x:Math.random()*innerWidth,y:Math.random()*innerHeight,r:Math.random()*2+.4,s:Math.random()*.7+.15,o:Math.random()*.7+.2});
    let mx=-999,my=-999;
    addEventListener('mousemove',e=>{mx=e.clientX;my=e.clientY;});
    (function loop(){
      ctx.clearRect(0,0,W,H);
      ps.forEach(p=>{
        p.y-=p.s; if(p.y<-4){p.y=H+4;p.x=Math.random()*W;}
        const dx=p.x-mx,dy=p.y-my,d=Math.sqrt(dx*dx+dy*dy);
        if(d<120){p.x+=dx/d*1.2;p.y+=dy/d*1.2;}
        ctx.globalAlpha=p.o;
        ctx.fillStyle=p.r>1.4?'#7df9ff':'#ffffff';
        ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,7);ctx.fill();
      });
      ctx.globalAlpha=1;
      requestAnimationFrame(loop);
    })();
  }
  // 打字機
  const words=['Python 後端開發','Flask 全端應用','MySQL 資料庫設計','JS 科技特效','CRUD 系統實作'];
  const el=document.getElementById('typed');
  if(el){
    let wi=0,ci=0,del=false;
    (function tick(){
      const w=words[wi];
      el.textContent='▸ '+w.slice(0,ci);
      if(!del){ci++; if(ci>w.length){del=true;return setTimeout(tick,1200);}}
      else{ci--; if(ci===0){del=false;wi=(wi+1)%words.length;}}
      setTimeout(tick,del?38:85);
    })();
  }
  // 進場動畫
  const io=new IntersectionObserver(es=>es.forEach(e=>{if(e.isIntersecting){e.target.classList.add('show');io.unobserve(e.target);}}),{threshold:.12});
  document.querySelectorAll('.reveal').forEach(n=>io.observe(n));
  // 技能條
  const bio=new IntersectionObserver(es=>es.forEach(e=>{if(e.isIntersecting){
    e.target.querySelectorAll('.bar i').forEach(b=>{b.style.transition='width 1.2s ease';b.style.width=b.dataset.w+'%';});
    bio.unobserve(e.target);}}),{threshold:.3});
  document.querySelectorAll('.skills').forEach(n=>bio.observe(n));
  // 3D 傾斜卡片
  document.querySelectorAll('[data-tilt]').forEach(card=>{
    card.addEventListener('mousemove',e=>{
      const r=card.getBoundingClientRect();
      const x=(e.clientX-r.left)/r.width-.5, y=(e.clientY-r.top)/r.height-.5;
      card.style.transform=`perspective(900px) rotateY(${x*10}deg) rotateX(${-y*10}deg) translateY(-8px)`;
    });
    card.addEventListener('mouseleave',()=>{card.style.transform='';});
  });
  // 作品篩選
  const btns=document.querySelectorAll('[data-filter]');
  const items=document.querySelectorAll('[data-cat]');
  btns.forEach(b=>b.addEventListener('click',()=>{
    btns.forEach(x=>x.classList.remove('btn'));btns.forEach(x=>x.classList.add('btn-ghost'));
    b.classList.add('btn');b.classList.remove('btn-ghost');
    const f=b.dataset.filter;
    items.forEach(it=>{
      const show=f==='全部'||it.dataset.cat===f;
      it.style.display=show?'':'none';
      if(show){it.classList.remove('show');requestAnimationFrame(()=>requestAnimationFrame(()=>it.classList.add('show')));}
    });
  }));
  // 聯絡表單 AJAX
  const form=document.getElementById('contactForm');
  const toast=document.getElementById('toast');
  function showToast(msg){ if(!toast) return; toast.textContent=msg; toast.classList.add('show'); setTimeout(()=>toast.classList.remove('show'),3200); }
  if(form){
    form.addEventListener('submit',async e=>{
      e.preventDefault();
      const fd=new FormData(form);
      try{
        const r=await fetch(form.action,{method:'POST',body:fd,headers:{'X-Requested-With':'XMLHttpRequest'}});
        const j=await r.json();
        showToast(j.msg||(j.ok?'已送出!':'送出失敗'));
        if(j.ok) form.reset();
      }catch(err){ showToast('送出失敗,請稍後再試'); }
    });
  }
  // 回頂部
  const top=document.getElementById('toTop');
  if(top){ top.addEventListener('click',()=>scrollTo({top:0,behavior:'smooth'})); }
})();
