import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers whether the user chose light or dark mode.
///
/// Same pattern as BookmarkService: one shared instance exposing a
/// ValueNotifier, which MaterialApp listens to.
class ThemeService {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const String _storageKey = 'flashnews.themeMode';

  final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(ThemeMode.system);

  Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? stored = prefs.getString(_storageKey);
      mode.value = _parse(stored);
    } catch (_) {
      mode.value = ThemeMode.system;
    }
  }

  bool get isDark => mode.value == ThemeMode.dark;

  Future<void> toggle() async {
    // Treat "system" as light, so the first tap always produces a visible change.
    mode.value = mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, mode.value.name);
    } catch (_) {}
  }

  ThemeMode _parse(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
