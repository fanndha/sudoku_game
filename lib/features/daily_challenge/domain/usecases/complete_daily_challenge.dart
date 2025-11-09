/// File: lib/features/daily_challenge/domain/usecases/complete_daily_challenge.dart
/// UseCase untuk complete daily challenge

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/daily_challenge_repository.dart';

/// UseCase untuk Complete Daily Challenge
class CompleteDailyChallenge implements UseCase<void, CompleteChallengeParams> {
  final DailyChallengeRepository repository;

  CompleteDailyChallenge(this.repository);

  @override
  Future<Either<Failure, void>> call(CompleteChallengeParams params) async {
    // Validate params
    final validationError = params.validate();
    if (validationError != null) {
      return Left(ValidationFailure(message: validationError));
    }

    return await repository.completeChallenge(
      challengeId: params.challengeId,
      userId: params.userId,
      timeSpent: params.timeSpent,
      hintsUsed: params.hintsUsed,
      moves: params.moves,
    );
  }
}

/// Parameters untuk Complete Challenge
class CompleteChallengeParams extends Params {
  final String challengeId;
  final String userId;
  final int timeSpent; // in seconds
  final int hintsUsed;
  final int moves;

  CompleteChallengeParams({
    required this.challengeId,
    required this.userId,
    required this.timeSpent,
    required this.hintsUsed,
    required this.moves,
  });

  @override
  List<Object?> get props => [
        challengeId,
        userId,
        timeSpent,
        hintsUsed,
        moves,
      ];

  @override
  String? validate() {
    if (challengeId.isEmpty) {
      return 'Challenge ID cannot be empty';
    }
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    if (timeSpent < 0) {
      return 'Time spent cannot be negative';
    }
    if (hintsUsed < 0) {
      return 'Hints used cannot be negative';
    }
    if (moves < 0) {
      return 'Moves cannot be negative';
    }
    return null;
  }
}