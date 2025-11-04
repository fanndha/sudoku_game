/// File: lib/features/auth/domain/usecases/check_signed_in.dart
/// UseCase untuk check apakah user sudah signed in

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk Check Signed In Status
/// Tidak memerlukan parameter, jadi gunakan NoParams
/// Return type adalah bool
class CheckSignedIn implements UseCaseNoParams<bool> {
  final AuthRepository repository;

  CheckSignedIn(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.isSignedIn();
  }
}