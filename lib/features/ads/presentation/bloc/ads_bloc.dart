/// File: lib/features/ads/presentation/bloc/ads_bloc.dart
/// BLoC untuk Ads

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/initialize_ads.dart' as usecase;
import '../../domain/usecases/load_banner_ad.dart' as usecase;
import '../../domain/usecases/show_inerstitial_ad.dart' as usecase;
import '../../domain/usecases/show_rewarded_ad.dart' as usecase;
import 'ads_event.dart' as event;
import 'ads_state.dart';

/// Ads Bloc
class AdsBloc extends Bloc<event.AdsEvent, AdsState> {
  final usecase.InitializeAds initializeAds;
  final usecase.LoadBannerAd loadBannerAd;
  final usecase.ShowInterstitialAd showInterstitialAd;
  final usecase.ShowRewardedAd showRewardedAd;

  AdsBloc({
    required this.initializeAds,
    required this.loadBannerAd,
    required this.showInterstitialAd,
    required this.showRewardedAd,
  }) : super(const AdsInitial()) {
    on<event.InitializeAds>(_onInitializeAds);
    on<event.LoadBannerAd>(_onLoadBannerAd);
    on<event.ShowInterstitialAd>(_onShowInterstitialAd);
    on<event.ShowRewardedAd>(_onShowRewardedAd);
    on<event.DisposeBannerAd>(_onDisposeBannerAd);
  }

  /// Initialize Ads
  Future<void> _onInitializeAds(
    event.InitializeAds event,
    Emitter<AdsState> emit,
  ) async {
    logger.blocEvent('AdsBloc', event);
    emit(const AdsInitializing());

    final result = await initializeAds();

    result.fold(
      (failure) {
        logger.e('Failed to initialize ads: ${failure.message}', tag: 'AdsBloc');
        emit(AdError(
          message: _mapFailureToMessage(failure),
          adType: 'initialization',
        ));
      },
      (_) {
        logger.i('Ads initialized', tag: 'AdsBloc');
        emit(const AdsInitialized());
      },
    );
  }

  /// Load Banner Ad
  Future<void> _onLoadBannerAd(
    event.LoadBannerAd event,
    Emitter<AdsState> emit,
  ) async {
    logger.blocEvent('AdsBloc', event);
    emit(const BannerAdLoading());

    final result = await loadBannerAd();

    result.fold(
      (failure) {
        logger.e('Failed to load banner ad: ${failure.message}', tag: 'AdsBloc');
        emit(AdError(
          message: _mapFailureToMessage(failure),
          adType: 'banner',
        ));
      },
      (_) {
        logger.i('Banner ad loaded', tag: 'AdsBloc');
        emit(const BannerAdLoaded());
      },
    );
  }

  /// Show Interstitial Ad
  Future<void> _onShowInterstitialAd(
    event.ShowInterstitialAd event,
    Emitter<AdsState> emit,
  ) async {
    logger.blocEvent('AdsBloc', event);
    emit(const InterstitialAdLoading());

    final result = await showInterstitialAd();

    result.fold(
      (failure) {
        logger.e('Failed to show interstitial ad: ${failure.message}', tag: 'AdsBloc');

        if (failure is AdNotAvailableFailure) {
          emit(AdNotAvailable(
            message: failure.message,
            adType: 'interstitial',
          ));
        } else {
          emit(AdError(
            message: _mapFailureToMessage(failure),
            adType: 'interstitial',
          ));
        }
      },
      (_) {
        logger.i('Interstitial ad shown', tag: 'AdsBloc');
        emit(const InterstitialAdShown());
      },
    );
  }

  /// Show Rewarded Ad
  Future<void> _onShowRewardedAd(
    event.ShowRewardedAd event,
    Emitter<AdsState> emit,
  ) async {
    logger.blocEvent('AdsBloc', event);
    emit(const RewardedAdLoading());

    final result = await showRewardedAd();

    result.fold(
      (failure) {
        logger.e('Failed to show rewarded ad: ${failure.message}', tag: 'AdsBloc');

        if (failure is AdNotAvailableFailure) {
          emit(AdNotAvailable(
            message: failure.message,
            adType: 'rewarded',
          ));
        } else {
          emit(AdError(
            message: _mapFailureToMessage(failure),
            adType: 'rewarded',
          ));
        }
      },
      (rewardEarned) {
        logger.i('Rewarded ad shown, earned: $rewardEarned', tag: 'AdsBloc');
        emit(RewardedAdShown(rewardEarned: rewardEarned));
      },
    );
  }

  /// Dispose Banner Ad
  Future<void> _onDisposeBannerAd(
    event.DisposeBannerAd event,
    Emitter<AdsState> emit,
  ) async {
    logger.blocEvent('AdsBloc', event);
    // Dispose logic would be handled by repository
    emit(const BannerAdDisposed());
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is AdNotAvailableFailure) {
      return 'Iklan tidak tersedia saat ini';
    } else if (failure is AdFailedToLoadFailure) {
      return 'Gagal memuat iklan';
    } else if (failure is AdFailedToShowFailure) {
      return 'Gagal menampilkan iklan';
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}
