/// File: lib/features/profile/domain/usecases/get_user_stats.dart
/// UseCase untuk get user stats

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/stats_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase untuk Get User Stats
class GetUserStats implements UseCase<StatsEntity, GetUserStatsParams> {
  final ProfileRepository repository;

  GetUserStats(this.repository);

  @override
  Future<Either<Failure, StatsEntity>> call(GetUserStatsParams params) async {
    return await repository.getUserStats(params.userId);
  }
}

/// Parameters untuk GetUserStats
class GetUserStatsParams extends Params {
  final String userId;

  GetUserStatsParams({required this.userId});

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