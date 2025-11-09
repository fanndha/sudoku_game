/// File: lib/features/iap/presentation/bloc/iap_bloc.dart
/// BLoC untuk IAP

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/check_premium_status.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/purchase_premium.dart';
import '../../domain/usecases/restore_purchases.dart';
import 'iap_event.dart' as event;
import 'iap_state.dart';

/// IAP Bloc
class IAPBloc extends Bloc<event.IAPEvent, IAPState> {
  final GetProducts getProducts;
  final PurchasePremium purchasePremium;
  final RestorePurchases restorePurchases;
  final CheckPremiumStatus checkPremiumStatus;

  IAPBloc({
    required this.getProducts,
    required this.purchasePremium,
    required this.restorePurchases,
    required this.checkPremiumStatus,
  }) : super(const IAPInitial()) {
    on<event.InitializeIAP>(_onInitializeIAP);
    on<event.LoadProducts>(_onLoadProducts);
    on<event.PurchaseProduct>(_onPurchaseProduct);
    on<event.RestorePurchases>(_onRestorePurchases);
    on<event.CheckPremiumStatus>(_onCheckPremiumStatus);
  }

  /// Initialize IAP
  Future<void> _onInitializeIAP(
    event.InitializeIAP e,
    Emitter<IAPState> emit,
  ) async {
    logger.blocEvent('IAPBloc', e);
    emit(const IAPInitializing());

    await Future.delayed(const Duration(milliseconds: 500));
    logger.i('IAP initialized', tag: 'IAPBloc');
    emit(const IAPInitialized());
  }

  /// Load Products
  Future<void> _onLoadProducts(
    event.LoadProducts e,
    Emitter<IAPState> emit,
  ) async {
    logger.blocEvent('IAPBloc', e);
    emit(const ProductsLoading());

    final result = await getProducts();

    result.fold(
      (failure) {
        logger.e('Failed to load products: ${failure.message}', tag: 'IAPBloc');
        emit(IAPError(
          message: _mapFailureToMessage(failure),
          code: failure.code,
        ));
      },
      (products) {
        logger.i('Loaded ${products.length} products', tag: 'IAPBloc');
        emit(ProductsLoaded(products: products));
      },
    );
  }

  /// Purchase Product
  Future<void> _onPurchaseProduct(
    event.PurchaseProduct e,
    Emitter<IAPState> emit,
  ) async {
    logger.blocEvent('IAPBloc', e);
    emit(Purchasing(e.productId));

    final result = await purchasePremium(
      PurchasePremiumParams(productId: e.productId),
    );

    result.fold(
      (failure) {
        logger.e('Purchase failed: ${failure.message}', tag: 'IAPBloc');

        if (failure is PurchaseCancelledFailure) {
          emit(const PurchaseCancelled());
        } else {
          emit(IAPError(
            message: _mapFailureToMessage(failure),
            code: failure.code,
          ));
        }
      },
      (purchase) {
        logger.i('Purchase successful: ${purchase.productId}', tag: 'IAPBloc');
        emit(PurchaseSuccess(purchase));

        // Reload products to update premium status
        add(const event.LoadProducts());
      },
    );
  }

  /// Restore Purchases
  Future<void> _onRestorePurchases(
    event.RestorePurchases e,
    Emitter<IAPState> emit,
  ) async {
    logger.blocEvent('IAPBloc', e);
    emit(const RestoringPurchases());

    final result = await restorePurchases();

    result.fold(
      (failure) {
        logger.e('Restore failed: ${failure.message}', tag: 'IAPBloc');
        emit(IAPError(
          message: _mapFailureToMessage(failure),
          code: failure.code,
        ));
      },
      (purchases) {
        logger.i('Restored ${purchases.length} purchases', tag: 'IAPBloc');
        emit(PurchasesRestored(purchases));

        // Reload products to update premium status
        add(const event.LoadProducts());
      },
    );
  }

  /// Check Premium Status
  Future<void> _onCheckPremiumStatus(
    event.CheckPremiumStatus e,
    Emitter<IAPState> emit,
  ) async {
    logger.blocEvent('IAPBloc', e);

    final result = await checkPremiumStatus(
      CheckPremiumStatusParams(userId: e.userId),
    );

    result.fold(
      (failure) {
        logger.e('Failed to check premium: ${failure.message}', tag: 'IAPBloc');
        emit(const PremiumStatusChecked(false));
      },
      (isPremium) {
        logger.i('Premium status: $isPremium', tag: 'IAPBloc');
        emit(PremiumStatusChecked(isPremium));
      },
    );
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is PurchaseCancelledFailure) {
      return 'Pembelian dibatalkan';
    } else if (failure is IAPFailure) {
      return failure.message;
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}
