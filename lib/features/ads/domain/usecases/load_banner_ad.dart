/// File: lib/features/ads/domain/usecases/load_banner_ad.dart
/// UseCase untuk load banner ad

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

/// UseCase untuk Load Banner Ad
class LoadBannerAd implements UseCaseNoParams<void> {
  final AdsRepository repository;

  LoadBannerAd(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.loadBannerAd();
  }
}