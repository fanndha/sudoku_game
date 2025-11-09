/// File: lib/features/iap/presentation/bloc/iap_event.dart
/// Events untuk IAP Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class IAPEvent extends Equatable {
  const IAPEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize IAP Event
class InitializeIAP extends IAPEvent {
  const InitializeIAP();
}

/// Load Products Event
class LoadProducts extends IAPEvent {
  const LoadProducts();
}

/// Purchase Product Event
class PurchaseProduct extends IAPEvent {
  final String productId;

  const PurchaseProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Restore Purchases Event
class RestorePurchases extends IAPEvent {
  const RestorePurchases();
}

/// Check Premium Status Event
class CheckPremiumStatus extends IAPEvent {
  final String userId;

  const CheckPremiumStatus(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Load Purchase History Event
class LoadPurchaseHistory extends IAPEvent {
  final String userId;

  const LoadPurchaseHistory(this.userId);

  @override
  List<Object?> get props => [userId];
}