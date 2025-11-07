/// File: lib/features/profile/data/datasources/profile_local_datasource.dart
/// Local data source untuk profile (Hive)

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/achievement_model.dart';
import '../models/stats_model.dart';

/// Abstract class untuk Profile Local Data Source
abstract class ProfileLocalDataSource {
  /// Get user stats from cache
  Future<StatsModel?> getCachedStats(String userId);

  /// Cache user stats
  Future<void> cacheStats(StatsModel stats);

  /// Get achievements from cache
  Future<List<AchievementModel>?> getCachedAchievements(String userId);

  /// Cache achievements
  Future<void> cacheAchievements(List<AchievementModel> achievements, String userId);

  /// Clear cache
  Future<void> clearCache(String userId);
}

/// Implementation
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String statsBoxName = 'stats_box';
  static const String achievementsBoxName = 'achievements_box';

  @override
  Future<StatsModel?> getCachedStats(String userId) async {
    try {
      logger.hive('GET', statsBoxName, key: userId);

      final box = await Hive.openBox(statsBoxName);
      final data = box.get(userId);

      if (data == null) {
        logger.d('No cached stats found', tag: 'ProfileLocal');
        return null;
      }

      logger.i('Stats loaded from cache', tag: 'ProfileLocal');
      return StatsModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      logger.e('Error getting cached stats', error: e, tag: 'ProfileLocal');
      throw CacheException(
        message: 'Gagal memuat data lokal: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheStats(StatsModel stats) async {
    try {
      logger.hive('SET', statsBoxName, key: stats.userId, value: 'StatsModel');

      final box = await Hive.openBox(statsBoxName);
      await box.put(stats.userId, stats.toJson());

      logger.i('Stats cached successfully', tag: 'ProfileLocal');
    } catch (e) {
      logger.e('Error caching stats', error: e, tag: 'ProfileLocal');
      throw CacheException(
        message: 'Gagal menyimpan data lokal: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<AchievementModel>?> getCachedAchievements(String userId) async {
    try {
      logger.hive('GET', achievementsBoxName, key: userId);

      final box = await Hive.openBox(achievementsBoxName);
      final data = box.get(userId);

      if (data == null) {
        logger.d('No cached achievements found', tag: 'ProfileLocal');
        return null;
      }

      final list = List<Map<String, dynamic>>.from(data);
      final achievements = list
          .map((json) => AchievementModel.fromJson(json))
          .toList();

      logger.i('Loaded ${achievements.length} achievements from cache', tag: 'ProfileLocal');
      return achievements;
    } catch (e) {
      logger.e('Error getting cached achievements', error: e, tag: 'ProfileLocal');
      throw CacheException(
        message: 'Gagal memuat data lokal: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheAchievements(
    List<AchievementModel> achievements,
    String userId,
  ) async {
    try {
      logger.hive(
        'SET',
        achievementsBoxName,
        key: userId,
        value: '${achievements.length} achievements',
      );

      final box = await Hive.openBox(achievementsBoxName);
      final data = achievements.map((a) => a.toJson()).toList();
      await box.put(userId, data);

      logger.i('Achievements cached successfully', tag: 'ProfileLocal');
    } catch (e) {
      logger.e('Error caching achievements', error: e, tag: 'ProfileLocal');
      throw CacheException(
        message: 'Gagal menyimpan data lokal: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    try {
      logger.hive('DELETE', statsBoxName, key: userId);
      logger.hive('DELETE', achievementsBoxName, key: userId);

      final statsBox = await Hive.openBox(statsBoxName);
      final achievementsBox = await Hive.openBox(achievementsBoxName);

      await statsBox.delete(userId);
      await achievementsBox.delete(userId);

      logger.i('Cache cleared successfully', tag: 'ProfileLocal');
    } catch (e) {
      logger.e('Error clearing cache', error: e, tag: 'ProfileLocal');
      throw CacheException(
        message: 'Gagal menghapus data lokal: ${e.toString()}',
      );
    }
  }
}