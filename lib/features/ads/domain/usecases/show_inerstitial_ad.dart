/// File: lib/features/ads/domain/usecases/show_interstitial_ad.dart
/// UseCase untuk show interstitial ad

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

/// UseCase untuk Show Interstitial Ad
class ShowInterstitialAd implements UseCaseNoParams<void> {
  final AdsRepository repository;

  ShowInterstitialAd(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.showInterstitialAd();
  }
}