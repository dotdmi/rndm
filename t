<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Vortix</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }

/* ===== CUSTOM CURSOR ===== */
body, .navbar, .nav-icon, .content-area, .settings-page, button {
    cursor: url('https://iili.io/fQ7GTUG.png'), auto;
}

/* ===== GRID BACKGROUND ===== */
body { background:#1a1a1a; color:white; height:100vh; width:100vw; overflow:hidden; display:flex; }
.grid { position:fixed; inset:0; background: repeating-linear-gradient(0deg, rgba(255,255,255,0.03) 0 1px, transparent 1px 40px), repeating-linear-gradient(90deg, rgba(255,255,255,0.03) 0 1px, transparent 1px 40px); z-index:-1; }

/* ===== POPUP ===== */
.popup-overlay { position: fixed; inset:0; background: rgba(0,0,0,0.65); backdrop-filter: blur(6px); display:flex; align-items:center; justify-content:center; z-index:100; animation: fadeIn 0.4s ease forwards; }
.popup-overlay.hide { animation: fadeOut 0.35s ease forwards; }
.popup { background: rgba(25,25,25,0.95); border-radius:24px; padding:36px 34px; width:360px; text-align:center; box-shadow:0 25px 60px rgba(0,0,0,0.6); animation: popIn 0.45s cubic-bezier(.2,1.3,.3,1) forwards; display:flex; flex-direction:column; gap:20px; }
.popup.hide { animation: popOut 0.35s ease forwards; }
.popup i { font-size:44px; color:#7CFF9B; margin-bottom:18px; }
.popup h2 { font-size:1.4rem; font-weight:700; margin-bottom:12px; }
.popup p { font-size:0.95rem; line-height:1.5; color:rgba(255,255,255,0.65); margin-bottom:8px; }
.popup button { background:white; color:black; border:none; padding:12px 26px; border-radius:999px; font-weight:700; cursor:pointer; transition:0.25s ease; }

/* ===== PAGE TRANSITIONS ===== */
.content > div { transition: opacity 0.3s ease; }
.fade-out { opacity:0; pointer-events:none; }
.fade-in { opacity:1; pointer-events:auto; }

/* ===== ANIMATIONS ===== */
@keyframes popIn { from { transform: scale(0.8); opacity:0; } to { transform: scale(1); opacity:1; } }
@keyframes popOut { to { transform: scale(0.85); opacity:0; } }
@keyframes fadeIn { from { opacity:0 } to { opacity:1 } }
@keyframes fadeOut { to { opacity:0 } }
@keyframes spin { to { transform:rotate(360deg); } }

/* ===== NAV BAR ===== */
.navbar { width:80px; height:80vh; margin:auto 20px; background: rgba(255,255,255,0.05); backdrop-filter:blur(18px); border-radius:20px; display:flex; align-items:center; justify-content:center; }
.nav-icons { display:flex; flex-direction:column; gap:30px; }
.nav-icon { font-size:22px; color:rgba(255,255,255,0.6); cursor:pointer; transition:0.25s ease; }
.nav-icon:hover { color:white; transform:scale(1.15); }
.nav-icon.active { color:white; }

/* ===== CONTENT ===== */
.content { flex:1; display:flex; align-items:center; justify-content:center; }
.home { text-align:center; }
.home h1 { font-size:clamp(4.5rem,7vw,6rem); font-weight:800; }
.home p { margin-top:14px; font-size:1.3rem; color:rgba(255,255,255,0.5); }

/* ===== IFRAME AREA ===== */
.content-area { width:100%; height:100%; display:none; align-items:center; justify-content:center; }
.frame-wrapper { width:85%; height:85%; background: rgba(0,0,0,0.35); backdrop-filter: blur(14px); border-radius:20px; position:relative; overflow:hidden; }
.loader { position:absolute; inset:0; display:flex; align-items:center; justify-content:center; z-index:10; pointer-events:none; }
.spinner { width:90px; height:90px; border:6px solid rgba(255,255,255,0.25); border-top:6px solid white; border-radius:50%; animation:spin 1s linear infinite; }
.frames { width:100%; height:100%; position:relative; }
.page-frame { position:absolute; inset:0; width:100%; height:100%; border:none; border-radius:20px; }
.hidden { display:none !important; }

/* ===== SETTINGS PAGE ===== */
.settings-page { display:none; width:85%; height:85%; background: rgba(25,25,25,0.95); border-radius:20px; padding:36px 34px; box-shadow:0 25px 60px rgba(0,0,0,0.6); flex-direction:column; gap:20px; overflow:auto; color:white; }
.settings-page button { width:100%; max-width:300px; background:white; color:black; border:none; padding:12px 26px; border-radius:999px; font-weight:700; cursor:pointer; transition:0.25s ease; }
.settings-page input[type="text"] { border-radius:12px; padding:12px; width:100%; max-width:300px; background: rgba(255,255,255,0.1); color:white; text-align:center; }
#waiting-popup { display:none; background:rgba(25,25,25,0.95); padding:20px 30px; border-radius:20px; box-shadow:0 25px 60px rgba(0,0,0,0.6); color:white; font-weight:700; z-index:300; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); }
</style>
</head>

<body>
<div class="grid"></div>

<!-- POPUP -->
<div class="popup-overlay" id="popup">
    <div class="popup">
        <i class="fas fa-seedling"></i>
        <h2>help the website grow!</h2>
        <p>share this website with all your friends to help keep the traffic up and everything else running smoothly!</p>
        <button id="closePopup">okay!!</button>
    </div>
</div>

<!-- NAV -->
<nav class="navbar">
    <div class="nav-icons">
        <div class="nav-icon active" id="home-btn"><i class="fas fa-home"></i></div>
        <div class="nav-icon" id="games-btn"><i class="fas fa-gamepad"></i></div>
        <div class="nav-icon" id="proxy-btn"><i class="fas fa-server"></i></div>
        <div class="nav-icon" id="settings-btn"><i class="fas fa-cog"></i></div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<main class="content">
    <div class="home fade-in" id="home">
        <h1>Welcome to Vortix</h1>
        <p id="subtitle"></p>
    </div>

    <div class="content-area fade-out" id="content-area">
        <div class="frame-wrapper">
            <div class="loader hidden" id="loader"><div class="spinner"></div></div>
            <div class="frames">
                <iframe id="games-frame" class="page-frame hidden"></iframe>
                <iframe id="proxy-frame" class="page-frame hidden"></iframe>
            </div>
        </div>
    </div>

    <!-- SETTINGS PAGE -->
    <div class="settings-page fade-out" id="settings-page">
        <h3>about:blank</h3>
        <p>Open this HTML in a blank tab to hide from history</p>
        <button id="open-blank-btn">Open in about:blank</button>
        <p style="opacity:0.5;">Note: this will open the full page in a new tab with no URL visible</p>

        <h3>Panic Key</h3>
        <p>Your key: <span id="panic-key-display">p</span></p>
        <p>Click the button to change key</p>
        <button id="change-panic-key-btn">Change Panic Key</button>

        <h3>Your URL</h3>
        <p>Current URL: <span id="custom-url-display">https://www.google.com</span></p>
        <p>Enter your URL link</p>
        <input type="text" id="url-input" placeholder="example.com">
        <button id="set-url-btn">Set URL</button>
    </div>
</main>

<div id="waiting-popup">Waiting For Input</div>

<script>
/* ===== RANDOM SUBTITLE ===== */
const subtitles = ["gucci bucket hat","tung tung tung sahur","hi (:","gatekeep ts"];
document.getElementById("subtitle").textContent = subtitles[Math.floor(Math.random()*subtitles.length)];

/* ===== POPUP CLOSE ===== */
const popup = document.getElementById("popup");
const closeBtn = document.getElementById("closePopup");
closeBtn.onclick = () => { popup.classList.add("hide"); popup.querySelector(".popup").classList.add("hide"); setTimeout(()=>popup.remove(),350); };

/* ===== NAV LOGIC ===== */
const homeBtn=document.getElementById("home-btn");
const gamesBtn=document.getElementById("games-btn");
const proxyBtn=document.getElementById("proxy-btn");
const settingsBtn=document.getElementById("settings-btn");
const loader=document.getElementById("loader");
const home=document.getElementById("home");
const contentArea=document.getElementById("content-area");
const gamesFrame=document.getElementById("games-frame");
const proxyFrame=document.getElementById("proxy-frame");
const settingsPage=document.getElementById("settings-page");
const icons=document.querySelectorAll(".nav-icon");
let gamesLoaded=false, proxyLoaded=false, loadingPage=false;

function setActive(btn){ icons.forEach(i=>i.classList.remove("active")); btn.classList.add("active"); }
function fadeOutElement(el){ el.classList.remove("fade-in"); el.classList.add("fade-out"); }
function fadeInElement(el){ el.classList.remove("fade-out"); el.classList.add("fade-in"); }

function getVisibleContent() {
    if(home.style.display !== "none") return home;
    if(!gamesFrame.classList.contains("hidden") || !proxyFrame.classList.contains("hidden") || settingsPage.style.display!=="none") return document.querySelector(".content-area, .settings-page");
    return home;
}

function showHome(){ fadeOutElement(contentArea); fadeOutElement(settingsPage); setTimeout(()=>{ home.style.display="block"; fadeInElement(home); contentArea.style.display="none"; settingsPage.style.display="none"; },300);}

function showPage(type){
    if(loadingPage) return;
    let current = getVisibleContent();
    fadeOutElement(current);
    setTimeout(()=>{
        home.style.display="none";
        contentArea.style.display="none";
        settingsPage.style.display="none";
        if(type === "games"){ contentArea.style.display="flex"; gamesFrame.classList.remove("hidden"); proxyFrame.classList.add("hidden"); fadeInElement(contentArea); }
        else if(type === "proxy"){ contentArea.style.display="flex"; proxyFrame.classList.remove("hidden"); gamesFrame.classList.add("hidden"); fadeInElement(contentArea); }
        else if(type === "settings"){ settingsPage.style.display="flex"; fadeInElement(settingsPage); }
    },300);
}

function showLoader(callback){ loadingPage=true; loader.classList.remove("hidden"); setTimeout(()=>{ loader.classList.add("hidden"); callback(); loadingPage=false; },2000); }

async function loadFrame(frame,url,done){
    const res=await fetch(url+"?t="+Date.now(),{cache:"no-cache"});
    let html=await res.text();
    html=html.replace(/new URL\(url, location.origin\).hostname/g,'""');
    const doc=frame.contentDocument; doc.open(); doc.write(html); doc.close();

    // Inject cursor style into iframe
    const styleTag = doc.createElement('style');
    styleTag.textContent = "body { cursor: url('https://iili.io/fQ7GTUG.png'), auto !important; }";
    doc.head.appendChild(styleTag);

    setTimeout(()=>{ doc.querySelectorAll("script").forEach(old=>{ const s=document.createElement("script"); [...old.attributes].forEach(a=>s.setAttribute(a.name,a.value)); s.src=old.src ? old.src+"?t="+Date.now() : ""; if(!old.src)s.textContent = old.textContent; old.replaceWith(s); }); done(); },50);
}

homeBtn.onclick=()=>{ setActive(homeBtn); showHome(); };
gamesBtn.onclick=()=>{
    if(loadingPage) return;
    setActive(gamesBtn);
    if(!gamesLoaded){ showPage("games"); showLoader(()=>loadFrame(gamesFrame,"https://cdn.jsdelivr.net/gh/dotdmi/rndm@main/rndm.html",()=>gamesLoaded=true)); }
    else showPage("games");
};
proxyBtn.onclick=()=>{
    if(loadingPage) return;
    setActive(proxyBtn);
    if(!proxyLoaded){ showPage("proxy"); showLoader(()=>loadFrame(proxyFrame,"https://cdn.jsdelivr.net/gh/dotdmi/rndm@main/rnmmd.html",()=>proxyLoaded=true)); }
    else showPage("proxy");
};
settingsBtn.onclick=()=>{
    setActive(settingsBtn);
    showPage("settings");
};

/* ===== SETTINGS LOGIC ===== */
const waitingPopup=document.getElementById("waiting-popup");
let panicKey="p", customURL="https://www.google.com", waitingForKey=false;

// Open current HTML in a true about:blank tab
document.getElementById("open-blank-btn").onclick = () => {
    const win = window.open("about:blank", "_blank");
    const html = document.documentElement.outerHTML;
    win.document.open();
    win.document.write(html);
    win.document.close();
};

document.getElementById("change-panic-key-btn").onclick=()=>{
    waitingForKey=true;
    waitingPopup.style.display="block";
};

document.addEventListener("keydown",(e)=>{
    if(waitingForKey){
        panicKey=e.key.toLowerCase();
        document.getElementById("panic-key-display").textContent=panicKey;
        waitingForKey=false;
        waitingPopup.style.display="none";
    } else if(e.key.toLowerCase()===panicKey){
        window.open(customURL,"_blank");
    }
});

document.getElementById("set-url-btn").onclick=()=>{
    let input=document.getElementById("url-input").value.trim();
    if(input){
        if(!/^https?:\/\//i.test(input)) input="https://"+input;
        customURL=input;
        document.getElementById("custom-url-display").textContent=customURL;
        document.getElementById("url-input").value="";
    }
};
</script>
</body>
</html>
