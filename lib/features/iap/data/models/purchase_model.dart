/// File: lib/features/iap/data/models/purchase_model.dart
/// Model untuk purchase

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/purchase_entity.dart';

/// Purchase Model
class PurchaseModel extends PurchaseEntity {
  const PurchaseModel({
    required super.purchaseId,
    required super.productId,
    required super.userId,
    required super.purchaseDate,
    required super.status,
    super.isAcknowledged,
    super.transactionId,
  });

  /// Create from Entity
  factory PurchaseModel.fromEntity(PurchaseEntity entity) {
    return PurchaseModel(
      purchaseId: entity.purchaseId,
      productId: entity.productId,
      userId: entity.userId,
      purchaseDate: entity.purchaseDate,
      status: entity.status,
      isAcknowledged: entity.isAcknowledged,
      transactionId: entity.transactionId,
    );
  }

  /// Create from JSON
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchaseId'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      status: json['status'] as String,
      isAcknowledged: json['isAcknowledged'] as bool? ?? false,
      transactionId: json['transactionId'] as String?,
    );
  }

  /// Create from Firestore
  factory PurchaseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return PurchaseModel(
      purchaseId: doc.id,
      productId: data['productId'] as String,
      userId: data['userId'] as String,
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      status: data['status'] as String,
      isAcknowledged: data['isAcknowledged'] as bool? ?? false,
      transactionId: data['transactionId'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'purchaseId': purchaseId,
      'productId': productId,
      'userId': userId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
      'isAcknowledged': isAcknowledged,
      'transactionId': transactionId,
    };
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'status': status,
      'isAcknowledged': isAcknowledged,
      'transactionId': transactionId,
    };
  }

  /// Copy with
  PurchaseModel copyWith({
    String? purchaseId,
    String? productId,
    String? userId,
    DateTime? purchaseDate,
    String? status,
    bool? isAcknowledged,
    String? transactionId,
  }) {
    return PurchaseModel(
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}