/// File: lib/features/iap/domain/usecases/purchase_hints.dart
/// UseCase untuk purchase hints

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_entity.dart';
import '../repositories/iap_repository.dart';

/// UseCase untuk Purchase Hints
class PurchaseHints implements UseCase<PurchaseEntity, PurchaseHintsParams> {
  final IAPRepository repository;

  PurchaseHints(this.repository);

  @override
  Future<Either<Failure, PurchaseEntity>> call(
    PurchaseHintsParams params,
  ) async {
    return await repository.purchaseProduct(params.productId);
  }
}

/// Parameters untuk PurchaseHints
class PurchaseHintsParams extends Params {
  final String productId;

  PurchaseHintsParams({required this.productId});

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