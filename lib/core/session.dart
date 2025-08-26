import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';

class Session {
  static const _key = 'current_user';
  static Future<void> saveUser(UserModel user) async {
    final p = await SharedPreferences.getInstance();
    p.setString(_key, jsonEncode(user.toMap()));
  }

  static Future<UserModel?> loadUser() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_key);
    if (s == null) return null;
    final m = jsonDecode(s) as Map<String, dynamic>;
    return UserModel.fromMap(m);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    p.remove(_key);
  }
}
