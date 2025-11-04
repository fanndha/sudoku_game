/// File: lib/features/auth/domain/repositories/auth_repository.dart
/// Repository interface untuk authentication (domain layer)

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract Repository untuk Authentication
/// Interface ini akan diimplementasikan oleh data layer
abstract class AuthRepository {
  /// Sign in dengan Google
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign in sebagai anonymous
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> signInAnonymous();

  /// Sign out
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> signOut();

  /// Get current user
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Check apakah user sudah login
  /// Returns Either<Failure, bool>
  Future<Either<Failure, bool>> isSignedIn();
}