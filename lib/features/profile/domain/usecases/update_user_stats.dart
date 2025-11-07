/// File: lib/features/profile/domain/usecases/update_user_stats.dart
/// UseCase untuk update user stats

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// UseCase untuk Update User Stats
class UpdateUserStats implements UseCase<void, UpdateUserStatsParams> {
  final ProfileRepository repository;

  UpdateUserStats(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserStatsParams params) async {
    return await repository.updateUserStats(params.userId, params.stats);
  }
}

/// Parameters untuk UpdateUserStats
class UpdateUserStatsParams extends Params {
  final String userId;
  final Map<String, dynamic> stats;

  UpdateUserStatsParams({
    required this.userId,
    required this.stats,
  });

  @override
  List<Object?> get props => [userId, stats];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    if (stats.isEmpty) {
      return 'Stats cannot be empty';
    }
    return null;
  }
}