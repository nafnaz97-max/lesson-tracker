# 🚀 Quick Start Guide - APK Creation

## 📱 What You Get

Your APK app will have:

✅ **Daily Notifications at:**
- **7:30 AM** - "Hi... Good Morning [Name] 🙃" + Random motivation quote
- **7:45 AM** - "🕓 முதலாம் பாடம் ஆரம்பமாக இன்னும் 5 நிமிடங்கள் உள்ளது..."
- **10:30 AM** - "It's Brake Time..."
- **10:50 AM** - "ஐந்தாம் பாடவேளை ஆரம்பமாகிறது..."
- **1:20 PM** - "பாடசாலை நிறைவடைய இன்னும் 10 நிமிடங்கள் உள்ளது..."
- **1:30 PM** - "Signing off for the day. Thanks for being a great teacher! 👋📚👩‍🏫"

✅ **User Profile Management**
✅ **Notification Settings**
✅ **Test Notification Button**

---

## ⚡ Quick Setup (5 Minutes)

### Windows Users:
```
1. Double-click: setup.bat
2. Wait for installation to complete
3. Run: npm run android:build
```

### macOS/Linux Users:
```
1. bash setup.sh
2. Wait for installation
3. npm run android:build
```

---

## 🎯 Build APK

After setup, build APK with:

```bash
npm run android:build
```

Your APK will be created at:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 📲 Install on Your Phone

### Option 1: USB Cable (Recommended)
```bash
# Enable USB Debugging on your phone:
# Settings > Developer Options > USB Debugging

# Then run:
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### Option 2: File Transfer
1. Copy `app-debug.apk` to your phone
2. Open File Manager → Find APK
3. Tap → Allow installation from unknown sources
4. Install

### Option 3: Direct Run (if device connected)
```bash
npm run android
```

---

## 📋 System Requirements

**Before you start, have these installed:**

1. **Node.js** (https://nodejs.org/)
   - Download LTS version
   - Install normally

2. **Android Studio** (https://developer.android.com/studio)
   - Install with Android SDK (API 30+)
   - Required for build tools

3. **Java JDK 11+**
   - Usually comes with Android Studio

4. **Git** (optional but helpful)

---

## 🔍 Troubleshooting

### "gradle not found"
```bash
cd android
./gradlew clean
./gradlew assembleDebug
```

### "npm not found"
- Restart your terminal/computer
- Reinstall Node.js from https://nodejs.org/

### "Notifications not working"
- Ensure app has notification permission
- Test with: "Test Notification" button in app
- Check device notification settings

### "APK won't install"
- Device must allow "Installation from Unknown Sources"
- Try: Settings > Apps > Special App Access > Install unknown apps > Allow
- Uninstall old version first

---

## 📂 Project Structure After Setup

```
teacher-tracker-app/
├── www/
│   └── index.html (your app)
├── android/
│   ├── app/
│   │   └── build/
│   │       └── outputs/
│   │           └── apk/
│   │               └── debug/
│   │                   └── app-debug.apk ← YOUR APK!
│   └── ... (Android build files)
├── node_modules/
├── package.json
└── capacitor.config.json
```

---

## 🎨 Customizations

### Change App Name:
Edit `capacitor.config.json`:
```json
{
  "appName": "Grade 6-8 Tracker"
}
```

### Change App Icon:
Replace images in:
```
android/app/src/main/res/mipmap-*/
```

### Change Package Name (before first build):
Edit `capacitor.config.json`:
```json
{
  "appId": "com.schoolapp.teachertracker"
}
```

---

## 🚀 Running on Device

### Prerequisites:
1. Connect Android phone via USB
2. Enable USB Debugging: Settings > Developer Options > USB Debugging
3. Verify connection:
```bash
adb devices
```

### Install & Run:
```bash
npm run android
```

---

## 🧪 Testing Notifications

1. Open app on phone
2. Enter your name
3. Click "Test Notification"
4. You should see a test notification in 2 seconds

If it works, click "Enable Notifications" to schedule daily ones.

---

## 📊 Notification Schedule Details

| Time | Message | Language |
|------|---------|----------|
| 7:30 AM | Good morning + motivation quote | English |
| 7:45 AM | First class in 5 minutes | Tamil |
| 10:30 AM | Break time | English |
| 10:50 AM | Fifth period resuming | Tamil |
| 1:20 PM | School ending in 10 minutes | Tamil |
| 1:30 PM | Signing off | English |

---

## 🔐 Security Notes

- App is stored locally on device
- All data saved in device storage
- No internet connection required
- Notifications work even offline

---

## 💡 Pro Tips

1. **Keep APK file** - You can share it directly with other teachers
2. **Back it up** - Save your generated APK in a safe location
3. **Test first** - Always test on a device before full rollout
4. **Customize notification times** - Edit times in www/index.html if needed

---

## 📞 Common Commands

```bash
# View logs
adb logcat

# Uninstall app
adb uninstall com.schoolapp.teachertracker

# List devices
adb devices

# Clear cache
npm run build

# Rebuild everything
rm -rf android/app/build && npm run android:build
```

---

## ✅ Verification Checklist

- [ ] Node.js installed
- [ ] Android SDK installed
- [ ] setup.sh/bat ran successfully
- [ ] APK built without errors
- [ ] App installed on phone
- [ ] Test notification works
- [ ] App appears with correct icon
- [ ] Name saved properly
- [ ] Ready to deploy!

---

## 🎉 Done!

Your APK is ready to use! You can now:
- 📱 Share the APK file with teachers
- 📧 Email it to users
- 🌐 Upload to Google Play Store (if desired)
- 💾 Backup and save

---

**Need help?** Check `CAPACITOR_BUILD_GUIDE.md` for detailed information.

Happy teaching! 📚✨
