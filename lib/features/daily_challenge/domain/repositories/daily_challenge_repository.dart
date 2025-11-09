/// File: lib/features/daily_challenge/domain/repositories/daily_challenge_repository.dart
/// Repository interface untuk daily challenge

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/daily_challenge_entity.dart';

/// Abstract Repository untuk Daily Challenge
abstract class DailyChallengeRepository {
  /// Get today's daily challenge
  Future<Either<Failure, DailyChallengeEntity>> getTodayChallenge();

  /// Get daily challenge by date
  Future<Either<Failure, DailyChallengeEntity>> getChallengeByDate(String date);

  /// Complete daily challenge
  Future<Either<Failure, void>> completeChallenge({
    required String challengeId,
    required String userId,
    required int timeSpent,
    required int hintsUsed,
    required int moves,
  });

  /// Get user's challenge history
  Future<Either<Failure, List<DailyChallengeEntity>>> getChallengeHistory(
    String userId,
  );

  /// Check if user completed today's challenge
  Future<Either<Failure, bool>> hasCompletedToday(String userId);

  /// Get challenge leaderboard
  Future<Either<Failure, List<ChallengeLeaderboardEntry>>> getLeaderboard(
    String challengeId,
  );
}

/// Leaderboard Entry
class ChallengeLeaderboardEntry {
  final String userId;
  final String userName;
  final String? photoUrl;
  final int timeSpent;
  final int hintsUsed;
  final int score;
  final int rank;

  ChallengeLeaderboardEntry({
    required this.userId,
    required this.userName,
    this.photoUrl,
    required this.timeSpent,
    required this.hintsUsed,
    required this.score,
    required this.rank,
  });
}