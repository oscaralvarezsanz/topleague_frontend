import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  AppUser? _user;
  bool _isLoading = false;

  AuthProvider(this._authRepository);

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        _user = await _authRepository.getUser(userId);
      }
    } catch (e) {
      // Failed to restore session, maybe clear prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _authRepository.authenticateUser(username, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // We assume user ID 1 for now, as token decode or user profile fetch is needed
      _user = AppUser(id: 1, username: username);
      await prefs.setInt('userId', 1);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authRepository.registerUser(username, password);

      // Auto-login or store the relevant token here if the register endpoint returned one.
      // Based on registerUser implementation, it returns a stub AppUser.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', _user!.id);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');
    notifyListeners();
  }
}
