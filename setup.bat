@echo off
REM ============================================================
REM Grade 6-8 Teacher Tracker - Capacitor Setup (Windows)
REM ============================================================

echo.
echo 🚀 Grade 6-8 Teacher Tracker - Capacitor Setup (Windows)
echo ============================================================
echo.

REM Check Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js is not installed. Please install from https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js found: 
node --version
echo ✅ npm found: 
npm --version
echo.

REM Create project
set PROJECT_NAME=teacher-tracker-app
if exist "%PROJECT_NAME%" (
    echo ⚠️  Directory '%PROJECT_NAME%' already exists
    set /p continue="Do you want to continue? (y/n): "
    if /i not "%continue%"=="y" exit /b 1
) else (
    mkdir "%PROJECT_NAME%"
)

cd "%PROJECT_NAME%"
echo 📁 Working in: %CD%
echo.

REM Initialize npm if needed
if not exist "package.json" (
    echo 📦 Initializing npm project...
    call npm init -y
    echo.
)

REM Install dependencies
echo 📥 Installing Capacitor dependencies...
call npm install @capacitor/core @capacitor/cli @capacitor/local-notifications --save

echo.
echo 🔧 Initializing Capacitor...
call npx cap init --web-dir=www

echo.
echo 📱 Adding Android platform...
call npx cap add android

echo.
echo 🔄 Syncing...
call npx cap sync android

REM Create www directory
echo 📂 Setting up web assets...
if not exist "www" mkdir www

