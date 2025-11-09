/// File: lib/features/ads/domain/usecases/show_rewarded_ad.dart
/// UseCase untuk show rewarded ad

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

/// UseCase untuk Show Rewarded Ad
/// Returns true if user watched the ad and received reward
class ShowRewardedAd implements UseCaseNoParams<bool> {
  final AdsRepository repository;

  ShowRewardedAd(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.showRewardedAd();
  }
}