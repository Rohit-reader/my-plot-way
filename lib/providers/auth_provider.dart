import 'package:flutter/material.dart';
import '../core/db.dart';
import '../models/user.dart';
import '../core/session.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> loadSession() async {
    _user = await Session.loadUser();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final u = await DatabaseHelper.instance.loginUser(username, password);
    if (u != null) {
      _user = u;
      await Session.saveUser(u);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String role) async {
    try {
      final u = UserModel(username: username, password: password, role: role);
      await DatabaseHelper.instance.insertUser(u);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    await Session.clear();
    notifyListeners();
  }
}
