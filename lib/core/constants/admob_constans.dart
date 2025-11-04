/// File: lib/core/constants/admob_constants.dart
/// Konstanta untuk AdMob Ad Units

import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdMobConstants {
  // Prevent instantiation
  AdMobConstants._();

  // ========== TEST AD UNIT IDs (untuk development) ==========
  // Android Test IDs
  static const String testBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  
  // iOS Test IDs (untuk future implementation)
  static const String testBannerIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String testInterstitialIdIOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String testRewardedIdIOS = 'ca-app-pub-3940256099942544/1712485313';

  // ========== PRODUCTION AD UNIT IDs ==========
  // Get from .env file
  static String get _prodAppId => dotenv.get('ADMOB_APP_ID_ANDROID', fallback: '');
  static String get _prodBannerId => dotenv.get('ADMOB_BANNER_ID_ANDROID', fallback: '');
  static String get _prodInterstitialId => dotenv.get('ADMOB_INTERSTITIAL_ID_ANDROID', fallback: '');
  static String get _prodRewardedId => dotenv.get('ADMOB_REWARDED_ID_ANDROID', fallback: '');
  
  // Check if using test ads
  static bool get _useTestAds {
    final useTest = dotenv.get('USE_TEST_ADS', fallback: 'true');
    return useTest.toLowerCase() == 'true';
  }

  // ========== APP ID ==========
  /// Get AdMob App ID berdasarkan platform dan mode (test/production)
  static String get appId {
    if (_useTestAds) {
      return Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544~3347511713' // Android Test App ID
          : 'ca-app-pub-3940256099942544~1458002511'; // iOS Test App ID
    }
    return _prodAppId;
  }

  // ========== BANNER AD ID ==========
  /// Get Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid ? testBannerIdAndroid : testBannerIdIOS;
    }
    return Platform.isAndroid ? _prodBannerId : '';
  }

  // ========== INTERSTITIAL AD ID ==========
  /// Get Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid ? testInterstitialIdAndroid : testInterstitialIdIOS;
    }
    return Platform.isAndroid ? _prodInterstitialId : '';
  }

  // ========== REWARDED AD ID ==========
  /// Get Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid ? testRewardedIdAndroid : testRewardedIdIOS;
    }
    return Platform.isAndroid ? _prodRewardedId : '';
  }

  // ========== AD CONFIGURATION ==========
  /// Maximum retry attempts untuk load ad
  static const int maxAdLoadRetries = 3;
  
  /// Delay antara retry (dalam seconds)
  static const int retryDelaySeconds = 5;
  
  /// Minimum interval antara interstitial ads (dalam seconds)
  static const int minInterstitialIntervalSeconds = 60;
  
  /// Free hints per game
  static const int freeHintsPerGame = 3;
  
  /// Hint reward dari rewarded ad
  static const int hintsPerRewardedAd = 1;
  
  /// Cooldown untuk rewarded ad (dalam seconds)
  static const int rewardedAdCooldownSeconds = 30;

  // ========== AD KEYWORDS ==========
  /// Keywords untuk targeting (optional)
  static const List<String> adKeywords = [
    'games',
    'puzzle',
    'sudoku',
    'brain games',
    'logic games',
    'casual games',
  ];

  // ========== HELPER METHODS ==========
  
  /// Check apakah menggunakan test ads
  static bool isUsingTestAds() {
    return _useTestAds;
  }
  
  /// Get ad unit ID by type
  static String getAdUnitId(AdType adType) {
    switch (adType) {
      case AdType.banner:
        return bannerAdUnitId;
      case AdType.interstitial:
        return interstitialAdUnitId;
      case AdType.rewarded:
        return rewardedAdUnitId;
    }
  }
  
  /// Validate ad unit ID
  static bool isValidAdUnitId(String adUnitId) {
    return adUnitId.isNotEmpty && adUnitId.startsWith('ca-app-pub-');
  }
  
  /// Get ad request with keywords
  static Map<String, dynamic> getAdRequestExtras() {
    return {
      'keywords': adKeywords,
      'npa': '0', // Non-Personalized Ads (0 = allow personalized)
    };
  }
}

/// Enum untuk tipe Ad
enum AdType {
  banner,
  interstitial,
  rewarded,
}