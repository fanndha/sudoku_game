/// File: lib/features/daily_challenge/domain/usecases/get_daily_challenge.dart
/// UseCase untuk get today's daily challenge

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/daily_challenge_entity.dart';
import '../repositories/daily_challenge_repository.dart';

/// UseCase untuk Get Today's Daily Challenge
class GetDailyChallenge implements UseCaseNoParams<DailyChallengeEntity> {
  final DailyChallengeRepository repository;

  GetDailyChallenge(this.repository);

  @override
  Future<Either<Failure, DailyChallengeEntity>> call() async {
    return await repository.getTodayChallenge();
  }
}