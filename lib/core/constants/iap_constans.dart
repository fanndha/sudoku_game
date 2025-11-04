/// File: lib/core/constants/iap_constants.dart
/// Konstanta untuk In-App Purchase Products

import 'package:flutter_dotenv/flutter_dotenv.dart';

class IAPConstants {
  // Prevent instantiation
  IAPConstants._();

  // ========== PRODUCT IDs ==========
  /// Premium Package Product ID
  static String get premiumPackageId {
    return dotenv.get('IAP_PREMIUM_PACKAGE', fallback: 'premium_package');
  }

  /// Hint Pack Product ID
  static String get hintPackId {
    return dotenv.get('IAP_HINT_PACK', fallback: 'hint_pack_20');
  }

  // ========== PRODUCT DETAILS ==========
  /// Premium Package Details
  static const String premiumTitle = 'Premium Package';
  static const String premiumDescription = 
      'Unlimited hints, remove all ads, exclusive themes, and priority support';
  static const String premiumPrice = '\$2.99';
  static const double premiumPriceValue = 2.99;

  /// Hint Pack Details
  static const String hintPackTitle = '20 Hints Pack';
  static const String hintPackDescription = 
      'Get 20 hints without watching ads';
  static const String hintPackPrice = '\$0.99';
  static const double hintPackPriceValue = 0.99;

  // ========== PREMIUM FEATURES ==========
  /// List of premium features
  static const List<String> premiumFeatures = [
    'Unlimited Hints',
    'No Banner Ads',
    'No Interstitial Ads',
    'Exclusive Themes',
    'Priority Badge',
    'Cloud Backup',
    'Advanced Statistics',
    'Custom Board Colors',
  ];

  // ========== HINT PACK CONFIGURATION ==========
  /// Jumlah hints dalam hint pack
  static const int hintsPerPack = 20;
  
  /// Maximum hints yang bisa disimpan
  static const int maxStoredHints = 100;

  // ========== CONSUMABLE vs NON-CONSUMABLE ==========
  /// Premium adalah non-consumable (one-time purchase)
  static const bool isPremiumConsumable = false;
  
  /// Hint pack adalah consumable (bisa dibeli berkali-kali)
  static const bool isHintPackConsumable = true;

  // ========== PRODUCT TYPES ==========
  static const String productTypeConsumable = 'consumable';
  static const String productTypeNonConsumable = 'non_consumable';
  static const String productTypeSubscription = 'subscription';

  // ========== PURCHASE STATUS ==========
  static const String purchaseStatusPending = 'pending';
  static const String purchaseStatusPurchased = 'purchased';
  static const String purchaseStatusRestored = 'restored';
  static const String purchaseStatusCanceled = 'canceled';
  static const String purchaseStatusError = 'error';

  // ========== STORE CONFIGURATION ==========
  /// Google Play Store
  static const String storeAndroid = 'google_play';
  
  /// App Store (future implementation)
  static const String storeIOS = 'app_store';

  // ========== PURCHASE VALIDATION ==========
  /// Enable server-side verification (recommended for production)
  static const bool enableServerVerification = false; // Set true jika ada backend
  
  /// Server endpoint untuk verification (jika ada)
  static const String verificationEndpoint = '/api/verify-purchase';

  // ========== HELPER METHODS ==========
  
  /// Get all product IDs as list
  static List<String> getAllProductIds() {
    return [
      premiumPackageId,
      hintPackId,
    ];
  }

  /// Check if product ID is valid
  static bool isValidProductId(String productId) {
    return getAllProductIds().contains(productId);
  }

  /// Check if product is premium package
  static bool isPremiumPackage(String productId) {
    return productId == premiumPackageId;
  }

  /// Check if product is hint pack
  static bool isHintPack(String productId) {
    return productId == hintPackId;
  }

  /// Get product type
  static String getProductType(String productId) {
    if (isPremiumPackage(productId)) {
      return productTypeNonConsumable;
    } else if (isHintPack(productId)) {
      return productTypeConsumable;
    }
    return productTypeConsumable;
  }

  /// Get product title
  static String getProductTitle(String productId) {
    if (isPremiumPackage(productId)) {
      return premiumTitle;
    } else if (isHintPack(productId)) {
      return hintPackTitle;
    }
    return 'Unknown Product';
  }

  /// Get product description
  static String getProductDescription(String productId) {
    if (isPremiumPackage(productId)) {
      return premiumDescription;
    } else if (isHintPack(productId)) {
      return hintPackDescription;
    }
    return 'No description available';
  }

  /// Get product price
  static String getProductPrice(String productId) {
    if (isPremiumPackage(productId)) {
      return premiumPrice;
    } else if (isHintPack(productId)) {
      return hintPackPrice;
    }
    return '\$0.00';
  }

  /// Get product price value
  static double getProductPriceValue(String productId) {
    if (isPremiumPackage(productId)) {
      return premiumPriceValue;
    } else if (isHintPack(productId)) {
      return hintPackPriceValue;
    }
    return 0.0;
  }

  /// Check if user should get hints from purchase
  static bool shouldAddHints(String productId) {
    return isHintPack(productId);
  }

  /// Get hints amount from purchase
  static int getHintsAmount(String productId) {
    if (isHintPack(productId)) {
      return hintsPerPack;
    }
    return 0;
  }

  /// Validate hints amount
  static bool canAddHints(int currentHints, int hintsToAdd) {
    return (currentHints + hintsToAdd) <= maxStoredHints;
  }
}

/// Enum untuk Purchase Result
enum PurchaseResult {
  success,
  canceled,
  error,
  pending,
  alreadyOwned,
  notAvailable,
}

/// Enum untuk Product Type
enum ProductType {
  premium,
  hintPack,
  unknown,
}

/// Extension untuk ProductType
extension ProductTypeExtension on ProductType {
  String get productId {
    switch (this) {
      case ProductType.premium:
        return IAPConstants.premiumPackageId;
      case ProductType.hintPack:
        return IAPConstants.hintPackId;
      case ProductType.unknown:
        return '';
    }
  }

  String get title {
    switch (this) {
      case ProductType.premium:
        return IAPConstants.premiumTitle;
      case ProductType.hintPack:
        return IAPConstants.hintPackTitle;
      case ProductType.unknown:
        return 'Unknown';
    }
  }

  bool get isConsumable {
    switch (this) {
      case ProductType.premium:
        return false;
      case ProductType.hintPack:
        return true;
      case ProductType.unknown:
        return false;
    }
  }
}