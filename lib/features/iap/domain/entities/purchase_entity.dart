/// File: lib/features/iap/domain/entities/purchase_entity.dart
/// Entity untuk purchase

import 'package:equatable/equatable.dart';

/// Purchase Entity
class PurchaseEntity extends Equatable {
  final String purchaseId;
  final String productId;
  final String userId;
  final DateTime purchaseDate;
  final String status; // 'pending', 'purchased', 'restored', 'canceled', 'error'
  final bool isAcknowledged;
  final String? transactionId;

  const PurchaseEntity({
    required this.purchaseId,
    required this.productId,
    required this.userId,
    required this.purchaseDate,
    required this.status,
    this.isAcknowledged = false,
    this.transactionId,
  });

  /// Check if purchase is successful
  bool get isSuccessful => status == 'purchased' || status == 'restored';

  /// Check if purchase is pending
  bool get isPending => status == 'pending';

  /// Check if purchase is canceled
  bool get isCanceled => status == 'canceled';

  @override
  List<Object?> get props => [
        purchaseId,
        productId,
        userId,
        purchaseDate,
        status,
        isAcknowledged,
        transactionId,
      ];

  @override
  String toString() {
    return 'PurchaseEntity(id: $purchaseId, product: $productId, status: $status)';
  }
}