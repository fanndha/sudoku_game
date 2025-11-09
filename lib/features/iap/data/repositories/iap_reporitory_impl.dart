/// File: lib/features/iap/data/repositories/iap_repository_impl.dart
/// Implementation dari IAPRepository

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/purchase_entity.dart';
import '../../domain/repositories/iap_repository.dart';
import '../datasources/iap_datasource.dart';
import '../datasources/iap_local_datasource.dart';

/// Implementation dari IAPRepository
class IAPRepositoryImpl implements IAPRepository {
  final IAPDataSource dataSource;
  final IAPLocalDataSource localDataSource;

  IAPRepositoryImpl({
    required this.dataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> initializeIAP() async {
    try {
      logger.i('Initializing IAP', tag: 'IAPRepository');
      await dataSource.initializeIAP();
      logger.i('IAP initialized', tag: 'IAPRepository');
      return const Right(null);
    } on IAPException catch (e) {
      logger.e('IAP exception: ${e.message}', tag: 'IAPRepository');
      return Left(IAPFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error initializing IAP', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal menginisialisasi IAP: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      logger.i('Getting products', tag: 'IAPRepository');
      final products = await dataSource.getProducts();
      logger.i('Loaded ${products.length} products', tag: 'IAPRepository');
      return Right(products);
    } on IAPException catch (e) {
      logger.e('IAP exception: ${e.message}', tag: 'IAPRepository');
      return Left(IAPFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error getting products', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal memuat produk: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, PurchaseEntity>> purchaseProduct(
    String productId,
  ) async {
    try {
      logger.i('Purchasing product: $productId', tag: 'IAPRepository');
      
      // TODO: Get userId from auth
      const userId = 'temp_user_id';
      
      final purchase = await dataSource.purchaseProduct(productId, userId);
      
      // Cache purchase
      await localDataSource.cachePurchase(purchase);
      
      // Update premium status if premium package
      if (productId.contains('premium')) {
        await localDataSource.setPremiumStatus(userId, true);
      }
      
      logger.i('Purchase completed: $productId', tag: 'IAPRepository');
      return Right(purchase);
    } on PurchaseCancelledException catch (e) {
      logger.w('Purchase cancelled: ${e.message}', tag: 'IAPRepository');
      return Left(PurchaseCancelledFailure(message: e.message));
    } on IAPException catch (e) {
      logger.e('IAP exception: ${e.message}', tag: 'IAPRepository');
      return Left(IAPFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error purchasing', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal melakukan pembelian: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseEntity>>> restorePurchases() async {
    try {
      logger.i('Restoring purchases', tag: 'IAPRepository');
      
      // TODO: Get userId from auth
      const userId = 'temp_user_id';
      
      final purchases = await dataSource.restorePurchases(userId);
      
      // Cache restored purchases
      for (final purchase in purchases) {
        await localDataSource.cachePurchase(purchase);
        
        // Update premium status if premium package
        if (purchase.productId.contains('premium') && purchase.isSuccessful) {
          await localDataSource.setPremiumStatus(userId, true);
        }
      }
      
      logger.i('Restored ${purchases.length} purchases', tag: 'IAPRepository');
      return Right(purchases);
    } on IAPException catch (e) {
      logger.e('IAP exception: ${e.message}', tag: 'IAPRepository');
      return Left(IAPFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error restoring purchases', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal memulihkan pembelian: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPremiumStatus(String userId) async {
    try {
      logger.i('Checking premium status', tag: 'IAPRepository');
      
      // Check from cache first
      final isPremium = await localDataSource.isPremiumCached(userId);
      
      logger.i('Premium status: $isPremium', tag: 'IAPRepository');
      return Right(isPremium);
    } catch (e) {
      logger.e('Error checking premium status', error: e, tag: 'IAPRepository');
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, List<PurchaseEntity>>> getPurchaseHistory(
    String userId,
  ) async {
    try {
      logger.i('Getting purchase history', tag: 'IAPRepository');
      
      final purchases = await localDataSource.getCachedPurchases(userId);
      
      logger.i('Loaded ${purchases.length} purchases', tag: 'IAPRepository');
      return Right(purchases);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'IAPRepository');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Unknown error getting history', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal memuat riwayat: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> acknowledgePurchase(String purchaseId) async {
    try {
      logger.i('Acknowledging purchase: $purchaseId', tag: 'IAPRepository');
      
      // TODO: Implement acknowledge with in_app_purchase
      
      logger.i('Purchase acknowledged', tag: 'IAPRepository');
      return const Right(null);
    } catch (e) {
      logger.e('Error acknowledging purchase', error: e, tag: 'IAPRepository');
      return Left(UnknownFailure(
        message: 'Gagal acknowledge: ${e.toString()}',
      ));
    }
  }
}