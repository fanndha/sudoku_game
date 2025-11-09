/// File: lib/features/ads/presentation/bloc/ads_event.dart
/// Events untuk Ads Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize Ads Event
class InitializeAds extends AdsEvent {
  const InitializeAds();
}

/// Load Banner Ad Event
class LoadBannerAd extends AdsEvent {
  const LoadBannerAd();
}

/// Show Interstitial Ad Event
class ShowInterstitialAd extends AdsEvent {
  const ShowInterstitialAd();
}

/// Show Rewarded Ad Event
class ShowRewardedAd extends AdsEvent {
  const ShowRewardedAd();
}

/// Dispose Banner Ad Event
class DisposeBannerAd extends AdsEvent {
  const DisposeBannerAd();
}

/// Check Ad Loaded Event
class CheckAdLoaded extends AdsEvent {
  final String adType;

  const CheckAdLoaded(this.adType);

  @override
  List<Object?> get props => [adType];
}