REM Create index.html
(
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo   ^<meta charset="UTF-8" /^>
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0" /^>
echo   ^<meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" /^>
echo   ^<title^>📚 Grade 6-8 Tracker^</title^>
echo   ^<style^>
echo     :root { --primary: #00695c; --primary-dark: #004d40; }
echo     * { box-sizing: border-box; }
echo     body { margin: 0; font-family: system-ui, sans-serif; background: #f0f4f8; }
echo     header { background: var(--primary); color: #fff; padding: 1rem; text-align: center; }
echo     main { max-width: 820px; margin: 1rem auto; padding: 0 1rem; }
echo     .card { background: #fff; border-radius: 12px; padding: 1rem; margin-bottom: 1rem; }
echo     .btn { padding: 0.7rem 1.1rem; border: none; border-radius: 8px; cursor: pointer; margin: 0.5rem 0; }
echo     .btn-primary { background: var(--primary); color: #fff; }
echo     .btn-secondary { background: #eceff1; }
echo     input { width: 100%%; padding: 0.6rem; border: 1px solid #cfd8dc; border-radius: 8px; margin: 0.5rem 0; }
echo   ^</style^>
echo ^</head^>
echo ^<body^>
echo   ^<header^>
echo     ^<h1^>📚 Grade 6-8 Tracker^</h1^>
echo     ^<p^>Track daily activities and share report on WhatsApp^</p^>
echo   ^</header^>
echo   ^<main^>
echo     ^<div class="card"^>
echo       ^<h2^>👤 Teacher Profile^</h2^>
echo       ^<label^>Your Name:^</label^>
echo       ^<input type="text" id="userName" placeholder="Enter your name..."^>
echo       ^<button class="btn btn-primary" onclick="saveName()"^>✅ Save Name^</button^>
echo       ^<div id="greeting" style="display:none; background: linear-gradient(135deg, #00695c 0%%, #004d40 100%%); color: #fff; padding: 1.5rem; border-radius: 10px; text-align: center; margin-top: 1rem;"^>^</div^>
echo     ^</div^>
echo.
echo     ^<div class="card"^>
echo       ^<h2^>🔔 Daily Notifications^</h2^>
echo       ^<p^>Notifications at scheduled times:^</p^>
echo       ^<ul^>
echo         ^<li^>7:30 AM - Good Morning + Quote^</li^>
echo         ^<li^>7:45 AM - First Class Alert^</li^>
echo         ^<li^>10:30 AM - Break Time^</li^>
echo         ^<li^>10:50 AM - Fifth Period Alert^</li^>
echo         ^<li^>1:20 PM - School Ending Soon^</li^>
echo         ^<li^>1:30 PM - Signing Off^</li^>
echo       ^</ul^>
echo       ^<button class="btn btn-primary" onclick="enableNotifications()"^>✅ Enable Notifications^</button^>
echo       ^<button class="btn btn-secondary" onclick="testNotification()"^>🧪 Test^</button^>
echo     ^</div^>
echo   ^</main^>
echo.
echo   ^<script^>
echo     const QUOTES = ["Every lesson plants seeds! 🌱", "You're making a difference! 💪", "Teaching creates all professions! ✨", "Your dedication changes lives! 👍", "You inspire generations! 🌟"];
echo     const NOTIFICATIONS = [
echo       { time: '07:30', title: '🙂 Good Morning!', body: (n) =^> `Hi... Good Morning ${n} 🙃\n\n${QUOTES[Math.floor(Math.random() * QUOTES.length)]}` },
echo       { time: '07:45', title: '🕓 Alert', body: 'முதலாம் பாடம் ஆரம்பமாக இன்னும் 5 நிமிடங்கள் உள்ளது...' },
echo       { time: '10:30', title: '☕ Break', body: "It's Brake Time..." },
echo       { time: '10:50', title: '📚 Resume', body: 'ஐந்தாம் பாடவேளை ஆரம்பமாகிறது...' },
echo       { time: '13:20', title: '⏳ Ending', body: 'பாடசாலை நிறைவடைய இன்னும் 10 நிமிடங்கள் உள்ளது...' },
echo       { time: '13:30', title: '👋 Signing Off', body: 'Thanks for being a great teacher! 👋📚' }
echo     ];
echo.
echo     function saveName() {
echo       const n = document.getElementById('userName').value.trim();
echo       if (!n) return alert('Enter your name');
echo       localStorage.setItem('teacherName', n);
echo       const g = document.getElementById('greeting');
echo       g.innerHTML = `^<h2^>Welcome, ${n}! 👋^</h2^>^<p^>Notifications enabled^</p^>`;
echo       g.style.display = 'block';
echo     }
echo.
echo     async function enableNotifications() {
echo       try {
echo         const { LocalNotifications } = window.Capacitor.Plugins;
echo         const p = await LocalNotifications.requestPermissions();
echo         if (p.display !== 'granted') return alert('Permission denied');
echo         const name = localStorage.getItem('teacherName') ^|^| 'Teacher';
echo         let id = 1;
echo         for (const n of NOTIFICATIONS) {
echo           const [h,m] = n.time.split(':').map(Number);
echo           const body = typeof n.body === 'function' ? n.body(name) : n.body;
echo           await LocalNotifications.schedule({
echo             notifications: [{id:id++, title:n.title, body:body, schedule:{on:{hour:h,minute:m}, every:'day'}, sound:true, vibrate:true}]
echo           });
echo         }
echo         alert('✅ Notifications scheduled!');
echo       } catch(e) { alert('Error: ' + e.message); }
echo     }
echo.
echo     async function testNotification() {
echo       try {
echo         const { LocalNotifications } = window.Capacitor.Plugins;
echo         const name = localStorage.getItem('teacherName') ^|^| 'Teacher';
echo         await LocalNotifications.schedule({
echo           notifications: [{id:999, title:'🧪 Test', body:`Hi ${name}!`, schedule:{at:new Date(Date.now()+2000)}}]
echo         });
echo         alert('Test in 2 seconds...');
echo       } catch(e) { alert('Error: ' + e.message); }
echo     }
echo.
echo     window.addEventListener('DOMContentLoaded', () =^> {
echo       const n = localStorage.getItem('teacherName');
echo       if (n) {
echo         document.getElementById('userName').value = n;
echo         const g = document.getElementById('greeting');
echo         g.innerHTML = `^<h2^>Welcome, ${n}! 👋^</h2^>`;
echo         g.style.display = 'block';
echo       }
echo     });
echo   ^</script^>
echo ^</body^>
echo ^</html^>
) > www\index.html

echo ✅ HTML file created
echo.

REM Create npm scripts
echo 📝 Creating npm scripts...
call npm set-script build "npm install ^&^& npx cap sync"
call npm set-script android "npx cap run android"
call npm set-script android:build "cd android ^&^& gradlew assembleDebug"

echo.
echo ✅ Setup Complete!
echo.
echo ==================================================
echo 🎯 Next Steps:
echo ==================================================
echo.
echo 1. Build the Android APK:
echo    npm run android:build
echo.
echo 2. Your APK will be at:
echo    android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 3. Install on device:
echo    adb install android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 4. Or run directly:
echo    npm run android
echo.
echo.
pause
