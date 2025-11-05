/// File: lib/features/leaderboard/data/repositories/leaderboard_repository_impl.dart
/// Implementation dari LeaderboardRepository

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_datasource.dart';

/// Implementation dari LeaderboardRepository
class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LeaderboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getLeaderboard({
    required String difficulty,
    required String filter,
    int limit = 100,
  }) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'LeaderboardRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Getting leaderboard: $difficulty ($filter)', tag: 'LeaderboardRepository');

      final entries = await remoteDataSource.getLeaderboard(
        difficulty: difficulty,
        filter: filter,
        limit: limit,
      );

      logger.i('Loaded ${entries.length} entries', tag: 'LeaderboardRepository');
      return Right(entries);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error getting leaderboard', error: e, tag: 'LeaderboardRepository');
      return Left(UnknownFailure(
        message: 'Gagal memuat leaderboard: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateLeaderboard({
    required String userId,
    required String difficulty,
    required int bestTime,
    required int totalSolved,
  }) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'LeaderboardRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Updating leaderboard: $userId ($difficulty)', tag: 'LeaderboardRepository');

      // TODO: Get user info from auth
      // For now, use placeholder values
      await remoteDataSource.updateLeaderboard(
        userId: userId,
        username: 'User', // Should get from auth
        photoUrl: null,
        difficulty: difficulty,
        bestTime: bestTime,
        totalSolved: totalSolved,
        isPremium: false,
      );

      logger.i('Leaderboard updated', tag: 'LeaderboardRepository');
      return const Right(null);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error updating leaderboard', error: e, tag: 'LeaderboardRepository');
      return Left(UnknownFailure(
        message: 'Gagal update leaderboard: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, LeaderboardEntryEntity?>> getUserRank({
    required String userId,
    required String difficulty,
    required String filter,
  }) async {
    try {
      // Check network
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'LeaderboardRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      logger.i('Getting user rank: $userId ($difficulty)', tag: 'LeaderboardRepository');

      final entry = await remoteDataSource.getUserRank(
        userId: userId,
        difficulty: difficulty,
        filter: filter,
      );

      if (entry == null) {
        logger.d('User not found in leaderboard', tag: 'LeaderboardRepository');
        return const Right(null);
      }

      logger.i('User rank: ${entry.rank}', tag: 'LeaderboardRepository');
      return Right(entry);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'LeaderboardRepository');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error getting user rank', error: e, tag: 'LeaderboardRepository');
      return Left(UnknownFailure(
        message: 'Gagal mendapatkan rank: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getTopLeaderboard({
    required String difficulty,
    required String filter,
  }) async {
    // Just call getLeaderboard with limit 10
    return await getLeaderboard(
      difficulty: difficulty,
      filter: filter,
      limit: 10,
    );
  }
}