/// File: lib/features/daily_challenge/data/repositories/daily_challenge_repository_impl.dart
/// Implementation dari DailyChallengeRepository

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/daily_challenge_entity.dart';
import '../../domain/repositories/daily_challenge_repository.dart';
import '../datasources/daily_challenge_remote_datasource.dart';

/// Implementation dari DailyChallengeRepository
class DailyChallengeRepositoryImpl implements DailyChallengeRepository {
  final DailyChallengeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DailyChallengeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DailyChallengeEntity>> getTodayChallenge() async {
    // Check network
    if (!await networkInfo.isConnected) {
      logger.w('No internet connection', tag: 'DailyChallengeRepo');
      return const Left(NetworkFailure(
        message: 'Tidak ada koneksi internet',
      ));
    }

    try {
      logger.i('Getting today\'s challenge', tag: 'DailyChallengeRepo');

      // TODO: Get userId from auth
      const userId = 'temp_user_id';

      final challenge = await remoteDataSource.getTodayChallenge(userId);

      logger.i('Today\'s challenge loaded', tag: 'DailyChallengeRepo');
      return Right(challenge);
    } on DocumentNotFoundException catch (e) {
      logger.e('Challenge not found: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(DocumentNotFoundFailure(
        message: 'Tantangan harian belum tersedia',
      ));
    } on FirestoreException catch (e) {
      logger.e('Firestore error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } on NetworkException catch (e) {
      logger.e('Network error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error', error: e, tag: 'DailyChallengeRepo');
      return Left(UnknownFailure(
        message: 'Gagal memuat tantangan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, DailyChallengeEntity>> getChallengeByDate(
    String date,
  ) async {
    // Check network
    if (!await networkInfo.isConnected) {
      logger.w('No internet connection', tag: 'DailyChallengeRepo');
      return const Left(NetworkFailure(
        message: 'Tidak ada koneksi internet',
      ));
    }

    try {
      logger.i('Getting challenge for date: $date', tag: 'DailyChallengeRepo');

      // TODO: Get userId from auth
      const userId = 'temp_user_id';

      final challenge = await remoteDataSource.getChallengeByDate(
        date,
        userId,
      );

      logger.i('Challenge loaded for $date', tag: 'DailyChallengeRepo');
      return Right(challenge);
    } on DocumentNotFoundException catch (e) {
      logger.e('Challenge not found: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(DocumentNotFoundFailure(
        message: 'Tantangan tidak ditemukan',
      ));
    } on FirestoreException catch (e) {
      logger.e('Firestore error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error', error: e, tag: 'DailyChallengeRepo');
      return Left(UnknownFailure(
        message: 'Gagal memuat tantangan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> completeChallenge({
    required String challengeId,
    required String userId,
    required int timeSpent,
    required int hintsUsed,
    required int moves,
  }) async {
    // Check network
    if (!await networkInfo.isConnected) {
      logger.w('No internet connection', tag: 'DailyChallengeRepo');
      return const Left(NetworkFailure(
        message: 'Tidak ada koneksi internet',
      ));
    }

    try {
      logger.i('Submitting challenge completion', tag: 'DailyChallengeRepo');

      await remoteDataSource.submitCompletion(
        challengeId: challengeId,
        userId: userId,
        timeSpent: timeSpent,
        hintsUsed: hintsUsed,
        moves: moves,
      );

      logger.i('Challenge completed successfully', tag: 'DailyChallengeRepo');
      return const Right(null);
    } on FirestoreException catch (e) {
      logger.e('Firestore error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } on ServerException catch (e) {
      logger.e('Server error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error', error: e, tag: 'DailyChallengeRepo');
      return Left(UnknownFailure(
        message: 'Gagal mengirim hasil: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<DailyChallengeEntity>>> getChallengeHistory(
    String userId,
  ) async {
    // Check network
    if (!await networkInfo.isConnected) {
      logger.w('No internet connection', tag: 'DailyChallengeRepo');
      return const Left(NetworkFailure(
        message: 'Tidak ada koneksi internet',
      ));
    }

    try {
      logger.i('Getting challenge history', tag: 'DailyChallengeRepo');

      final challenges = await remoteDataSource.getCompletionHistory(userId);

      logger.i('Loaded ${challenges.length} challenges', tag: 'DailyChallengeRepo');
      return Right(challenges);
    } on FirestoreException catch (e) {
      logger.e('Firestore error: ${e.message}', tag: 'DailyChallengeRepo');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error', error: e, tag: 'DailyChallengeRepo');
      return Left(UnknownFailure(
        message: 'Gagal memuat riwayat: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCompletedToday(String userId) async {
    try {
      logger.i('Checking today\'s completion status', tag: 'DailyChallengeRepo');

      final hasCompleted = await remoteDataSource.hasCompletedToday(userId);

      logger.i('Has completed today: $hasCompleted', tag: 'DailyChallengeRepo');
      return Right(hasCompleted);
    } catch (e) {
      logger.e('Error checking completion', error: e, tag: 'DailyChallengeRepo');
      // Return false on error (not critical)
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, List<ChallengeLeaderboardEntry>>> getLeaderboard(
    String challengeId,
  ) async {
    // TODO: Implement leaderboard
    // This would require additional Firestore structure
    logger.w('Leaderboard not implemented yet', tag: 'DailyChallengeRepo');
    return const Right([]);
  }
}