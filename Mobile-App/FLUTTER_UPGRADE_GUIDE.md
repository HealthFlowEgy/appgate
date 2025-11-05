# Flutter Mobile App Upgrade Guide

## Current State
- **Flutter SDK:** >=3.0.1 <4.0.0
- **Dart:** Compatible with Flutter 3.0.1+
- **State Management:** flutter_bloc 8.1.3
- **HTTP Client:** Retrofit 4.0.1 + Dio 5.3.2
- **Push Notifications:** OneSignal 3.5.1 ⚠️ (CRITICAL UPDATE NEEDED)
- **Firebase:** Core 2.15.1, Auth 4.8.0, Database 10.2.5, Storage 11.6.7

---

## 🚨 CRITICAL UPDATES REQUIRED

### 1. OneSignal 3.5.1 → 5.x (BREAKING CHANGES)
**Risk:** High  
**Impact:** Push notifications will break without migration  
**Priority:** CRITICAL

### 2. Firebase Packages (Major Version Updates)
**Risk:** Medium  
**Impact:** Authentication and real-time features  
**Priority:** High

### 3. Image Cropper 4.0.1 → 8.x (BREAKING CHANGES)
**Risk:** Medium  
**Impact:** Image upload/edit features  
**Priority:** Medium

---

## 🎯 UPGRADE STRATEGY

### Phase 1: Flutter SDK Upgrade
### Phase 2: OneSignal Migration (Critical)
### Phase 3: Firebase Updates
### Phase 4: Other Package Updates
### Phase 5: Testing & Deployment

---

## 📋 PHASE 1: FLUTTER SDK UPGRADE

### Step 1.1: Backup Current State
```bash
# Create backup branch
git checkout -b backup/pre-flutter-upgrade
git push origin backup/pre-flutter-upgrade

# Return to main branch
git checkout main
```

### Step 1.2: Upgrade Flutter SDK
```bash
# Check current version
flutter --version

# Upgrade to latest stable
flutter upgrade

# Expected: Flutter 3.24.x or later

# Clean project
flutter clean
flutter pub get
```

### Step 1.3: Fix Deprecated APIs
```bash
# Analyze code for issues
flutter analyze

# Auto-fix deprecated code
dart fix --dry-run
dart fix --apply
```

---

## 📋 PHASE 2: ONESIGNAL MIGRATION (CRITICAL)

### Current Implementation (OneSignal 3.x)
```dart
// Old initialization
OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");
OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  // Handle notification opened
});
```

### New Implementation (OneSignal 5.x)

#### Step 2.1: Update pubspec.yaml
```yaml
dependencies:
  # Old
  # onesignal_flutter: ^3.5.1
  
  # New
  onesignal_flutter: ^5.1.0
```

#### Step 2.2: Update Initialization Code

**Create:** `lib/services/onesignal_service.dart`

```dart
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static Future<void> initialize() async {
    // Initialize OneSignal
    OneSignal.initialize("YOUR_ONESIGNAL_APP_ID");
    
    // Request permission (iOS)
    await OneSignal.Notifications.requestPermission(true);
    
    // Set up notification handlers
    _setupNotificationHandlers();
  }
  
  static void _setupNotificationHandlers() {
    // Handle notification opened
    OneSignal.Notifications.addClickListener((event) {
      print('Notification clicked: ${event.notification.notificationId}');
      _handleNotificationOpened(event.notification);
    });
    
    // Handle notification received (foreground)
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('Notification received in foreground');
      // You can prevent the notification from displaying
      // event.preventDefault();
      
      // Or display it
      event.notification.display();
    });
  }
  
  static void _handleNotificationOpened(OSNotification notification) {
    // Navigate based on notification data
    final additionalData = notification.additionalData;
    if (additionalData != null) {
      final String? screen = additionalData['screen'];
      // Navigate to screen
      // navigatorKey.currentState?.pushNamed(screen ?? '/');
    }
  }
  
  // Set external user ID
  static Future<void> setExternalUserId(String userId) async {
    await OneSignal.login(userId);
  }
  
  // Remove external user ID
  static Future<void> removeExternalUserId() async {
    await OneSignal.logout();
  }
  
  // Send tags
  static Future<void> sendTags(Map<String, String> tags) async {
    await OneSignal.User.addTags(tags);
  }
  
  // Remove tags
  static Future<void> removeTags(List<String> keys) async {
    await OneSignal.User.removeTags(keys);
  }
}
```

