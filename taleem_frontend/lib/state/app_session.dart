import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child.dart';
import '../models/user.dart';

class AppSession {
  static final AppSession instance = AppSession._();
  AppSession._();

  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';
  static const _kChild = 'current_child';

  String? token;
  AppUser? user;
  Child? currentChild;

  bool get isAuthed => token != null && token!.isNotEmpty;
  bool get hasChild => currentChild != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_kToken);

    final userJson = prefs.getString(_kUser);
    if (userJson != null) {
      try {
        user = AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        user = null;
      }
    }

    final childJson = prefs.getString(_kChild);
    if (childJson != null) {
      try {
        currentChild = Child.fromJson(jsonDecode(childJson) as Map<String, dynamic>);
      } catch (_) {
        currentChild = null;
      }
    }
  }

  Future<void> setAuth({required String token, required AppUser user}) async {
    this.token = token;
    this.user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  Future<void> setCurrentChild(Child? child) async {
    currentChild = child;
    final prefs = await SharedPreferences.getInstance();
    if (child == null) {
      await prefs.remove(_kChild);
    } else {
      await prefs.setString(_kChild, jsonEncode(child.toJson()));
    }
  }

  Future<void> clear() async {
    token = null;
    user = null;
    currentChild = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    await prefs.remove(_kChild);
  }
}
