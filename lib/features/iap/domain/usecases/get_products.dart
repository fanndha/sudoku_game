/// File: lib/features/iap/domain/usecases/get_products.dart
/// UseCase untuk get products

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/iap_repository.dart';

/// UseCase untuk Get Products
class GetProducts implements UseCaseNoParams<List<ProductEntity>> {
  final IAPRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getProducts();
  }
}