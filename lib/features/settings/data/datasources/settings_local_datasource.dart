/// File: lib/features/settings/data/datasources/settings_local_datasource.dart
/// Local data source untuk settings (Hive)

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/settings_model.dart';

/// Abstract class untuk Settings Local Data Source
abstract class SettingsLocalDataSource {
  /// Get settings from local storage
  Future<SettingsModel> getSettings();

  /// Save settings to local storage
  Future<void> saveSettings(SettingsModel settings);

  /// Clear settings
  Future<void> clearSettings();
}

/// Implementation
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String boxName = 'settings_box';
  static const String settingsKey = 'app_settings';

  @override
  Future<SettingsModel> getSettings() async {
    try {
      logger.hive('GET', boxName, key: settingsKey);

      final box = await Hive.openBox(boxName);
      final data = box.get(settingsKey);

      if (data == null) {
        logger.d('No settings found, returning default', tag: 'SettingsLocal');
        return SettingsModel.defaultSettings();
      }

      logger.i('Settings loaded from cache', tag: 'SettingsLocal');
      return SettingsModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      logger.e('Error getting settings', error: e, tag: 'SettingsLocal');
      throw CacheException(
        message: 'Gagal memuat pengaturan: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      logger.hive('SET', boxName, key: settingsKey, value: 'SettingsModel');

      final box = await Hive.openBox(boxName);
      await box.put(settingsKey, settings.toJson());

      logger.i('Settings saved successfully', tag: 'SettingsLocal');
    } catch (e) {
      logger.e('Error saving settings', error: e, tag: 'SettingsLocal');
      throw CacheException(
        message: 'Gagal menyimpan pengaturan: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearSettings() async {
    try {
      logger.hive('DELETE', boxName, key: settingsKey);

      final box = await Hive.openBox(boxName);
      await box.delete(settingsKey);

      logger.i('Settings cleared successfully', tag: 'SettingsLocal');
    } catch (e) {
      logger.e('Error clearing settings', error: e, tag: 'SettingsLocal');
      throw CacheException(
        message: 'Gagal menghapus pengaturan: ${e.toString()}',
      );
    }
  }
}