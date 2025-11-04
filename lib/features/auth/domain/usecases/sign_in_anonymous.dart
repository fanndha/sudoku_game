/// File: lib/features/auth/domain/usecases/sign_in_anonymous.dart
/// UseCase untuk sign in sebagai anonymous

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk Sign In Anonymous
/// Tidak memerlukan parameter, jadi gunakan NoParams
class SignInAnonymous implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  SignInAnonymous(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInAnonymous();
  }
}