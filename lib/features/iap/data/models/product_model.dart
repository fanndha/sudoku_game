/// File: lib/features/iap/data/models/product_model.dart
/// Model untuk product

import '../../domain/entities/product_entity.dart';

/// Product Model
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.priceValue,
    required super.currencyCode,
    super.isConsumable,
  });

  /// Create from Entity
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      priceValue: entity.priceValue,
      currencyCode: entity.currencyCode,
      isConsumable: entity.isConsumable,
    );
  }

  /// Create from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      priceValue: (json['priceValue'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      isConsumable: json['isConsumable'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'priceValue': priceValue,
      'currencyCode': currencyCode,
      'isConsumable': isConsumable,
    };
  }

  /// Copy with
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    double? priceValue,
    String? currencyCode,
    bool? isConsumable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceValue: priceValue ?? this.priceValue,
      currencyCode: currencyCode ?? this.currencyCode,
      isConsumable: isConsumable ?? this.isConsumable,
    );
  }
}