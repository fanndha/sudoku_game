/// File: lib/features/profile/domain/usecases/unlock_achievement.dart
/// UseCase untuk unlock achievement

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/achievement_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase untuk Unlock Achievement
class UnlockAchievement
    implements UseCase<AchievementEntity, UnlockAchievementParams> {
  final ProfileRepository repository;

  UnlockAchievement(this.repository);

  @override
  Future<Either<Failure, AchievementEntity>> call(
    UnlockAchievementParams params,
  ) async {
    return await repository.unlockAchievement(
      params.userId,
      params.achievementId,
    );
  }
}

/// Parameters untuk UnlockAchievement
class UnlockAchievementParams extends Params {
  final String userId;
  final String achievementId;

  UnlockAchievementParams({
    required this.userId,
    required this.achievementId,
  });

  @override
  List<Object?> get props => [userId, achievementId];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    if (achievementId.isEmpty) {
      return 'Achievement ID cannot be empty';
    }
    return null;
  }
}