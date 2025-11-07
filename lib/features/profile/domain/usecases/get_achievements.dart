/// File: lib/features/profile/domain/usecases/get_achievements.dart
/// UseCase untuk get achievements

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/achievement_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase untuk Get Achievements
class GetAchievements
    implements UseCase<List<AchievementEntity>, GetAchievementsParams> {
  final ProfileRepository repository;

  GetAchievements(this.repository);

  @override
  Future<Either<Failure, List<AchievementEntity>>> call(
    GetAchievementsParams params,
  ) async {
    return await repository.getAchievements(params.userId);
  }
}

/// Parameters untuk GetAchievements
class GetAchievementsParams extends Params {
  final String userId;

  GetAchievementsParams({required this.userId});

  @override
  List<Object?> get props => [userId];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    return null;
  }
}