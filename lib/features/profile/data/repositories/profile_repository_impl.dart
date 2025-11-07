/// File: lib/features/profile/data/repositories/profile_repository_impl.dart
/// Implementation dari ProfileRepository

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/stats_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

/// Implementation dari ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, StatsEntity>> getUserStats(String userId) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet, loading from cache', tag: 'ProfileRepository');
        
        // Try to load from cache
        final cachedStats = await localDataSource.getCachedStats(userId);
        if (cachedStats != null) {
          logger.i('Stats loaded from cache', tag: 'ProfileRepository');
          return Right(cachedStats);
        }
        
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Getting stats from remote', tag: 'ProfileRepository');

      // Get from remote
      final stats = await remoteDataSource.getUserStats(userId);
      
      // Cache the stats
      await localDataSource.cacheStats(stats);
      
      logger.i('Stats retrieved and cached', tag: 'ProfileRepository');
      return Right(stats);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'ProfileRepository');
      
      // Try cache on error
      try {
        final cachedStats = await localDataSource.getCachedStats(userId);
        if (cachedStats != null) {
          logger.i('Using cached stats after error', tag: 'ProfileRepository');
          return Right(cachedStats);
        }
      } catch (_) {}
      
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'ProfileRepository');
      return Left(CacheFailure(message: e.message));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'ProfileRepository');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error getting stats', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal memuat statistik: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserStats(
    String userId,
    Map<String, dynamic> stats,
  ) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'ProfileRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Updating stats', tag: 'ProfileRepository');

      // Update remote
      await remoteDataSource.updateUserStats(userId, stats);
      
      // Get updated stats and cache
      final updatedStats = await remoteDataSource.getUserStats(userId);
      await localDataSource.cacheStats(updatedStats);
      
      logger.i('Stats updated successfully', tag: 'ProfileRepository');
      return const Right(null);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'ProfileRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'ProfileRepository');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error updating stats', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal memperbarui statistik: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<AchievementEntity>>> getAchievements(
    String userId,
  ) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet, loading from cache', tag: 'ProfileRepository');
        
        // Try to load from cache
        final cachedAchievements = 
            await localDataSource.getCachedAchievements(userId);
        if (cachedAchievements != null) {
          logger.i('Achievements loaded from cache', tag: 'ProfileRepository');
          return Right(cachedAchievements);
        }
        
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Getting achievements from remote', tag: 'ProfileRepository');

      // Get from remote
      final achievements = await remoteDataSource.getAchievements(userId);
      
      // Cache the achievements
      await localDataSource.cacheAchievements(achievements, userId);
      
      logger.i('Achievements retrieved and cached', tag: 'ProfileRepository');
      return Right(achievements);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'ProfileRepository');
      
      // Try cache on error
      try {
        final cachedAchievements = 
            await localDataSource.getCachedAchievements(userId);
        if (cachedAchievements != null) {
          logger.i('Using cached achievements after error', tag: 'ProfileRepository');
          return Right(cachedAchievements);
        }
      } catch (_) {}
      
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'ProfileRepository');
      return Left(CacheFailure(message: e.message));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'ProfileRepository');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error getting achievements', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal memuat pencapaian: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, AchievementEntity>> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'ProfileRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Unlocking achievement: $achievementId', tag: 'ProfileRepository');

      // Unlock achievement
      final achievement = await remoteDataSource.unlockAchievement(
        userId,
        achievementId,
      );
      
      // Refresh cache
      final achievements = await remoteDataSource.getAchievements(userId);
      await localDataSource.cacheAchievements(achievements, userId);
      
      logger.i('Achievement unlocked: $achievementId', tag: 'ProfileRepository');
      return Right(achievement);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'ProfileRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'ProfileRepository');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error unlocking achievement', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal membuka pencapaian: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateAchievementProgress(
    String userId,
    String achievementId,
    int progress,
  ) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'ProfileRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Updating achievement progress: $achievementId', tag: 'ProfileRepository');

      // Update progress
      await remoteDataSource.updateAchievementProgress(
        userId,
        achievementId,
        progress,
      );
      
      // Refresh cache
      final achievements = await remoteDataSource.getAchievements(userId);
      await localDataSource.cacheAchievements(achievements, userId);
      
      logger.i('Achievement progress updated', tag: 'ProfileRepository');
      return const Right(null);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'ProfileRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'ProfileRepository');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error updating progress', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal memperbarui progress: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> syncStats(String userId) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Syncing stats', tag: 'ProfileRepository');

      // Get fresh data from remote
      final stats = await remoteDataSource.getUserStats(userId);
      final achievements = await remoteDataSource.getAchievements(userId);
      
      // Update cache
      await localDataSource.cacheStats(stats);
      await localDataSource.cacheAchievements(achievements, userId);
      
      logger.i('Stats synced successfully', tag: 'ProfileRepository');
      return const Right(null);
    } catch (e) {
      logger.e('Error syncing stats', error: e, tag: 'ProfileRepository');
      return Left(UnknownFailure(
        message: 'Gagal sinkronisasi: ${e.toString()}',
      ));
    }
  }
}