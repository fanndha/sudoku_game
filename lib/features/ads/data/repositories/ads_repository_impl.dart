/// File: lib/features/ads/data/repositories/ads_repository_impl.dart
/// Implementation dari AdsRepository

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_datasource.dart';

/// Implementation dari AdsRepository
class AdsRepositoryImpl implements AdsRepository {
  final AdsDataSource dataSource;

  AdsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> initializeAds() async {
    try {
      logger.i('Initializing ads', tag: 'AdsRepository');
      await dataSource.initializeAds();
      logger.i('Ads initialized', tag: 'AdsRepository');
      return const Right(null);
    } on AdException catch (e) {
      logger.e('Ad exception: ${e.message}', tag: 'AdsRepository');
      return Left(AdFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error initializing ads',
        error: e,
        tag: 'AdsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal menginisialisasi ads: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> loadBannerAd() async {
    try {
      logger.i('Loading banner ad', tag: 'AdsRepository');
      await dataSource.loadBannerAd();
      logger.i('Banner ad loaded', tag: 'AdsRepository');
      return const Right(null);
    } on AdFailedToLoadException catch (e) {
      logger.e('Failed to load banner ad: ${e.message}', tag: 'AdsRepository');
      return Left(AdFailedToLoadFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error loading banner ad',
        error: e,
        tag: 'AdsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal memuat banner ad: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> showInterstitialAd() async {
    try {
      logger.i('Showing interstitial ad', tag: 'AdsRepository');

      // Check if user is premium
      final isPremium = await isPremiumUser();
      if (isPremium.isRight() && isPremium.getOrElse(() => false)) {
        logger.i('User is premium, skipping ad', tag: 'AdsRepository');
        return const Right(null);
      }

      // Load ad if not loaded
      if (!dataSource.isAdLoaded('interstitial')) {
        logger.i('Loading interstitial ad first', tag: 'AdsRepository');
        await dataSource.loadInterstitialAd();
        // Wait a bit for ad to load
        await Future.delayed(const Duration(seconds: 1));
      }

      await dataSource.showInterstitialAd();
      logger.i('Interstitial ad shown', tag: 'AdsRepository');
      return const Right(null);
    } on AdNotAvailableException catch (e) {
      logger.w('Ad not available: ${e.message}', tag: 'AdsRepository');
      return Left(AdNotAvailableFailure(message: e.message));
    } on AdFailedToShowException catch (e) {
      logger.e('Failed to show ad: ${e.message}', tag: 'AdsRepository');
      return Left(AdFailedToShowFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error showing interstitial ad',
        error: e,
        tag: 'AdsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal menampilkan iklan: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> showRewardedAd() async {
    try {
      logger.i('Showing rewarded ad', tag: 'AdsRepository');

      // Load ad if not loaded
      if (!dataSource.isAdLoaded('rewarded')) {
        logger.i('Loading rewarded ad first', tag: 'AdsRepository');
        await dataSource.loadRewardedAd();
        // Wait a bit for ad to load
        await Future.delayed(const Duration(seconds: 1));
      }

      final rewardEarned = await dataSource.showRewardedAd();
      logger.i(
        'Rewarded ad shown, reward earned: $rewardEarned',
        tag: 'AdsRepository',
      );
      return Right(rewardEarned);
    } on AdNotAvailableException catch (e) {
      logger.w('Ad not available: ${e.message}', tag: 'AdsRepository');
      return Left(AdNotAvailableFailure(message: e.message));
    } on AdFailedToShowException catch (e) {
      logger.e('Failed to show ad: ${e.message}', tag: 'AdsRepository');
      return Left(AdFailedToShowFailure(message: e.message));
    } catch (e) {
      logger.e(
        'Unknown error showing rewarded ad',
        error: e,
        tag: 'AdsRepository',
      );
      return Left(
        UnknownFailure(message: 'Gagal menampilkan iklan: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disposeBannerAd() async {
    try {
      logger.i('Disposing banner ad', tag: 'AdsRepository');
      dataSource.disposeBannerAd();
      return const Right(null);
    } catch (e) {
      logger.e('Error disposing banner ad', error: e, tag: 'AdsRepository');
      return Left(
        UnknownFailure(message: 'Gagal dispose banner ad: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isAdLoaded(String adType) async {
    try {
      final isLoaded = dataSource.isAdLoaded(adType);
      return Right(isLoaded);
    } catch (e) {
      logger.e('Error checking ad loaded', error: e, tag: 'AdsRepository');
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, bool>> isPremiumUser() async {
    try {
      // TODO: Implement premium user check from IAP or Firebase
      // For now, return false
      return const Right(false);
    } catch (e) {
      logger.e('Error checking premium user', error: e, tag: 'AdsRepository');
      return const Right(false);
    }
  }
}
