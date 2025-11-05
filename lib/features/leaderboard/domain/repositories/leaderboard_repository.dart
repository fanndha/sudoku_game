/// File: lib/features/leaderboard/domain/repositories/leaderboard_repository.dart
/// Repository interface untuk leaderboard

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/leaderboard_entry_entity.dart';

/// Abstract Repository untuk Leaderboard
abstract class LeaderboardRepository {
  /// Get leaderboard by difficulty
  /// Filter: 'daily', 'weekly', 'all_time'
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getLeaderboard({
    required String difficulty,
    required String filter,
    int limit = 100,
  });

  /// Update leaderboard entry for user
  Future<Either<Failure, void>> updateLeaderboard({
    required String userId,
    required String difficulty,
    required int bestTime,
    required int totalSolved,
  });

  /// Get user rank in leaderboard
  Future<Either<Failure, LeaderboardEntryEntity?>> getUserRank({
    required String userId,
    required String difficulty,
    required String filter,
  });

  /// Get top 10 leaderboard
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getTopLeaderboard({
    required String difficulty,
    required String filter,
  });
}