/// File: lib/features/settings/data/repositories/settings_repository_impl.dart
/// Implementation dari SettingsRepository

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

/// Implementation dari SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      logger.i('Getting settings', tag: 'SettingsRepository');

      final settings = await localDataSource.getSettings();

      logger.i('Settings retrieved', tag: 'SettingsRepository');
      return Right(settings);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error getting settings',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal memuat pengaturan: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(SettingsEntity settings) async {
    try {
      logger.i('Updating settings', tag: 'SettingsRepository');

      final settingsModel = SettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(settingsModel);

      logger.i('Settings updated', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error updating settings',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(
          message: 'Gagal memperbarui pengaturan: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleTheme(String themeMode) async {
    try {
      logger.i('Toggling theme to: $themeMode', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Theme toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling theme',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah tema: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleSound(bool enabled) async {
    try {
      logger.i('Toggling sound: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(soundEnabled: enabled);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Sound toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling sound',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah suara: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleMusic(bool enabled) async {
    try {
      logger.i('Toggling music: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(musicEnabled: enabled);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Music toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling music',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah musik: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleVibration(bool enabled) async {
    try {
      logger.i('Toggling vibration: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(
        vibrationEnabled: enabled,
      );
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Vibration toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling vibration',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah getaran: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateSoundVolume(double volume) async {
    try {
      logger.i('Updating sound volume: $volume', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(soundVolume: volume);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Sound volume updated', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error updating sound volume',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah volume suara: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateMusicVolume(double volume) async {
    try {
      logger.i('Updating music volume: $volume', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(musicVolume: volume);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Music volume updated', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error updating music volume',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah volume musik: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleAutoValidate(bool enabled) async {
    try {
      logger.i('Toggling auto validate: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(autoValidate: enabled);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Auto validate toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling auto validate',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(
          message: 'Gagal mengubah auto validate: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleErrorHighlight(bool enabled) async {
    try {
      logger.i('Toggling error highlight: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(errorHighlight: enabled);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Error highlight toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling error highlight',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(
          message: 'Gagal mengubah error highlight: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleTimer(bool enabled) async {
    try {
      logger.i('Toggling timer: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(timerEnabled: enabled);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Timer toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling timer',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah timer: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleNotifications(bool enabled) async {
    try {
      logger.i('Toggling notifications: $enabled', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(
        notificationsEnabled: enabled,
      );
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Notifications toggled', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error toggling notifications',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah notifikasi: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changeLanguage(String language) async {
    try {
      logger.i('Changing language to: $language', tag: 'SettingsRepository');

      final currentSettings = await localDataSource.getSettings();
      final updatedSettings = currentSettings.copyWith(language: language);
      await localDataSource.saveSettings(updatedSettings);

      logger.i('Language changed', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error changing language',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mengubah bahasa: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> resetSettings() async {
    try {
      logger.i('Resetting settings to default', tag: 'SettingsRepository');

      final defaultSettings = SettingsModel.defaultSettings();
      await localDataSource.saveSettings(defaultSettings);

      logger.i('Settings reset to default', tag: 'SettingsRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'SettingsRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error resetting settings',
        error: e,
        tag: 'SettingsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal mereset pengaturan: ${e.toString()}'),
      );
    }
  }
}
