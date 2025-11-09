/// File: lib/features/iap/data/datasources/iap_datasource.dart
/// Data source untuk IAP (In-App Purchase)

import '../../../../core/constants/iap_constans.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

/// Abstract class untuk IAP Data Source
abstract class IAPDataSource {
  /// Initialize IAP
  Future<void> initializeIAP();

  /// Get available products
  Future<List<ProductModel>> getProducts();

  /// Purchase product
  Future<PurchaseModel> purchaseProduct(String productId, String userId);

  /// Restore purchases
  Future<List<PurchaseModel>> restorePurchases(String userId);

  /// Check if product is purchased
  Future<bool> isProductPurchased(String productId, String userId);
}

/// Implementation
/// NOTE: This is a simplified implementation
/// In production, you should use in_app_purchase package
class IAPDataSourceImpl implements IAPDataSource {
  @override
  Future<void> initializeIAP() async {
    try {
      logger.iapEvent('Initialize', 'IAP');
      
      // TODO: Initialize in_app_purchase package
      // final available = await InAppPurchase.instance.isAvailable();
      // if (!available) throw IAPException(message: 'Store not available');
      
      logger.i('IAP initialized', tag: 'IAPDataSource');
    } catch (e) {
      logger.e('Failed to initialize IAP', error: e, tag: 'IAPDataSource');
      throw IAPException(message: 'Gagal menginisialisasi IAP: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      logger.iapEvent('Get Products', 'all');

      // TODO: Get products from store
      // For now, return mock data based on constants
      final products = <ProductModel>[
        ProductModel(
          id: IAPConstants.premiumPackageId,
          title: IAPConstants.premiumTitle,
          description: IAPConstants.premiumDescription,
          price: IAPConstants.premiumPrice,
          priceValue: IAPConstants.premiumPriceValue,
          currencyCode: 'USD',
          isConsumable: false,
        ),
        ProductModel(
          id: IAPConstants.hintPackId,
          title: IAPConstants.hintPackTitle,
          description: IAPConstants.hintPackDescription,
          price: IAPConstants.hintPackPrice,
          priceValue: IAPConstants.hintPackPriceValue,
          currencyCode: 'USD',
          isConsumable: true,
        ),
      ];

      logger.i('Loaded ${products.length} products', tag: 'IAPDataSource');
      return products;
    } catch (e) {
      logger.e('Failed to get products', error: e, tag: 'IAPDataSource');
      throw IAPException(message: 'Gagal memuat produk: ${e.toString()}');
    }
  }

  @override
  Future<PurchaseModel> purchaseProduct(String productId, String userId) async {
    try {
      logger.iapEvent('Purchase', productId);

      // TODO: Implement actual purchase flow with in_app_purchase
      // For now, create mock purchase
      final purchase = PurchaseModel(
        purchaseId: 'purchase_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        userId: userId,
        purchaseDate: DateTime.now(),
        status: 'purchased',
        isAcknowledged: true,
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      );

      logger.i('Purchase completed: $productId', tag: 'IAPDataSource');
      return purchase;
    } on IAPException catch (e) {
      logger.e('Purchase failed: ${e.message}', tag: 'IAPDataSource');
      rethrow;
    } catch (e) {
      logger.e('Failed to purchase', error: e, tag: 'IAPDataSource');
      
      if (e.toString().contains('user_cancelled')) {
        throw PurchaseCancelledException(
          message: 'Pembelian dibatalkan',
        );
      }
      
      throw IAPException(message: 'Gagal melakukan pembelian: ${e.toString()}');
    }
  }

  @override
  Future<List<PurchaseModel>> restorePurchases(String userId) async {
    try {
      logger.iapEvent('Restore', 'purchases');

      // TODO: Implement actual restore with in_app_purchase
      // For now, return empty list
      final purchases = <PurchaseModel>[];

      logger.i('Restored ${purchases.length} purchases', tag: 'IAPDataSource');
      return purchases;
    } catch (e) {
      logger.e('Failed to restore purchases', error: e, tag: 'IAPDataSource');
      throw IAPException(message: 'Gagal memulihkan pembelian: ${e.toString()}');
    }
  }

  @override
  Future<bool> isProductPurchased(String productId, String userId) async {
    try {
      // TODO: Check from Firebase or local storage
      // For now, return false
      return false;
    } catch (e) {
      logger.e('Failed to check purchase status', error: e, tag: 'IAPDataSource');
      return false;
    }
  }
}