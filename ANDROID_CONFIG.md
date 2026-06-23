# 🔧 Android Configuration Guide

## 📋 AndroidManifest.xml Setup

After running `npx cap sync`, verify these permissions are in:
`android/app/src/main/AndroidManifest.xml`

```xml
<?xml version='1.0' encoding='utf-8'?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.schoolapp.teachertracker">
    <!-- Required Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    
    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme"
        android:usesCleartextTraffic="true">
        
        <!-- Activities and Services -->
        <activity
            android:name="com.getcapacitor.MainActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|smallestScreenSize|screenLayout|uiMode"
            android:exported="true"
            android:label="@string/title_activity_main"
            android:launchMode="singleTask"
            android:theme="@style/AppTheme">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <!-- Notification Service -->
        <service
            android:name="com.capacitor.plugins.localnotifications.NotificationHandlerService"
            android:permission="android.permission.BIND_JOB_SERVICE"
            android:exported="true" />
            
        <!-- Boot Receiver for persistent notifications -->
        <receiver
            android:name="com.capacitor.plugins.localnotifications.BootReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>
    </application>
</manifest>
```

---

## 🎯 Capacitor Configuration

Edit `capacitor.config.json`:

```json
{
  "appId": "com.schoolapp.teachertracker",
  "appName": "Grade 6-8 Tracker",
  "webDir": "www",
  "server": {
    "androidScheme": "https"
  },
  "android": {
    "allowMixedContent": true,
    "webContentsDebuggingEnabled": false
  },
  "plugins": {
    "LocalNotifications": {
      "smallIcon": "ic_stat_icon_config_sample",
      "iconColor": "#00695c",
      "sound": "notification",
      "importance": 5
    }
  }
}
```

---

## 🎨 App Icon Setup

### 1. Create Icons

Generate icons at: https://roipixel.com/

Sizes needed:
- **192x192** (hdpi)
- **144x144** (xhdpi)
- **96x96** (mdpi)
- **72x72** (ldpi)

### 2. Place in Android Resources

```
android/app/src/main/res/
├── mipmap-hdpi/
│   └── ic_launcher.png (192x192)
├── mipmap-mdpi/
│   └── ic_launcher.png (96x96)
├── mipmap-xhdpi/
│   └── ic_launcher.png (144x144)
├── mipmap-ldpi/
│   └── ic_launcher.png (72x72)
└── mipmap-xxxhdpi/
    └── ic_launcher.png (384x384)
```

### 3. Ensure Rounded Icons

Also create `ic_launcher_round.png` in each mipmap folder.

---

## 🔊 Notification Sound Setup

### 1. Add Sound File

Place notification sound (`.mp3` or `.ogg`) in:
```
android/app/src/main/res/raw/
└── notification.mp3
```

### 2. Reference in AndroidManifest.xml

```xml
<application>
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_sound"
        android:resource="@raw/notification" />
</application>
```

---

## ⚙️ build.gradle Configuration

Verify `android/build.gradle`:

```gradle
buildscript {
    ext {
        minSdkVersion = 22
        compileSdkVersion = 33
        targetSdkVersion = 33
        javaSourceCompatibility = JavaVersion.VERSION_11
        javaTargetCompatibility = JavaVersion.VERSION_11
    }
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.0.0'
    }
}
```

---

## 🏗️ Building Release APK

### Step 1: Create Signing Key

```bash
keytool -genkey -v -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias
```

When prompted:
- Keystore password: [create a password]
- Key password: [same or different]
- Common name: Your name
- Organization: Your school
- City, state: [as needed]
- Country code: [2-letter code, e.g., IN]

### Step 2: Configure Gradle Signing

Create `android/keystore.properties`:
```properties
storeFile=../my-release-key.jks
storePassword=YOUR_KEYSTORE_PASSWORD
keyAlias=my-key-alias
keyPassword=YOUR_KEY_PASSWORD
```

