/// File: lib/features/auth/data/datasources/auth_local_datasource.dart
/// Local data source untuk authentication (Hive/SharedPreferences)

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

/// Abstract class untuk Auth Local Data Source
abstract class AuthLocalDataSource {
  /// Cache user data
  Future<void> cacheUser(UserModel user);
  
  /// Get cached user
  Future<UserModel?> getCachedUser();
  
  /// Clear cached user (untuk logout)
  Future<void> clearCache();
  
  /// Check if user is cached
  Future<bool> hasCachedUser();
}

/// Implementation dari AuthLocalDataSource menggunakan SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Cache key
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      logger.hive(
        'WRITE',
        'SharedPreferences',
        key: cachedUserKey,
        value: user.toJson(),
      );

      final jsonString = json.encode(user.toJson());
      final success = await sharedPreferences.setString(
        cachedUserKey,
        jsonString,
      );

      if (!success) {
        throw CacheException(message: 'Failed to cache user data');
      }

      logger.i('User data cached successfully', tag: 'Auth');
    } catch (e) {
      logger.e('Error caching user data', error: e, tag: 'Auth');
      throw CacheException(
        message: 'Gagal menyimpan data user: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      logger.hive('READ', 'SharedPreferences', key: cachedUserKey);

      final jsonString = sharedPreferences.getString(cachedUserKey);

      if (jsonString == null) {
        logger.d('No cached user found', tag: 'Auth');
        return null;
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final user = UserModel.fromJson(jsonMap);

      logger.i('Cached user retrieved successfully', tag: 'Auth');
      return user;
    } catch (e) {
      logger.e('Error getting cached user', error: e, tag: 'Auth');
      throw CacheException(
        message: 'Gagal mengambil data user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      logger.hive('DELETE', 'SharedPreferences', key: cachedUserKey);

      final success = await sharedPreferences.remove(cachedUserKey);

      if (!success) {
        throw CacheException(message: 'Failed to clear cache');
      }

      logger.i('Cache cleared successfully', tag: 'Auth');
    } catch (e) {
      logger.e('Error clearing cache', error: e, tag: 'Auth');
      throw CacheException(
        message: 'Gagal menghapus cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> hasCachedUser() async {
    try {
      final hasCached = sharedPreferences.containsKey(cachedUserKey);
      logger.d('Has cached user: $hasCached', tag: 'Auth');
      return hasCached;
    } catch (e) {
      logger.e('Error checking cached user', error: e, tag: 'Auth');
      return false;
    }
  }
}