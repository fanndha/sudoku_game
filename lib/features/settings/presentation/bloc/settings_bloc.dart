/// File: lib/features/settings/presentation/bloc/settings_bloc.dart
/// BLoC untuk Settings

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/features/settings/domain/entities/settings_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/toggle_music.dart';
import '../../domain/usecases/toggle_sound.dart';
import '../../domain/usecases/toggle_theme.dart';
import '../../domain/usecases/update_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// Settings Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateSettings updateSettings;
  final ToggleTheme toggleTheme;
  final ToggleSound toggleSound;
  final ToggleMusic toggleMusic;

  SettingsBloc({
    required this.getSettings,
    required this.updateSettings,
    required this.toggleTheme,
    required this.toggleSound,
    required this.toggleMusic,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeTheme>(_onChangeTheme);
    on<ToggleSoundEvent>(_onToggleSound);
    on<ToggleMusicEvent>(_onToggleMusic);
    on<ToggleVibrationEvent>(_onToggleVibration);
    on<UpdateSoundVolumeEvent>(_onUpdateSoundVolume);
    on<UpdateMusicVolumeEvent>(_onUpdateMusicVolume);
    on<ToggleAutoValidateEvent>(_onToggleAutoValidate);
    on<ToggleErrorHighlightEvent>(_onToggleErrorHighlight);
    on<ToggleTimerEvent>(_onToggleTimer);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  /// Load Settings
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);
    emit(const SettingsLoading());

    final result = await getSettings();

    result.fold(
      (failure) {
        logger.e(
          'Failed to load settings: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(
          SettingsError(
            message: _mapFailureToMessage(failure),
            code: failure.code,
          ),
        );
      },
      (settings) {
        logger.i('Settings loaded', tag: 'SettingsBloc');
        emit(SettingsLoaded(settings));
      },
    );
  }

  /// Change Theme
  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final result = await toggleTheme(
      ToggleThemeParams(themeMode: event.themeMode),
    );

    result.fold(
      (failure) {
        logger.e(
          'Failed to change theme: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Theme changed to: ${event.themeMode}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Sound
  Future<void> _onToggleSound(
    ToggleSoundEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final result = await toggleSound(ToggleSoundParams(enabled: event.enabled));

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle sound: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Sound toggled: ${event.enabled}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Music
  Future<void> _onToggleMusic(
    ToggleMusicEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final result = await toggleMusic(ToggleMusicParams(enabled: event.enabled));

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle music: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Music toggled: ${event.enabled}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Vibration
  Future<void> _onToggleVibration(
    ToggleVibrationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    // Direct update via updateSettings
    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(vibrationEnabled: event.enabled),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle vibration: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Vibration toggled: ${event.enabled}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Update Sound Volume
  Future<void> _onUpdateSoundVolume(
    UpdateSoundVolumeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(soundVolume: event.volume),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to update sound volume: ${failure.message}',
          tag: 'SettingsBloc',
        );
      },
      (_) {
        logger.i('Sound volume updated: ${event.volume}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Update Music Volume
  Future<void> _onUpdateMusicVolume(
    UpdateMusicVolumeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(musicVolume: event.volume),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to update music volume: ${failure.message}',
          tag: 'SettingsBloc',
        );
      },
      (_) {
        logger.i('Music volume updated: ${event.volume}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Auto Validate
  Future<void> _onToggleAutoValidate(
    ToggleAutoValidateEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(autoValidate: event.enabled),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle auto validate: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i(
          'Auto validate toggled: ${event.enabled}',
          tag: 'SettingsBloc',
        );
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Error Highlight
  Future<void> _onToggleErrorHighlight(
    ToggleErrorHighlightEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(errorHighlight: event.enabled),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle error highlight: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i(
          'Error highlight toggled: ${event.enabled}',
          tag: 'SettingsBloc',
        );
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Timer
  Future<void> _onToggleTimer(
    ToggleTimerEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(timerEnabled: event.enabled),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle timer: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Timer toggled: ${event.enabled}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Toggle Notifications
  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(
        notificationsEnabled: event.enabled,
      ),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to toggle notifications: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i(
          'Notifications toggled: ${event.enabled}',
          tag: 'SettingsBloc',
        );
        add(const LoadSettings());
      },
    );
  }

  /// Change Language
  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    final updatedSettings = UpdateSettingsParams(
      settings: currentState.settings.copyWith(language: event.language),
    );

    final result = await updateSettings(updatedSettings);

    result.fold(
      (failure) {
        logger.e(
          'Failed to change language: ${failure.message}',
          tag: 'SettingsBloc',
        );
        emit(SettingsError(message: _mapFailureToMessage(failure)));
        emit(currentState);
      },
      (_) {
        logger.i('Language changed to: ${event.language}', tag: 'SettingsBloc');
        add(const LoadSettings());
      },
    );
  }

  /// Reset Settings
  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    logger.blocEvent('SettingsBloc', event);

    // Implementation would call repository's resetSettings
    add(const LoadSettings());
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) {
      return failure.message;
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}

/// Extension untuk SettingsEntity copyWith
extension SettingsEntityCopyWith on SettingsEntity {
  SettingsEntity copyWith({
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
    return SettingsEntity(
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
      dailyChallengeReminder:
          dailyChallengeReminder ?? this.dailyChallengeReminder,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      language: language ?? this.language,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      autoSave: autoSave ?? this.autoSave,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
