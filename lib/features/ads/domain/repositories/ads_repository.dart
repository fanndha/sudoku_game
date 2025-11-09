/// File: lib/features/ads/domain/repositories/ads_repository.dart
/// Repository interface untuk ads

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Abstract Repository untuk Ads
abstract class AdsRepository {
  /// Initialize AdMob
  Future<Either<Failure, void>> initializeAds();

  /// Load banner ad
  Future<Either<Failure, void>> loadBannerAd();

  /// Show interstitial ad
  Future<Either<Failure, void>> showInterstitialAd();

  /// Show rewarded ad
  Future<Either<Failure, bool>> showRewardedAd();

  /// Dispose banner ad
  Future<Either<Failure, void>> disposeBannerAd();

  /// Check if ad is loaded
  Future<Either<Failure, bool>> isAdLoaded(String adType);

  /// Check if user is premium (no ads)
  Future<Either<Failure, bool>> isPremiumUser();
}