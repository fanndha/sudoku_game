/// File: lib/features/profile/domain/repositories/profile_repository.dart
/// Repository interface untuk profile

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/achievement_entity.dart';
import '../entities/stats_entity.dart';

/// Abstract Repository untuk Profile
abstract class ProfileRepository {
  /// Get user stats
  Future<Either<Failure, StatsEntity>> getUserStats(String userId);

  /// Update user stats
  Future<Either<Failure, void>> updateUserStats(
    String userId,
    Map<String, dynamic> stats,
  );

  /// Get achievements
  Future<Either<Failure, List<AchievementEntity>>> getAchievements(
    String userId,
  );

  /// Unlock achievement
  Future<Either<Failure, AchievementEntity>> unlockAchievement(
    String userId,
    String achievementId,
  );

  /// Update achievement progress
  Future<Either<Failure, void>> updateAchievementProgress(
    String userId,
    String achievementId,
    int progress,
  );

  /// Sync stats with remote
  Future<Either<Failure, void>> syncStats(String userId);
}