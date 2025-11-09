/// File: lib/features/ads/domain/usecases/initialize_ads.dart
/// UseCase untuk initialize ads

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

/// UseCase untuk Initialize Ads
class InitializeAds implements UseCaseNoParams<void> {
  final AdsRepository repository;

  InitializeAds(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.initializeAds();
  }
}