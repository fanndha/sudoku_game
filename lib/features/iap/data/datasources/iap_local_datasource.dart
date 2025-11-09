/// File: lib/features/iap/data/datasources/iap_local_datasource.dart
/// Local data source untuk IAP (Hive)

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/purchase_model.dart';

/// Abstract class untuk IAP Local Data Source
abstract class IAPLocalDataSource {
  /// Cache purchase
  Future<void> cachePurchase(PurchaseModel purchase);

  /// Get cached purchases
  Future<List<PurchaseModel>> getCachedPurchases(String userId);

  /// Check if premium
  Future<bool> isPremiumCached(String userId);

  /// Set premium status
  Future<void> setPremiumStatus(String userId, bool isPremium);

  /// Clear cache
  Future<void> clearCache(String userId);
}

/// Implementation
class IAPLocalDataSourceImpl implements IAPLocalDataSource {
  static const String purchasesBoxName = 'purchases_box';
  static const String premiumBoxName = 'premium_box';

  @override
  Future<void> cachePurchase(PurchaseModel purchase) async {
    try {
      logger.hive('SET', purchasesBoxName, key: purchase.purchaseId);

      final box = await Hive.openBox(purchasesBoxName);
      final userId = purchase.userId;
      
      // Get existing purchases for user
      final existingData = box.get(userId) as List<dynamic>?;
      final purchases = existingData != null
          ? List<Map<String, dynamic>>.from(existingData)
          : <Map<String, dynamic>>[];
      
      // Add new purchase
      purchases.add(purchase.toJson());
      
      await box.put(userId, purchases);
      logger.i('Purchase cached', tag: 'IAPLocal');
    } catch (e) {
      logger.e('Error caching purchase', error: e, tag: 'IAPLocal');
      throw CacheException(message: 'Gagal menyimpan pembelian: ${e.toString()}');
    }
  }

  @override
  Future<List<PurchaseModel>> getCachedPurchases(String userId) async {
    try {
      logger.hive('GET', purchasesBoxName, key: userId);

      final box = await Hive.openBox(purchasesBoxName);
      final data = box.get(userId) as List<dynamic>?;

      if (data == null) {
        logger.d('No cached purchases', tag: 'IAPLocal');
        return [];
      }

      final purchases = List<Map<String, dynamic>>.from(data)
          .map((json) => PurchaseModel.fromJson(json))
          .toList();

      logger.i('Loaded ${purchases.length} cached purchases', tag: 'IAPLocal');
      return purchases;
    } catch (e) {
      logger.e('Error getting cached purchases', error: e, tag: 'IAPLocal');
      throw CacheException(message: 'Gagal memuat data: ${e.toString()}');
    }
  }

  @override
  Future<bool> isPremiumCached(String userId) async {
    try {
      logger.hive('GET', premiumBoxName, key: userId);

      final box = await Hive.openBox(premiumBoxName);
      final isPremium = box.get(userId, defaultValue: false) as bool;

      logger.d('Premium status: $isPremium', tag: 'IAPLocal');
      return isPremium;
    } catch (e) {
      logger.e('Error checking premium status', error: e, tag: 'IAPLocal');
      return false;
    }
  }

  @override
  Future<void> setPremiumStatus(String userId, bool isPremium) async {
    try {
      logger.hive('SET', premiumBoxName, key: userId, value: isPremium);

      final box = await Hive.openBox(premiumBoxName);
      await box.put(userId, isPremium);

      logger.i('Premium status updated: $isPremium', tag: 'IAPLocal');
    } catch (e) {
      logger.e('Error setting premium status', error: e, tag: 'IAPLocal');
      throw CacheException(message: 'Gagal menyimpan status: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    try {
      logger.hive('DELETE', purchasesBoxName, key: userId);
      logger.hive('DELETE', premiumBoxName, key: userId);

      final purchasesBox = await Hive.openBox(purchasesBoxName);
      final premiumBox = await Hive.openBox(premiumBoxName);

      await purchasesBox.delete(userId);
      await premiumBox.delete(userId);

      logger.i('Cache cleared', tag: 'IAPLocal');
    } catch (e) {
      logger.e('Error clearing cache', error: e, tag: 'IAPLocal');
      throw CacheException(message: 'Gagal menghapus data: ${e.toString()}');
    }
  }
}