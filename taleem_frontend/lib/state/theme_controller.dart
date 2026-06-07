import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static const _key = 'theme_mode';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'dark') {
      mode.value = ThemeMode.dark;
    } else if (saved == 'light') {
      mode.value = ThemeMode.light;
    } else {
      mode.value = ThemeMode.system;
    }
  }

  static Future<void> setMode(ThemeMode m) async {
    mode.value = m;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      m == ThemeMode.dark
          ? 'dark'
          : m == ThemeMode.light
              ? 'light'
              : 'system',
    );
  }
}