#### Step 2.3: Update main.dart

```dart
import 'package:flutter/material.dart';
import 'services/onesignal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize OneSignal
  await OneSignalService.initialize();
  
  runApp(MyApp());
}
```

#### Step 2.4: Migration Checklist

- [ ] Update pubspec.yaml
- [ ] Create OneSignalService class
- [ ] Update main.dart initialization
- [ ] Replace all OneSignal.shared calls
- [ ] Update notification handlers
- [ ] Test notification reception
- [ ] Test notification opening
- [ ] Test deep linking
- [ ] Test user tagging
- [ ] Test on iOS
- [ ] Test on Android

---

## 📋 PHASE 3: FIREBASE UPDATES

### Step 3.1: Update pubspec.yaml

```yaml
dependencies:
  # Current versions → New versions
  firebase_core: ^3.6.0        # was ^2.15.1
  firebase_auth: ^5.3.1         # was ^4.8.0
  firebase_database: ^11.1.4    # was ^10.2.5
  firebase_storage: ^12.3.2     # was ^11.6.7
```

### Step 3.2: Run Upgrade
```bash
flutter pub upgrade
```

### Step 3.3: Check for Breaking Changes
```bash
# Check changelog
flutter pub outdated
```

### Step 3.4: Test Firebase Features
- [ ] Authentication (email/password)
- [ ] Social login (Google, Facebook, Apple)
- [ ] Real-time database reads
- [ ] Real-time database writes
- [ ] File uploads to Storage
- [ ] File downloads from Storage

---

## 📋 PHASE 4: OTHER PACKAGE UPDATES

### Step 4.1: Update Image Cropper (Breaking Changes)

```yaml
dependencies:
  # Old
  # image_cropper: ^4.0.1
  
  # New
  image_cropper: ^8.0.2
```

**Breaking Changes:**
- API completely redesigned
- Check migration guide: https://pub.dev/packages/image_cropper/changelog

### Step 4.2: Update Other Packages

```yaml
dependencies:
  flutter_bloc: ^8.1.6          # was ^8.1.3 (minor update)
  dio: ^5.7.0                   # was ^5.3.2 (check breaking changes)
  retrofit: ^4.4.1              # was ^4.0.1
  image_picker: ^1.1.2          # was ^1.0.2
  cached_network_image: ^3.4.1  # was ^3.3.1
  device_info_plus: ^10.1.2     # was ^9.0.3
  permission_handler: ^11.3.1   # was ^10.4.3
  path_provider: ^2.1.4         # was ^2.1.0
```

### Step 4.3: Run Full Upgrade
```bash
flutter pub upgrade --major-versions
```

---

## 🧪 TESTING STRATEGY

### 1. Unit Tests
```bash
flutter test
```

### 2. Widget Tests
```bash
flutter test --coverage
```

### 3. Integration Tests
```bash
flutter test integration_test/
```

### 4. Manual Testing Checklist

#### Authentication
- [ ] Login with email/password
- [ ] Login with Google
- [ ] Login with Facebook
- [ ] Login with Apple Sign In
- [ ] Logout
- [ ] Password reset

#### Push Notifications
- [ ] Receive notification (app closed)
- [ ] Receive notification (app background)
- [ ] Receive notification (app foreground)
- [ ] Open notification navigates correctly
- [ ] Deep linking works
- [ ] User tagging works

#### Firebase Features
- [ ] Real-time data sync
- [ ] File upload
- [ ] File download
- [ ] Chat messages send/receive

#### Image Features
- [ ] Pick image from gallery
- [ ] Take photo with camera
- [ ] Crop image
- [ ] Upload cropped image

