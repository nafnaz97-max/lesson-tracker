#!/bin/bash

# ============================================================
# Grade 6-8 Teacher Tracker - Capacitor Setup Script
# ============================================================
# Usage: bash setup.sh

set -e

echo "🚀 Grade 6-8 Teacher Tracker - Capacitor Setup"
echo "=============================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo "✅ npm found: $(npm --version)"
echo ""

# Create project directory
PROJECT_NAME="teacher-tracker-app"
if [ -d "$PROJECT_NAME" ]; then
    echo "⚠️  Directory '$PROJECT_NAME' already exists"
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    mkdir "$PROJECT_NAME"
fi

cd "$PROJECT_NAME"
echo "📁 Working in: $(pwd)"
echo ""

# Initialize if needed
if [ ! -f "package.json" ]; then
    echo "📦 Initializing npm project..."
    npm init -y
    echo ""
fi

# Install dependencies
echo "📥 Installing Capacitor dependencies..."
npm install @capacitor/core @capacitor/cli @capacitor/local-notifications --save

echo ""
echo "🔧 Initializing Capacitor..."
npx cap init --web-dir=www

echo ""
echo "📱 Adding Android platform..."
npx cap add android

echo ""
echo "🔄 Syncing..."
npx cap sync android

# Create www directory and copy HTML
echo "📂 Setting up web assets..."
mkdir -p www
cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';" />
  <title>📚 Grade 6-8 Tracker</title>
  <style>
    :root {
      --primary: #00695c;
      --primary-dark: #004d40;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
      background: #f0f4f8;
      color: #212121;
    }
    header {
      background: var(--primary);
      color: #fff;
      padding: 1rem;
      text-align: center;
      position: sticky;
      top: 0;
      z-index: 100;
    }
    header h1 { margin: 0; font-size: 1.4rem; }
    main { max-width: 820px; margin: 1rem auto; padding: 0 1rem 2rem; }
    .card {
      background: #fff;
      border-radius: 12px;
      padding: 1rem;
      margin-bottom: 1rem;
      box-shadow: 0 1px 4px rgba(0,0,0,0.08);
    }
    .btn {
      padding: 0.7rem 1.1rem;
      border: none;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 700;
      cursor: pointer;
      margin: 0.5rem 0;
    }
    .btn-primary { background: var(--primary); color: #fff; }
    .btn-secondary { background: #eceff1; color: #212121; }
    input { width: 100%; padding: 0.6rem; border: 1px solid #cfd8dc; border-radius: 8px; margin: 0.5rem 0; font-size: 1rem; }
  </style>
</head>
<body>
  <header>
    <h1>📚 Grade 6-8 Tracker</h1>
    <p>Track daily activities and share report on WhatsApp</p>
  </header>
  <main>
    <div class="card">
      <h2>👤 Teacher Profile</h2>
      <label>Your Name:</label>
      <input type="text" id="userName" placeholder="Enter your name...">
      <button class="btn btn-primary" onclick="saveName()">✅ Save Name</button>
      <div id="greeting" style="margin-top: 1rem; display: none; background: linear-gradient(135deg, #00695c 0%, #004d40 100%); color: #fff; padding: 1.5rem; border-radius: 10px; text-align: center;"></div>
    </div>

    <div class="card">
      <h2>🔔 Daily Notifications</h2>
      <p>These notifications will be sent at scheduled times:</p>
      <ul>
        <li>7:30 AM - Good Morning + Motivation Quote</li>
        <li>7:45 AM - First Class Alert</li>
        <li>10:30 AM - Break Time</li>
        <li>10:50 AM - Fifth Period Alert</li>
        <li>1:20 PM - School Ending Soon</li>
        <li>1:30 PM - Signing Off</li>
      </ul>
      <button class="btn btn-primary" onclick="enableNotifications()">✅ Enable Notifications</button>
      <button class="btn btn-secondary" onclick="testNotification()">🧪 Test Notification</button>
    </div>
  </main>

  <script>
    const QUOTES = [
      "Every lesson you teach plants seeds for the future! 🌱",
      "You're making a difference in every student's life. 💪",
      "Teaching is the one profession that creates all other professions. ✨",
      "Your patience and dedication are changing lives today. 👍",
      "The way you inspire students will echo through generations. 🌟"
    ];

    const NOTIFICATIONS = [
      { time: '07:30', title: '🙂 Good Morning!', body: (name) => `Hi... Good Morning ${name} 🙃\n\n${QUOTES[Math.floor(Math.random() * QUOTES.length)]}` },
      { time: '07:45', title: '🕓 Class Alert', body: 'முதலாம் பாடம் ஆரம்பமாக இன்னும் 5 நிமிடங்கள் உள்ளது...' },
      { time: '10:30', title: '☕ Break Time', body: "It's Brake Time..." },
      { time: '10:50', title: '📚 Class Resuming', body: 'ஐந்தாம் பாடவேளை ஆரம்பமாகிறது...' },
      { time: '13:20', title: '⏳ School Ending Soon', body: 'பாடசாலை நிறைவடைய இன்னும் 10 நிமிடங்கள் உள்ளது...' },
      { time: '13:30', title: '👋 Signing Off', body: 'Signing off for the day. Thanks for being a great teacher! 👋📚👩‍🏫' }
    ];

    function saveName() {
      const name = document.getElementById('userName').value.trim();
      if (!name) return alert('Enter your name');
      localStorage.setItem('teacherName', name);
      showGreeting(name);
    }

    function showGreeting(name) {
      const greeting = document.getElementById('greeting');
      greeting.innerHTML = `<h2>Welcome, ${name}! 👋</h2><p>Notifications will be sent daily to your device</p>`;
      greeting.style.display = 'block';
    }

    async function enableNotifications() {
      try {
        const { LocalNotifications } = window.Capacitor.Plugins;
        const permission = await LocalNotifications.requestPermissions();
        
        if (permission.display !== 'granted') return alert('Permission denied');

        const name = localStorage.getItem('teacherName') || 'Teacher';
        let id = 1;

        for (const n of NOTIFICATIONS) {
          const [h, m] = n.time.split(':').map(Number);
          const body = typeof n.body === 'function' ? n.body(name) : n.body;
          
          await LocalNotifications.schedule({
            notifications: [{
              id: id++,
              title: n.title,
              body: body,
              schedule: { on: { hour: h, minute: m }, every: 'day' },
              sound: true,
              vibrate: true
            }]
          });
        }
        alert('✅ Notifications scheduled successfully!');
      } catch (e) {
        alert('Error: ' + e.message);
      }
    }

    async function testNotification() {
      try {
        const { LocalNotifications } = window.Capacitor.Plugins;
        const name = localStorage.getItem('teacherName') || 'Teacher';
        
        await LocalNotifications.schedule({
          notifications: [{
            id: 999,
            title: '🧪 Test',
            body: `Hi ${name}! This is a test notification`,
            schedule: { at: new Date(Date.now() + 2000) }
          }]
        });
        alert('Test notification in 2 seconds...');
      } catch (e) {
        alert('Error: ' + e.message);
      }
    }

    window.addEventListener('DOMContentLoaded', () => {
      const name = localStorage.getItem('teacherName');
      if (name) {
        document.getElementById('userName').value = name;
        showGreeting(name);
      }
    });
  </script>
</body>
</html>
EOF

echo "✅ HTML file created"
echo ""

# Create build scripts
echo "📝 Creating npm scripts..."
npm set-script build "npm install && npx cap sync"
npm set-script android "npx cap run android"
npm set-script android:build "cd android && ./gradlew assembleDebug"

echo ""
echo "✅ Setup Complete!"
echo ""
echo "═════════════════════════════════════════"
echo "🎯 Next Steps:"
echo "═════════════════════════════════════════"
echo ""
echo "1. Build the Android APK:"
echo "   npm run android:build"
echo ""
echo "2. Your APK will be at:"
echo "   android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "3. Install on device:"
echo "   adb install android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "4. Or run directly on connected device:"
echo "   npm run android"
echo ""
echo "📖 Full documentation: Read CAPACITOR_BUILD_GUIDE.md"
echo ""