Edit `android/app/build.gradle`:
```gradle
android {
    signingConfigs {
        release {
            storeFile file('../my-release-key.jks')
            storePassword 'YOUR_PASSWORD'
            keyAlias 'my-key-alias'
            keyPassword 'YOUR_PASSWORD'
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 3: Build Release

```bash
cd android
./gradlew assembleRelease
```

Your signed APK:
```
android/app/build/outputs/apk/release/app-release.apk
```

---

## 🔍 Troubleshooting Android Issues

### Issue: "androidx.appcompat.R not found"

```bash
cd android
./gradlew clean
./gradlew build
```

### Issue: "Unsupported class-file format"

Ensure you have **Java 11+**:
```bash
java -version
```

If not, install from https://adoptium.net/

### Issue: Gradle Daemon Issues

```bash
cd android
./gradlew --stop
./gradlew clean
./gradlew assembleDebug
```

### Issue: Out of Memory during Build

Create `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### Issue: Build Hangs

```bash
# Disable Gradle daemon
./gradlew assembleDebug --no-daemon
```

---

## 📱 Testing on Emulator

### Create Virtual Device:

1. Open Android Studio
2. AVD Manager → Create Virtual Device
3. Select: Pixel 4 with Android 12
4. Start the emulator

### Deploy to Emulator:

```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

Or:
```bash
npm run android
```

---

## 🔗 Useful Android Concepts

### Minimum SDK Version

Notifications require API 23+, but we target 22 for compatibility.

### Target SDK Version

Keep at 33+ for Play Store compliance.

### Manifest Merger

Capacitor auto-merges manifests. If conflicts occur, add this to `android/app/build.gradle`:

```gradle
android {
    packagingOptions {
        exclude 'META-INF/proguard/androidx-*.pro'
    }
}
```

---

## 📦 Local Notifications Plugin Details

The plugin automatically handles:
- ✅ Schedule notifications
- ✅ Request permissions
- ✅ Show notifications even if app is closed
- ✅ Handle notification taps
- ✅ Persist across device restarts

### Plugin Code Location:
```
node_modules/@capacitor/local-notifications/
```

---

## 🧪 Debug Commands

### View Android System Logs:
```bash
adb logcat | grep "capacitor"
```

### View App-Specific Logs:
```bash
adb logcat | grep "Grade 6-8"
```

### Clear App Data:
```bash
adb shell pm clear com.schoolapp.teachertracker
```

### View Device Files:
```bash
adb shell
ls /data/data/com.schoolapp.teachertracker/
```

---

## ✅ Pre-Build Checklist

- [ ] Android SDK installed
- [ ] Java 11+ available
- [ ] `capacitor.config.json` configured
- [ ] AndroidManifest.xml permissions set
- [ ] App icons in place
- [ ] www/index.html exists
- [ ] node_modules installed

---

## 🚀 Build Commands Reference

```bash
# Clean build
./gradlew clean

# Build debug
./gradlew assembleDebug

# Build release (if signed)
./gradlew assembleRelease

# Build and run on device
./gradlew installDebug

# View build info
./gradlew -v

# Force Gradle update
./gradlew wrapper --gradle-version=8.0
```

---

## 📊 APK Size Reference

- Typical APK size: 15-25 MB
- If larger, check:
  - Unused dependencies
  - Large images
  - Minification enabled

---

## 🎯 Final Notes

1. **Always test on real device** before distribution
2. **Keep signing key safe** - needed for app updates
3. **Increment version** in build.gradle for updates
4. **Test notifications** on various Android versions
5. **Monitor device logs** during first run

---

## 📞 Support Resources

- Capacitor Docs: https://capacitorjs.com/docs
- Android Docs: https://developer.android.com/docs
- Local Notifications: https://github.com/ionic-team/capacitor-plugins/tree/main/local-notifications
- Stack Overflow: `[capacitor]` `[android]` tags

---

Good luck with your build! 🎉📚
