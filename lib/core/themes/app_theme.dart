/// File: lib/core/themes/app_theme.dart
/// Main theme configuration

import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Get light theme
  static ThemeData get lightTheme => LightTheme.theme;

  /// Get dark theme
  static ThemeData get darkTheme => DarkTheme.theme;

  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

/// Enum untuk theme mode
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Extension untuk AppThemeMode
extension AppThemeModeExtension on AppThemeMode {
  String get name {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Mode Terang';
      case AppThemeMode.dark:
        return 'Mode Gelap';
      case AppThemeMode.system:
        return 'Ikuti Sistem';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}