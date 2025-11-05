/// File: lib/features/leaderboard/domain/usecases/update_leaderboard.dart
/// UseCase untuk update leaderboard

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/leaderboard_repository.dart';

/// UseCase untuk Update Leaderboard
class UpdateLeaderboard implements UseCase<void, UpdateLeaderboardParams> {
  final LeaderboardRepository repository;

  UpdateLeaderboard(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateLeaderboardParams params) async {
    return await repository.updateLeaderboard(
      userId: params.userId,
      difficulty: params.difficulty,
      bestTime: params.bestTime,
      totalSolved: params.totalSolved,
    );
  }
}

/// Parameters untuk UpdateLeaderboard
class UpdateLeaderboardParams extends Params {
  final String userId;
  final String difficulty;
  final int bestTime;
  final int totalSolved;

  UpdateLeaderboardParams({
    required this.userId,
    required this.difficulty,
    required this.bestTime,
    required this.totalSolved,
  });

  @override
  List<Object?> get props => [userId, difficulty, bestTime, totalSolved];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }

    if (difficulty.isEmpty) {
      return 'Difficulty cannot be empty';
    }

    if (bestTime <= 0) {
      return 'Best time must be greater than 0';
    }

    if (totalSolved < 0) {
      return 'Total solved cannot be negative';
    }

    return null;
  }
}