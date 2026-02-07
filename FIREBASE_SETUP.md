# 🔥 Firebase Setup Guide for SevaSetu

## Step 1: Create Firebase Project

1. **Go to:** https://console.firebase.google.com/
2. **Click:** "Add project" → Enter name: `sevasetu-app`
3. **Disable:** Google Analytics (optional, faster setup)
4. **Wait:** For project creation to complete

---

## Step 2: Register Your App

### For Android:
1. Click the **Android icon** (</>)
2. **Android package name:** `com.example.sevasetu_app`
3. **App nickname:** `SevaSetu`
4. Click "Register app"

### For iOS:
1. Click the **iOS icon** (</>)
2. **iOS bundle ID:** `com.example.sevasetuApp`
3. **App nickname:** `SevaSetu`
4. Click "Register app"

---

## Step 3: Download Config Files

### Android:
1. Download `google-services.json`
2. Place it in: `android/app/google-services.json`

### iOS:
1. Download `GoogleService-Info.plist`
2. Place it in: `ios/Runner/GoogleService-Info.plist`

---

## Step 4: Add Firebase SDK

### Android (android/build.gradle.kts):
```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

### Android (android/app/build.gradle.kts):
```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // <-- ADD THIS AT BOTTOM
}
```

### iOS (ios/Podfile):
```ruby
platform :ios, '15.0'  # Update to 15.0 minimum
```

---

## Step 5: Update pubspec.yaml

```yaml
dependencies:
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^6.1.2
  firebase_storage: ^13.0.6
```

---

## Step 6: Run Commands

```bash
flutter pub get
# For iOS:
cd ios && pod install && cd ..
flutter run
```

---

## 🔐 Firebase Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /documents/{documentId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## ⏱️ After Setup, I'll Update Your Code:
- ✅ Initialize Firebase in main.dart
- ✅ Connect AuthService to Firebase Auth
- ✅ Connect DocumentProvider to Firestore
- ✅ Enable persistent data storage

---

## ⚠️ Having Issues?

Try this quick fix:
```bash
flutter clean
flutter pub get
flutter pub upgrade --major-versions
```

---

**Once you complete these steps, reply and I'll update your Flutter code to connect to Firebase! 🚀**
