/// File: lib/features/ads/data/datasources/ads_datasource.dart
/// Data source untuk AdMob ads

import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../core/constants/admob_constans.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';

/// Abstract class untuk Ads Data Source
abstract class AdsDataSource {
  /// Initialize AdMob
  Future<void> initializeAds();

  /// Load banner ad
  Future<BannerAd?> loadBannerAd();

  /// Load interstitial ad
  Future<void> loadInterstitialAd();

  /// Show interstitial ad
  Future<void> showInterstitialAd();

  /// Load rewarded ad
  Future<void> loadRewardedAd();

  /// Show rewarded ad
  Future<bool> showRewardedAd();

  /// Dispose banner ad
  void disposeBannerAd();

  /// Check if ad is loaded
  bool isAdLoaded(String adType);
}

/// Implementation
class AdsDataSourceImpl implements AdsDataSource {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;
  bool _isRewardedLoaded = false;

  @override
  Future<void> initializeAds() async {
    try {
      logger.adEvent('AdMob', 'Initialize');
      await MobileAds.instance.initialize();
      logger.i('AdMob initialized', tag: 'AdsDataSource');
    } catch (e) {
      logger.e('Failed to initialize AdMob', error: e, tag: 'AdsDataSource');
      throw AdException(message: 'Gagal menginisialisasi ads: ${e.toString()}');
    }
  }

  @override
  Future<BannerAd?> loadBannerAd() async {
    try {
      logger.adEvent('Banner', 'Load');

      _bannerAd = BannerAd(
        adUnitId: AdMobConstants.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            logger.adEvent('Banner', 'Loaded');
            _isBannerLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            logger.adEvent('Banner', 'Failed', message: error.message);
            _isBannerLoaded = false;
            ad.dispose();
          },
        ),
      );

      await _bannerAd!.load();
      return _bannerAd;
    } catch (e) {
      logger.e('Failed to load banner ad', error: e, tag: 'AdsDataSource');
      throw AdFailedToLoadException(
        message: 'Gagal memuat banner ad: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> loadInterstitialAd() async {
    try {
      logger.adEvent('Interstitial', 'Load');

      await InterstitialAd.load(
        adUnitId: AdMobConstants.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            logger.adEvent('Interstitial', 'Loaded');
            _interstitialAd = ad;
            _isInterstitialLoaded = true;
            
            // Set full screen content callback
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                logger.adEvent('Interstitial', 'Dismissed');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialLoaded = false;
                // Preload next ad
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                logger.adEvent('Interstitial', 'Failed to show', message: error.message);
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialLoaded = false;
              },
            );
          },
          onAdFailedToLoad: (error) {
            logger.adEvent('Interstitial', 'Failed to load', message: error.message);
            _isInterstitialLoaded = false;
          },
        ),
      );
    } catch (e) {
      logger.e('Failed to load interstitial ad', error: e, tag: 'AdsDataSource');
      throw AdFailedToLoadException(
        message: 'Gagal memuat interstitial ad: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> showInterstitialAd() async {
    try {
      if (_interstitialAd == null || !_isInterstitialLoaded) {
        logger.w('Interstitial ad not ready', tag: 'AdsDataSource');
        throw AdNotAvailableException(message: 'Iklan belum siap');
      }

      logger.adEvent('Interstitial', 'Show');
      await _interstitialAd!.show();
    } catch (e) {
      logger.e('Failed to show interstitial ad', error: e, tag: 'AdsDataSource');
      if (e is AdNotAvailableException) rethrow;
      throw AdFailedToShowException(
        message: 'Gagal menampilkan iklan: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> loadRewardedAd() async {
    try {
      logger.adEvent('Rewarded', 'Load');

      await RewardedAd.load(
        adUnitId: AdMobConstants.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            logger.adEvent('Rewarded', 'Loaded');
            _rewardedAd = ad;
            _isRewardedLoaded = true;
          },
          onAdFailedToLoad: (error) {
            logger.adEvent('Rewarded', 'Failed to load', message: error.message);
            _isRewardedLoaded = false;
          },
        ),
      );
    } catch (e) {
      logger.e('Failed to load rewarded ad', error: e, tag: 'AdsDataSource');
      throw AdFailedToLoadException(
        message: 'Gagal memuat rewarded ad: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> showRewardedAd() async {
    try {
      if (_rewardedAd == null || !_isRewardedLoaded) {
        logger.w('Rewarded ad not ready', tag: 'AdsDataSource');
        throw AdNotAvailableException(message: 'Iklan belum siap');
      }

      logger.adEvent('Rewarded', 'Show');
      
      bool rewardEarned = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          logger.adEvent('Rewarded', 'Dismissed');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedLoaded = false;
          // Preload next ad
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          logger.adEvent('Rewarded', 'Failed to show', message: error.message);
          ad.dispose();
          _rewardedAd = null;
          _isRewardedLoaded = false;
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          logger.adEvent('Rewarded', 'Earned', message: 'Amount: ${reward.amount}');
          rewardEarned = true;
        },
      );

      return rewardEarned;
    } catch (e) {
      logger.e('Failed to show rewarded ad', error: e, tag: 'AdsDataSource');
      if (e is AdNotAvailableException) rethrow;
      throw AdFailedToShowException(
        message: 'Gagal menampilkan iklan: ${e.toString()}',
      );
    }
  }

  @override
  void disposeBannerAd() {
    logger.adEvent('Banner', 'Dispose');
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerLoaded = false;
  }

  @override
  bool isAdLoaded(String adType) {
    switch (adType.toLowerCase()) {
      case 'banner':
        return _isBannerLoaded;
      case 'interstitial':
        return _isInterstitialLoaded;
      case 'rewarded':
        return _isRewardedLoaded;
      default:
        return false;
    }
  }
}