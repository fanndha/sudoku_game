/// File: lib/features/ads/presentation/bloc/ads_state.dart
/// States untuk Ads Bloc

import 'package:equatable/equatable.dart';

/// Base State
abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class AdsInitial extends AdsState {
  const AdsInitial();
}

/// Ads Initializing State
class AdsInitializing extends AdsState {
  const AdsInitializing();
}

/// Ads Initialized State
class AdsInitialized extends AdsState {
  const AdsInitialized();
}

/// Banner Ad Loading State
class BannerAdLoading extends AdsState {
  const BannerAdLoading();
}

/// Banner Ad Loaded State
class BannerAdLoaded extends AdsState {
  const BannerAdLoaded();
}

/// Interstitial Ad Loading State
class InterstitialAdLoading extends AdsState {
  const InterstitialAdLoading();
}

/// Interstitial Ad Shown State
class InterstitialAdShown extends AdsState {
  const InterstitialAdShown();
}

/// Rewarded Ad Loading State
class RewardedAdLoading extends AdsState {
  const RewardedAdLoading();
}

/// Rewarded Ad Shown State
class RewardedAdShown extends AdsState {
  final bool rewardEarned;

  const RewardedAdShown({required this.rewardEarned});

  @override
  List<Object?> get props => [rewardEarned];
}

/// Ad Error State
class AdError extends AdsState {
  final String message;
  final String? adType;

  const AdError({
    required this.message,
    this.adType,
  });

  @override
  List<Object?> get props => [message, adType];
}

/// Ad Not Available State
class AdNotAvailable extends AdsState {
  final String message;
  final String adType;

  const AdNotAvailable({
    required this.message,
    required this.adType,
  });

  @override
  List<Object?> get props => [message, adType];
}

/// Banner Ad Disposed State
class BannerAdDisposed extends AdsState {
  const BannerAdDisposed();
}