/// File: lib/features/iap/domain/usecases/purchase_premium.dart
/// UseCase untuk purchase premium

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_entity.dart';
import '../repositories/iap_repository.dart';

/// UseCase untuk Purchase Premium
class PurchasePremium implements UseCase<PurchaseEntity, PurchasePremiumParams> {
  final IAPRepository repository;

  PurchasePremium(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    PurchasePremiumParams params,
  ) async {
    return await repository.purchaseProduct(params.productId);
  }
}

/// Parameters untuk PurchasePremium
class PurchasePremiumParams extends Params {
  final String productId;

  PurchasePremiumParams({required this.productId});

  @override
  List<Object?> get props => [productId];

  @override
  String? validate() {
    if (productId.isEmpty) {
      return 'Product ID cannot be empty';
    }
    return null;
  }
}