/// File: lib/features/settings/domain/repositories/settings_repository.dart
/// Repository interface untuk settings

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/settings_entity.dart';

/// Abstract Repository untuk Settings
abstract class SettingsRepository {
  /// Get current settings
  Future<Either<Failure, SettingsEntity>> getSettings();

  /// Update settings
  Future<Either<Failure, void>> updateSettings(SettingsEntity settings);

  /// Toggle theme mode
  Future<Either<Failure, void>> toggleTheme(String themeMode);

  /// Toggle sound
  Future<Either<Failure, void>> toggleSound(bool enabled);

  /// Toggle music
  Future<Either<Failure, void>> toggleMusic(bool enabled);

  /// Toggle vibration
  Future<Either<Failure, void>> toggleVibration(bool enabled);

  /// Update sound volume
  Future<Either<Failure, void>> updateSoundVolume(double volume);

  /// Update music volume
  Future<Either<Failure, void>> updateMusicVolume(double volume);

  /// Toggle auto validate
  Future<Either<Failure, void>> toggleAutoValidate(bool enabled);

  /// Toggle error highlight
  Future<Either<Failure, void>> toggleErrorHighlight(bool enabled);

  /// Toggle timer
  Future<Either<Failure, void>> toggleTimer(bool enabled);

  /// Toggle notifications
  Future<Either<Failure, void>> toggleNotifications(bool enabled);

  /// Change language
  Future<Either<Failure, void>> changeLanguage(String language);

  /// Reset to default settings
  Future<Either<Failure, void>> resetSettings();
}