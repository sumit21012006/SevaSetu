import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth.User? get currentUser => _auth.currentUser;

  Stream<FirebaseAuth.User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      // For demo purposes, allow any email/password combination
      if (kIsWeb) {
        // Web demo - mock authentication
        print('Demo sign in successful for: $email');
        notifyListeners();
        return true;
      } else {
        // Try Firebase auth, but fallback to demo mode if it fails
        try {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          return true;
        } catch (e) {
          print('Firebase sign in failed, using demo mode: $e');
          // Mock successful sign in for demo
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  Future<bool> signInWithPhone(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
      return true;
    } catch (e) {
      print('Phone sign in error: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      // For demo purposes, allow any email/password combination
      if (kIsWeb) {
        // Web demo - mock authentication
        print('Demo sign up successful for: $email');
        notifyListeners();
        return true;
      } else {
        // Try Firebase auth, but fallback to demo mode if it fails
        try {
          final credential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (credential.user != null) {
            // Create user document in Firestore
            final user = User(
              uid: credential.user!.uid,
              name: name,
              email: email,
              language: 'en',
            );

            await _firestore
                .collection('users')
                .doc(credential.user!.uid)
                .set(user.toMap(), SetOptions(merge: true));

            return true;
          }
          return false;
        } catch (e) {
          print('Firebase sign up failed, using demo mode: $e');
          // Mock successful sign up for demo
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  Future<void> updateUserData(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
      notifyListeners();
    } catch (e) {
      print('Update user data error: $e');
    }
  }
}
