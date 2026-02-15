import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
import '../services/services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isVerifiedNGO => _user?.role == UserRole.ngo && _user?.isVerified == true;
  bool get isVolunteer => _user?.role == UserRole.volunteer || _user?.role == UserRole.public;

  AuthProvider() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      setLoading(true);
      setError(null);
      _user = await _authService.signInWithEmailAndPassword(email, password);
      setLoading(false);
      return _user != null;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return false;
    }
  }

  Future<bool> registerPublicUser({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? phone,
  }) async {
    try {
      setLoading(true);
      setError(null);
      _user = await _authService.registerPublicUser(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
        phone: phone,
      );
      setLoading(false);
      return _user != null;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return false;
    }
  }

  Future<bool> registerNGO({
    required String email,
    required String password,
    required String organizationName,
    required String contactPerson,
    required String ngoUin,
    String? phone,
  }) async {
    try {
      setLoading(true);
      setError(null);
      _user = await _authService.registerNGO(
        email: email,
        password: password,
        organizationName: organizationName,
        contactPerson: contactPerson,
        ngoUin: ngoUin,
        phone: phone,
      );
      setLoading(false);
      return _user != null;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      setLoading(true);
      await _authService.signOut();
      _user = null;
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError(e.toString());
    }
  }

  Future<void> refreshUser() async {
    if (_authService.currentUser != null) {
      _user = await _authService.getUserData(_authService.currentUser!.uid);
      notifyListeners();
    }
  }
}