# 📱 Building Trackley for Devices

## ✅ Current Features Ship-Ready:

### 1. **Offline/Online Sync** ✅
Your app automatically works offline and syncs when back online:
- ✓ Firestore offline persistence is enabled
- ✓ Local data cached automatically
- ✓ Auto-sync when connection restored
- ✓ No code changes needed!

### 2. **Habit Reminders/Alarms** ✅  
Users can set daily reminders for each habit:
- ✓ Time picker in "Create Habit" screen
- ✓ Daily notifications at chosen time
- ✓ Notifications work even when app is closed
- ✓ Can cancel/update reminders anytime

---

## 🏗️ Build for Android

### Step 1: Connect Android Device or Emulator
```bash
# Check connected devices
flutter devices
```

### Step 2: Clean Build
```bash
flutter clean
flutter pub get
```

### Step 3: Build APK (for testing)
```bash
# Build debug APK
flutter build apk --debug

# Build release APK (optimized, smaller size)
flutter build apk --release
```

**APK Location:** `build\app\outputs\flutter-apk\app-release.apk`

### Step 4: Install on Device
```bash
# Install to connected device
flutter install

# OR manually:
# 1. Copy APK from build/app/outputs/flutter-apk/
# 2. Transfer to phone via USB/Cloud
# 3. Enable "Install Unknown Apps" on Android
# 4. Tap APK to install
```

---

## 🍎 Build for iOS (macOS Required)

### Prerequisites:
- macOS computer
- Xcode installed
- Apple Developer account (for distribution)

### Steps:
```bash
flutter build ios --release

# Then open Xcode to archive and distribute
open ios/Runner.xcworkspace
```

---

## 🚀 Testing Offline/Online Features

### Test Offline Functionality:
1. Open app when connected to internet
2. Create/complete a habit
3. **Turn OFF WiFi/Data** on device
4. Create more habits, complete habits
5. All changes saved locally ✓
6. **Turn ON WiFi/Data** again
7. Data automatically syncs to Firebase ✓

---

## 🔔 Testing Notifications

### Android:
1. Go to Android Settings > Apps > Trackley > Permissions
2. Enable "Notifications"
3. Create habit with reminder time
4. Wait for notification (or change device time to test)

### iOS:
1. App requests notification permission on first launch
2. Accept permission
3. Set reminder when creating habit

---

## 📦 App Size Optimization (Optional)

### Reduce APK Size:
```bash
# Split APKs by CPU architecture (recommended)
flutter build apk --split-per-abi

# This creates 3 smaller APKs instead of 1 large one:
# - app-armeabi-v7a-release.apk (32-bit ARM)
# - app-arm64-v8a-release.apk (64-bit ARM - most modern phones)
# - app-x86_64-release.apk (emulators)
```

---

## 🎯 Quick Commands Reference

```bash
# Run on device
flutter run

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Check what's using space
flutter build apk --analyze-size

# Install on connected device
flutter install -d <device-id>
```

---

## ✨ What's Working Now:

### Online Mode:
- ✅ User signup & login
- ✅ Create/edit/complete habits
- ✅ Real-time Firebase sync
- ✅ Profile with custom avatar
- ✅ Leaderboard
- ✅ Money tracking

### Offline Mode:
- ✅ All habits cached locally
- ✅ Create new habits offline
- ✅ Complete habits offline
- ✅ View all data offline
- ✅ Auto-sync when back online

### Notifications:
- ✅ Set custom reminder time per habit
- ✅ Daily recurring notifications
- ✅ Works when app closed
- ✅ Notification permission handling

---

## 🐛 Troubleshooting

### "APK won't install on phone"
- Enable "Install Unknown Apps" for your file manager
- Go to Settings > Apps > Special Access > Install Unknown Apps

### "Notifications not showing"
- Check app notification permissions
- Ensure "Do Not Disturb" is off
- Test with device time change

### "Build failed"
- Run `flutter clean && flutter pub get`
- Check Android SDK is updated
- Ensure Java 17 is installed

---

## 📲 Next Steps (Optional)

### Publish to Google Play Store:
1. Create developer account ($25 one-time)
2. Build App Bundle: `flutter build appbundle --release`
3. Upload to Play Console
4. Fill store listing
5. Submit for review

### Add Icons/Splash Screen:
```bash
flutter pub add flutter_launcher_icons
flutter pub add flutter_native_splash
```

---

Need help with any step? Just ask!
