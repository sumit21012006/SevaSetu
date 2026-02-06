import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;

  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userId = 'demo_user_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
    return true;
  }

  Future<bool> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userId = 'demo_user_${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}
