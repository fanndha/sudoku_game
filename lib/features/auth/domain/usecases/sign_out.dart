/// File: lib/features/auth/domain/usecases/sign_out.dart
/// UseCase untuk sign out

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk Sign Out
/// Tidak memerlukan parameter, jadi gunakan NoParams
/// Return type adalah void karena sign out tidak return data
class SignOut implements UseCaseNoParams<void> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}