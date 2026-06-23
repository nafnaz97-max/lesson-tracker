# 📱 Capacitor APK Build Guide - Grade 6-8 Tracker

## ✅ Prerequisites
- **Node.js & npm** installed (https://nodejs.org/)
- **Android Studio** installed (for Android build)
- **JDK 11+** installed
- **Android SDK** (API level 30+)

---

## 📋 Step 1: Create Capacitor Project

```bash
# Create a new directory
mkdir teacher-tracker-app
cd teacher-tracker-app

# Initialize Node project
npm init -y

# Install Capacitor CLI & core
npm install @capacitor/core @capacitor/cli

# Initialize Capacitor
npx cap init

# When prompted, use these values:
# Project name: Grade 6-8 Teacher Tracker
# Package ID: com.schoolapp.teachertracker
# Web asset directory: www
```

---

## 📂 Step 2: Copy HTML App Files

```bash
# Create www directory
mkdir www

# Copy the HTML file into www/
# (Place lesson-tracker-app.html as index.html)
cp lesson-tracker-app.html www/index.html
```

---

## 🔧 Step 3: Install Android Platform & Local Notifications Plugin

```bash
# Add Android platform
npx cap add android

# Install local notifications plugin
npm install @capacitor/local-notifications

# Sync with Android
npx cap sync android
```

---

## ⚙️ Step 4: Create package.json Scripts

Add these scripts to your `package.json`:

```json
{
  "scripts": {
    "build": "npm install && npx cap sync",
    "android": "npx cap run android",
    "android:build": "cd android && ./gradlew assembleDebug"
  }
}
```

---

## 🏗️ Step 5: Build Android APK

```bash
# Navigate to Android directory
cd android

# Build debug APK
./gradlew assembleDebug

# Or build release APK (requires signing)
./gradlew assembleRelease
```

**APK Location:**
- Debug: `android/app/build/outputs/apk/debug/app-debug.apk`
- Release: `android/app/build/outputs/apk/release/app-release.apk`

---

## 📱 Step 6: Install on Android Device

### Option A: Using ADB
```bash
# Connect device via USB (with Developer Mode enabled)
adb devices  # Verify device is connected

# Install APK
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### Option B: Manual Installation
1. Copy `app-debug.apk` to your phone
2. Open File Manager
3. Tap the APK file
4. Allow installation from unknown sources
5. Install

---

## 🔔 Notifications - Required AndroidManifest.xml Configuration

The plugin should handle this, but verify in:
`android/app/src/main/AndroidManifest.xml`

Ensure these permissions exist:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

---

## 🎨 Step 7: Customize App Icon & Splash Screen (Optional)

### Icon Setup:
1. Replace images in: `android/app/src/main/res/mipmap-*/`
2. Create 192x192 PNG icon
3. Copy to all mipmap folders

### Splash Screen:
1. Edit: `android/app/src/main/res/values/styles.xml`
2. Customize colors and image

---

## 🚀 Building Release APK (For Play Store)

```bash
# Generate signing key
keytool -genkey -v -keystore ./my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Sign the APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore ./my-release-key.jks \
  android/app/build/outputs/apk/release/app-release-unsigned.apk \
  my-key-alias

# Align the APK
zipalign -v 4 app-release-unsigned.apk app-release-signed.apk
```

---

## 📝 Troubleshooting

### Issue: Gradle Build Fails
```bash
cd android
./gradlew clean
./gradlew assembleDebug
```

### Issue: Notifications Not Working
- Check: `android/app/src/main/AndroidManifest.xml` has correct permissions
- Ensure device has notifications enabled
- Test with: "Test Notification" button in app

### Issue: App Crashes on Startup
1. Check logcat: `adb logcat`
2. Verify all files in `www/` directory
3. Check console for JavaScript errors

---

## 📦 Complete Project Structure

```
teacher-tracker-app/
├── www/
│   └── index.html (your lesson-tracker-app.html)
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/
│   │   └── build.gradle
│   └── build.gradle
├── ios/ (optional)
├── capacitor.config.json
├── package.json
└── package-lock.json
```

---

## ✨ Features Included

✅ **Daily Notifications:**
- 7:30 AM - Good morning with motivation quote
- 7:45 AM - First class alert (Tamil)
- 10:30 AM - Break time notification
- 10:50 AM - Fifth period alert (Tamil)
- 1:20 PM - School ending soon notification
- 1:30 PM - Signing off message

✅ **User Profile:**
- Save teacher name
- Auto-populate in notifications

✅ **Settings:**
- Enable/Disable notifications
- Test notification button

---

## 🔐 Android Permissions Required

These are automatically requested by the Local Notifications plugin:
- `POST_NOTIFICATIONS` (Android 13+)
- `SCHEDULE_EXACT_ALARM`
- `INTERNET`
- `RECEIVE_BOOT_COMPLETED` (for persistent scheduling)

---

## 📞 Support Commands

```bash
# View device logs
adb logcat | grep "capacitor"

# Uninstall app
adb uninstall com.schoolapp.teachertracker

# List connected devices
adb devices

# Enable USB debugging on device
# Settings > Developer Options > USB Debugging
```

---

## 🎯 Next Steps After Build

1. **Test on real device** with various notification times
2. **Verify notifications persist** after device restart
3. **Test with different device settings** (Do Not Disturb, etc.)
4. **Customize notification sounds** if desired
5. **Consider enabling background execution** for reliability

---

## 📱 APK Ready!

Your APK is now ready to be:
- ✅ Shared directly with teachers
- ✅ Uploaded to Google Play Store
- ✅ Distributed within your school

---

Good luck! 🚀📚
