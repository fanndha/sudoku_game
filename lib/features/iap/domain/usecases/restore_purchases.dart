/// File: lib/features/iap/domain/usecases/restore_purchases.dart
/// UseCase untuk restore purchases

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_entity.dart';
import '../repositories/iap_repository.dart';

/// UseCase untuk Restore Purchases
class RestorePurchases implements UseCaseNoParams<List<PurchaseEntity>> {
  final IAPRepository repository;

  RestorePurchases(this.repository);

  @override
  Future<Either<Failure, List<PurchaseEntity>>> call() async {
    return await repository.restorePurchases();
  }
}