/// File: lib/features/auth/domain/usecases/sign_in_with_google.dart
/// UseCase untuk sign in dengan Google

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase untuk Sign In dengan Google
/// Tidak memerlukan parameter, jadi gunakan NoParams
class SignInWithGoogle implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}

/// Alternative implementation jika ingin ada tracking/analytics
class SignInWithGoogleTracked implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;
  // Bisa tambahkan analytics service di sini
  // final AnalyticsService analytics;

  SignInWithGoogleTracked(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    // Log analytics event
    // await analytics.logEvent('sign_in_google_attempt');
    
    final result = await repository.signInWithGoogle();
    
    // Log result
    result.fold(
      (failure) {
        // await analytics.logEvent('sign_in_google_failed', parameters: {'error': failure.message});
      },
      (user) {
        // await analytics.logEvent('sign_in_google_success', parameters: {'uid': user.uid});
      },
    );
    
    return result;
  }
}