# 🔥 Firestore Setup Guide

## Step 1: Enable Firestore Database

1. **Go to:** https://console.firebase.google.com/project/sevasetu-app
2. **Click:** "Firestore Database" in the left menu
3. **Click:** "Create database"
4. **Select:** "Start in test mode" (for development)
5. **Choose:** Location closest to you
6. **Click:** "Enable"

---

## Step 2: Create Collection

1. **Click:** "Start collection"
2. **Collection ID:** `documents`
3. **Click:** "Next"
4. **Document ID:** Leave auto-generated
5. **Add field:** `type` → `string` → `Aadhaar Card`
6. **Add field:** `userId` → `string` → `demo`
7. **Add field:** `status` → `string` → `Valid`
8. **Click:** "Save"

---

## Step 3: Security Rules (for development)

In Firestore → Rules, use:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // Test mode
    }
  }
}
```

**Note:** For production, change to:
```javascript
allow read, write: if request.auth != null;
```

---

## Step 4: Run the App

```bash
flutter pub get
flutter run
```

---

## ✅ What's Now Working:

- ✅ Firebase Authentication (Email/Password)
- ✅ Firestore Database (Documents)
- ✅ Demo mode fallback (if Firebase unavailable)
- ✅ Persistent data storage

---

## 🔧 Troubleshooting

**Error:** `services/auth_service.dart`
- Make sure Firestore is enabled in Firebase Console

**Error:** App won't start
- Run: `flutter clean` then `flutter pub get`

**Error:** Authentication not working
- Check email/password format
- Ensure Firebase Auth is enabled in Console

---

**Ready to test? Run:** `flutter run`
