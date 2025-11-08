/// File: lib/features/settings/presentation/bloc/settings_event.dart
/// Events untuk Settings Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load Settings Event
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Change Theme Event
class ChangeTheme extends SettingsEvent {
  final String themeMode; // 'light', 'dark', 'system'

  const ChangeTheme(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// Toggle Sound Event
class ToggleSoundEvent extends SettingsEvent {
  final bool enabled;

  const ToggleSoundEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Toggle Music Event
class ToggleMusicEvent extends SettingsEvent {
  final bool enabled;

  const ToggleMusicEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Toggle Vibration Event
class ToggleVibrationEvent extends SettingsEvent {
  final bool enabled;

  const ToggleVibrationEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Update Sound Volume Event
class UpdateSoundVolumeEvent extends SettingsEvent {
  final double volume;

  const UpdateSoundVolumeEvent(this.volume);

  @override
  List<Object?> get props => [volume];
}

/// Update Music Volume Event
class UpdateMusicVolumeEvent extends SettingsEvent {
  final double volume;

  const UpdateMusicVolumeEvent(this.volume);

  @override
  List<Object?> get props => [volume];
}

/// Toggle Auto Validate Event
class ToggleAutoValidateEvent extends SettingsEvent {
  final bool enabled;

  const ToggleAutoValidateEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Toggle Error Highlight Event
class ToggleErrorHighlightEvent extends SettingsEvent {
  final bool enabled;

  const ToggleErrorHighlightEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Toggle Timer Event
class ToggleTimerEvent extends SettingsEvent {
  final bool enabled;

  const ToggleTimerEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Toggle Notifications Event
class ToggleNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Change Language Event
class ChangeLanguageEvent extends SettingsEvent {
  final String language;

  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

/// Reset Settings Event
class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}