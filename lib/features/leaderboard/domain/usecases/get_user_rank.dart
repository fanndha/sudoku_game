/// File: lib/features/leaderboard/domain/usecases/get_user_rank.dart
/// UseCase untuk get user rank

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/leaderboard_entry_entity.dart';
import '../repositories/leaderboard_repository.dart';

/// UseCase untuk Get User Rank
class GetUserRank
    implements UseCase<LeaderboardEntryEntity?, GetUserRankParams> {
  final LeaderboardRepository repository;

  GetUserRank(this.repository);

  @override
  Future<Either<Failure, LeaderboardEntryEntity?>> call(
    GetUserRankParams params,
  ) async {
    return await repository.getUserRank(
      userId: params.userId,
      difficulty: params.difficulty,
      filter: params.filter,
    );
  }
}

/// Parameters untuk GetUserRank
class GetUserRankParams extends Params {
  final String userId;
  final String difficulty;
  final String filter;

  GetUserRankParams({
    required this.userId,
    required this.difficulty,
    required this.filter,
  });

  @override
  List<Object?> get props => [userId, difficulty, filter];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }

    if (difficulty.isEmpty) {
      return 'Difficulty cannot be empty';
    }

    const validFilters = ['daily', 'weekly', 'all_time'];
    if (!validFilters.contains(filter.toLowerCase())) {
      return 'Invalid filter';
    }

    return null;
  }
}