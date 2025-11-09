/// File: lib/features/iap/domain/repositories/iap_repository.dart
/// Repository interface untuk IAP

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../entities/purchase_entity.dart';

/// Abstract Repository untuk IAP
abstract class IAPRepository {
  /// Initialize IAP
  Future<Either<Failure, void>> initializeIAP();

  /// Get available products
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Purchase product
  Future<Either<Failure, PurchaseEntity>> purchaseProduct(String productId);

  /// Restore purchases
  Future<Either<Failure, List<PurchaseEntity>>> restorePurchases();

  /// Check premium status
  Future<Either<Failure, bool>> checkPremiumStatus(String userId);

  /// Get purchase history
  Future<Either<Failure, List<PurchaseEntity>>> getPurchaseHistory(String userId);

  /// Acknowledge purchase
  Future<Either<Failure, void>> acknowledgePurchase(String purchaseId);
}