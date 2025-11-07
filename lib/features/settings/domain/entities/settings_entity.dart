/// File: lib/features/settings/domain/entities/settings_entity.dart
/// Entity untuk application settings

import 'package:equatable/equatable.dart';

/// Settings Entity
class SettingsEntity extends Equatable {
  // Theme Settings
  final String themeMode; // 'light', 'dark', 'system'
  
  // Audio Settings
  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;
  final double soundVolume; // 0.0 - 1.0
  final double musicVolume; // 0.0 - 1.0
  
  // Gameplay Settings
  final bool autoValidate;
  final bool errorHighlight;
  final bool timerEnabled;
  final bool notesEnabled;
  
  // Notification Settings
  final bool notificationsEnabled;
  final bool dailyChallengeReminder;
  final bool achievementNotifications;
  
  // Language Settings
  final String language; // 'id', 'en'
  
  // Other Settings
  final bool hapticFeedback;
  final bool autoSave;
  final String difficulty; // last selected difficulty
  
  const SettingsEntity({
    this.themeMode = 'system',
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.vibrationEnabled = true,
    this.soundVolume = 1.0,
    this.musicVolume = 0.7,
    this.autoValidate = false,
    this.errorHighlight = true,
    this.timerEnabled = true,
    this.notesEnabled = true,
    this.notificationsEnabled = true,
    this.dailyChallengeReminder = true,
    this.achievementNotifications = true,
    this.language = 'id',
    this.hapticFeedback = true,
    this.autoSave = true,
    this.difficulty = 'easy',
  });

  /// Check if dark mode
  bool get isDarkMode => themeMode == 'dark';

  /// Check if light mode
  bool get isLightMode => themeMode == 'light';

  /// Check if system mode
  bool get isSystemMode => themeMode == 'system';

  /// Check if sound or music enabled
  bool get isAudioEnabled => soundEnabled || musicEnabled;

  @override
  List<Object?> get props => [
        themeMode,
        soundEnabled,
        musicEnabled,
        vibrationEnabled,
        soundVolume,
        musicVolume,
        autoValidate,
        errorHighlight,
        timerEnabled,
        notesEnabled,
        notificationsEnabled,
        dailyChallengeReminder,
        achievementNotifications,
        language,
        hapticFeedback,
        autoSave,
        difficulty,
      ];

  @override
  String toString() {
    return 'SettingsEntity(theme: $themeMode, sound: $soundEnabled, music: $musicEnabled)';
  }
}