#### General
- [ ] App launches successfully
- [ ] No crashes on startup
- [ ] Navigation works
- [ ] Forms submit correctly
- [ ] API calls succeed
- [ ] Error handling works

---

## 📱 PLATFORM-SPECIFIC UPDATES

### iOS Updates

#### Update Podfile
```bash
cd ios
pod repo update
pod install
```

#### Update iOS Deployment Target
**ios/Podfile:**
```ruby
platform :ios, '13.0'  # Update from 11.0 or 12.0
```

#### Update Info.plist for OneSignal
**ios/Runner/Info.plist:**
```xml
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
</array>
```

### Android Updates

#### Update Gradle
**android/build.gradle:**
```gradle
buildscript {
    ext.kotlin_version = '1.9.0'  // Update Kotlin
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'  // Update Gradle
    }
}
```

#### Update Min SDK Version
**android/app/build.gradle:**
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Update from 19 or 20
        targetSdkVersion 34  // Latest
    }
}
```

#### Update AndroidManifest for OneSignal
**android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

## 🚀 BUILD & DEPLOYMENT

### Build for Android
```bash
# Debug build
flutter build apk --debug

# Release build (with obfuscation)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# App Bundle (for Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

### Build for iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release --obfuscate --split-debug-info=build/debug-info

# Archive for App Store
# Use Xcode: Product → Archive
```

---

## 🔧 TROUBLESHOOTING

### Issue: OneSignal Not Receiving Notifications

**Solution:**
```bash
# 1. Check OneSignal dashboard
# 2. Verify App ID is correct
# 3. Check device is subscribed:
OneSignal.User.pushSubscription.id  // Should not be null

# 4. Test with OneSignal dashboard "Send to Test Device"
```

### Issue: Firebase Auth Fails

**Solution:**
```bash
# 1. Check google-services.json (Android) is up to date
# 2. Check GoogleService-Info.plist (iOS) is up to date
# 3. Verify SHA-1 fingerprint in Firebase console
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey
```

### Issue: Image Cropper Crashes

**Solution:**
```dart
// Check new API usage
final croppedFile = await ImageCropper().cropImage(
  sourcePath: imageFile.path,
  uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
    ),
    IOSUiSettings(
      title: 'Crop Image',
    ),
  ],
);
```

### Issue: Build Fails After Upgrade

**Solution:**
```bash
# Clean everything
flutter clean
cd ios && pod deintegrate && pod install && cd ..
cd android && ./gradlew clean && cd ..

# Get dependencies
flutter pub get

# Try building again
flutter build apk
```

---

## 📊 UPGRADE TIMELINE

### Week 1: Preparation
- [ ] Backup codebase
- [ ] Upgrade Flutter SDK
- [ ] Run dart fix
- [ ] Update pubspec.yaml

### Week 2: OneSignal Migration
- [ ] Implement new OneSignal service
- [ ] Update all notification code
- [ ] Test on iOS
- [ ] Test on Android

### Week 3: Firebase & Other Updates
- [ ] Update Firebase packages
- [ ] Update image_cropper
- [ ] Update other packages
- [ ] Test all features

### Week 4: Testing & Deployment
- [ ] Full regression testing
- [ ] Beta testing (TestFlight/Internal Testing)
- [ ] Fix bugs
- [ ] Production release

---

## 🎯 SUCCESS CRITERIA

- [ ] App builds successfully on iOS
- [ ] App builds successfully on Android
- [ ] All tests passing
- [ ] Push notifications working
- [ ] Firebase features working
- [ ] Image upload/crop working
- [ ] No crashes
- [ ] Performance acceptable
- [ ] Beta users approve

---

## 📞 SUPPORT RESOURCES

- **OneSignal Migration:** https://documentation.onesignal.com/docs/flutter-sdk-setup
- **Firebase Flutter:** https://firebase.flutter.dev/
- **Flutter Upgrade:** https://docs.flutter.dev/release/upgrade
- **Image Cropper:** https://pub.dev/packages/image_cropper

---

**Last Updated:** November 5, 2025
