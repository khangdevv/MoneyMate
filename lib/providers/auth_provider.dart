import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  auth.User? _user;
  bool _isLoading = false;

  AuthProvider() {
    _authService.userStream.listen((auth.User? user) {
      _user = user;
      notifyListeners();
    });
  }

  auth.User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      await _authService.signInWithEmailAndPassword(email: email, password: password);
    }
    finally {
      setLoading(false);
    }
  }

  Future<void> register(String email, String password, String displayName) async {
    setLoading(true);
    try {
      await _authService.signUpWithEmailAndPassword(email: email, password: password, displayName: displayName);
    }
    finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    try {
      await _authService.signOut();
    } finally {
      setLoading(false);
    }
  }
}