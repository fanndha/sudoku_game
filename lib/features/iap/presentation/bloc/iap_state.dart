/// File: lib/features/iap/presentation/bloc/iap_state.dart
/// States untuk IAP Bloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/purchase_entity.dart';

/// Base State
abstract class IAPState extends Equatable {
  const IAPState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class IAPInitial extends IAPState {
  const IAPInitial();
}

/// IAP Initializing State
class IAPInitializing extends IAPState {
  const IAPInitializing();
}

/// IAP Initialized State
class IAPInitialized extends IAPState {
  const IAPInitialized();
}

/// Products Loading State
class ProductsLoading extends IAPState {
  const ProductsLoading();
}

/// Products Loaded State
class ProductsLoaded extends IAPState {
  final List<ProductEntity> products;
  final bool isPremium;

  const ProductsLoaded({
    required this.products,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [products, isPremium];

  /// Get premium product
  ProductEntity? get premiumProduct {
    try {
      return products.firstWhere((p) => p.isPremiumPackage);
    } catch (e) {
      return null;
    }
  }

  /// Get hint pack product
  ProductEntity? get hintPackProduct {
    try {
      return products.firstWhere((p) => p.isHintPack);
    } catch (e) {
      return null;
    }
  }
}

/// Purchasing State
class Purchasing extends IAPState {
  final String productId;

  const Purchasing(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Purchase Success State
class PurchaseSuccess extends IAPState {
  final PurchaseEntity purchase;

  const PurchaseSuccess(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

/// Purchase Cancelled State
class PurchaseCancelled extends IAPState {
  const PurchaseCancelled();
}

/// Restoring Purchases State
class RestoringPurchases extends IAPState {
  const RestoringPurchases();
}

/// Purchases Restored State
class PurchasesRestored extends IAPState {
  final List<PurchaseEntity> purchases;

  const PurchasesRestored(this.purchases);

  @override
  List<Object?> get props => [purchases];
}

/// Purchase History Loaded State
class PurchaseHistoryLoaded extends IAPState {
  final List<PurchaseEntity> purchases;

  const PurchaseHistoryLoaded(this.purchases);

  @override
  List<Object?> get props => [purchases];
}

/// Premium Status Checked State
class PremiumStatusChecked extends IAPState {
  final bool isPremium;

  const PremiumStatusChecked(this.isPremium);

  @override
  List<Object?> get props => [isPremium];
}

/// IAP Error State
class IAPError extends IAPState {
  final String message;
  final String? code;

  const IAPError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}