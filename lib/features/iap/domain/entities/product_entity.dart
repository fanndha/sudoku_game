/// File: lib/features/iap/domain/entities/product_entity.dart
/// Entity untuk product

import 'package:equatable/equatable.dart';

/// Product Entity
class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String price;
  final double priceValue;
  final String currencyCode;
  final bool isConsumable;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceValue,
    required this.currencyCode,
    this.isConsumable = false,
  });

  /// Check if product is premium package
  bool get isPremiumPackage => id.contains('premium');

  /// Check if product is hint pack
  bool get isHintPack => id.contains('hint');

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        priceValue,
        currencyCode,
        isConsumable,
      ];

  @override
  String toString() {
    return 'ProductEntity(id: $id, title: $title, price: $price)';
  }
}