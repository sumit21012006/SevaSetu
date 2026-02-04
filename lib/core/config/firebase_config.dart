import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<FirebaseApp> initializeFirebase() async {
    try {
      FirebaseApp firebaseApp;

      if (kIsWeb) {
        // Web configuration
        firebaseApp = await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyB8Z8Qq4Z8QZ8QZ8QZ8QZ8QZ8QZ8QZ8QZ8",
            authDomain: "sevasetu-app.firebaseapp.com",
            projectId: "sevasetu-app",
            storageBucket: "sevasetu-app.appspot.com",
            messagingSenderId: "123456789",
            appId: "1:123456789:web:1234567890abcdef",
          ),
        );
      } else {
        // Mobile configuration - this will use the platform-specific config
        firebaseApp = await Firebase.initializeApp();
      }

      return firebaseApp;
    } catch (e) {
      // For demo purposes, return a mock FirebaseApp if initialization fails
      print('Firebase initialization failed: $e');
      // Return null for now - the app will work without Firebase for demo
      throw Exception('Firebase initialization failed');
    }
  }
}

// Firebase Security Rules for SevaSetu
// 
// These rules ensure that users can only access their own data
// 
// users/{userId} - User profile data
// users/{userId}/documents/{documentId} - User documents
// 
// Rules:
// - Users can read/write their own profile
// - Users can read/write their own documents
// - No public access to user data

/*
// Firebase Firestore Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profiles
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // User documents
    match /users/{userId}/documents/{documentId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}

// Firebase Storage Rules
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{documentId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
*/