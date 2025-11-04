/// File: lib/features/auth/domain/usecases/get_current_user.dart
/// UseCase untuk get current user

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk Get Current User
/// Tidak memerlukan parameter, jadi gunakan NoParams
class GetCurrentUser implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}