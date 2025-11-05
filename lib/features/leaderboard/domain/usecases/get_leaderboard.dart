/// File: lib/features/leaderboard/domain/usecases/get_leaderboard.dart
/// UseCase untuk get leaderboard

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/leaderboard_entry_entity.dart';
import '../repositories/leaderboard_repository.dart';

/// UseCase untuk Get Leaderboard
class GetLeaderboard
    implements UseCase<List<LeaderboardEntryEntity>, GetLeaderboardParams> {
  final LeaderboardRepository repository;

  GetLeaderboard(this.repository);

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> call(
    GetLeaderboardParams params,
  ) async {
    return await repository.getLeaderboard(
      difficulty: params.difficulty,
      filter: params.filter,
      limit: params.limit,
    );
  }
}

/// Parameters untuk GetLeaderboard
class GetLeaderboardParams extends Params {
  final String difficulty;
  final String filter; // 'daily', 'weekly', 'all_time'
  final int limit;

  GetLeaderboardParams({
    required this.difficulty,
    required this.filter,
    this.limit = 100,
  });

  @override
  List<Object?> get props => [difficulty, filter, limit];

  @override
  String? validate() {
    if (difficulty.isEmpty) {
      return 'Difficulty cannot be empty';
    }

    const validDifficulties = ['easy', 'medium', 'hard', 'expert'];
    if (!validDifficulties.contains(difficulty.toLowerCase())) {
      return 'Invalid difficulty';
    }

    const validFilters = ['daily', 'weekly', 'all_time'];
    if (!validFilters.contains(filter.toLowerCase())) {
      return 'Invalid filter. Must be: daily, weekly, or all_time';
    }

    if (limit <= 0 || limit > 1000) {
      return 'Limit must be between 1 and 1000';
    }

    return null;
  }
}