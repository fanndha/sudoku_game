/// File: lib/features/settings/data/models/settings_model.dart
/// Model untuk settings

import '../../domain/entities/settings_entity.dart';

/// Settings Model
class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.themeMode,
    super.soundEnabled,
    super.musicEnabled,
    super.vibrationEnabled,
    super.soundVolume,
    super.musicVolume,
    super.autoValidate,
    super.errorHighlight,
    super.timerEnabled,
    super.notesEnabled,
    super.notificationsEnabled,
    super.dailyChallengeReminder,
    super.achievementNotifications,
    super.language,
    super.hapticFeedback,
    super.autoSave,
    super.difficulty,
  });

  /// Create from Entity
  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      themeMode: entity.themeMode,
      soundEnabled: entity.soundEnabled,
      musicEnabled: entity.musicEnabled,
      vibrationEnabled: entity.vibrationEnabled,
      soundVolume: entity.soundVolume,
      musicVolume: entity.musicVolume,
      autoValidate: entity.autoValidate,
      errorHighlight: entity.errorHighlight,
      timerEnabled: entity.timerEnabled,
      notesEnabled: entity.notesEnabled,
      notificationsEnabled: entity.notificationsEnabled,
      dailyChallengeReminder: entity.dailyChallengeReminder,
      achievementNotifications: entity.achievementNotifications,
      language: entity.language,
      hapticFeedback: entity.hapticFeedback,
      autoSave: entity.autoSave,
      difficulty: entity.difficulty,
    );
  }

  /// Create from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: json['themeMode'] as String? ?? 'system',
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 1.0,
      musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.7,
      autoValidate: json['autoValidate'] as bool? ?? false,
      errorHighlight: json['errorHighlight'] as bool? ?? true,
      timerEnabled: json['timerEnabled'] as bool? ?? true,
      notesEnabled: json['notesEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyChallengeReminder: json['dailyChallengeReminder'] as bool? ?? true,
      achievementNotifications: json['achievementNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'id',
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      autoSave: json['autoSave'] as bool? ?? true,
      difficulty: json['difficulty'] as String? ?? 'easy',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'vibrationEnabled': vibrationEnabled,
      'soundVolume': soundVolume,
      'musicVolume': musicVolume,
      'autoValidate': autoValidate,
      'errorHighlight': errorHighlight,
      'timerEnabled': timerEnabled,
      'notesEnabled': notesEnabled,
      'notificationsEnabled': notificationsEnabled,
      'dailyChallengeReminder': dailyChallengeReminder,
      'achievementNotifications': achievementNotifications,
      'language': language,
      'hapticFeedback': hapticFeedback,
      'autoSave': autoSave,
      'difficulty': difficulty,
    };
  }

  /// Copy with
  SettingsModel copyWith({
    String? themeMode,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    double? soundVolume,
    double? musicVolume,
    bool? autoValidate,
    bool? errorHighlight,
    bool? timerEnabled,
    bool? notesEnabled,
    bool? notificationsEnabled,
    bool? dailyChallengeReminder,
    bool? achievementNotifications,
    String? language,
    bool? hapticFeedback,
    bool? autoSave,
    String? difficulty,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      autoValidate: autoValidate ?? this.autoValidate,
      errorHighlight: errorHighlight ?? this.errorHighlight,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      notesEnabled: notesEnabled ?? this.notesEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyChallengeReminder: dailyChallengeReminder ?? this.dailyChallengeReminder,
      achievementNotifications: achievementNotifications ?? this.achievementNotifications,
      language: language ?? this.language,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      autoSave: autoSave ?? this.autoSave,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  /// Create default settings
  factory SettingsModel.defaultSettings() {
    return const SettingsModel();
  }
}