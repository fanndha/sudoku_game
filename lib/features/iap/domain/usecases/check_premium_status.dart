/// File: lib/features/iap/domain/usecases/check_premium_status.dart
/// UseCase untuk check premium status

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/iap_repository.dart';

/// UseCase untuk Check Premium Status
class CheckPremiumStatus implements UseCase<bool, CheckPremiumStatusParams> {
  final IAPRepository repository;

  CheckPremiumStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckPremiumStatusParams params) async {
    return await repository.checkPremiumStatus(params.userId);
  }
}

/// Parameters untuk CheckPremiumStatus
class CheckPremiumStatusParams extends Params {
  final String userId;

  CheckPremiumStatusParams({required this.userId});

  @override
  List<Object?> get props => [userId];

  @override
  String? validate() {
    if (userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    return null;
  }
}