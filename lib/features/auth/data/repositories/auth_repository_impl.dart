/// File: lib/features/auth/data/repositories/auth_repository_impl.dart
/// Implementation dari AuthRepository

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
// ignore: unused_import
import '../models/user_model.dart';

/// Implementation dari AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      // Check network connection
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'AuthRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      // Sign in via remote data source
      final userModel = await remoteDataSource.signInWithGoogle();

      // Cache user locally
      await localDataSource.cacheUser(userModel);

      logger.i('Sign in with Google successful', tag: 'AuthRepository');
      return Right(userModel);
    } on UserCancelledException catch (e) {
      logger.w('User cancelled sign in', tag: 'AuthRepository');
      return Left(UserCancelledFailure(
        message: e.message,
        code: e.code,
      ));
    } on AuthException catch (e) {
      logger.e('Auth exception: ${e.message}', tag: 'AuthRepository');
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'AuthRepository');
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
      ));
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'AuthRepository');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error during sign in with Google', error: e, tag: 'AuthRepository');
      return Left(UnknownFailure(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInAnonymous() async {
    try {
      // Check network connection
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'AuthRepository');
        return const Left(NetworkFailure(
          message: 'Tidak ada koneksi internet',
        ));
      }

      // Sign in via remote data source
      final userModel = await remoteDataSource.signInAnonymous();

      // Cache user locally
      await localDataSource.cacheUser(userModel);

      logger.i('Sign in anonymous successful', tag: 'AuthRepository');
      return Right(userModel);
    } on AuthException catch (e) {
      logger.e('Auth exception: ${e.message}', tag: 'AuthRepository');
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'AuthRepository');
      return Left(NetworkFailure(
        message: e.message,
        code: e.code,
      ));
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'AuthRepository');
      return Left(FirestoreFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error during anonymous sign in', error: e, tag: 'AuthRepository');
      return Left(UnknownFailure(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Sign out dari remote
      await remoteDataSource.signOut();

      // Clear local cache
      await localDataSource.clearCache();

      logger.i('Sign out successful', tag: 'AuthRepository');
      return const Right(null);
    } on AuthException catch (e) {
      logger.e('Auth exception during sign out: ${e.message}', tag: 'AuthRepository');
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on CacheException catch (e) {
      logger.e('Cache exception during sign out: ${e.message}', tag: 'AuthRepository');
      // Even if cache clear fails, sign out was successful
      return const Right(null);
    } catch (e) {
      logger.e('Unknown error during sign out', error: e, tag: 'AuthRepository');
      return Left(UnknownFailure(
        message: 'Terjadi kesalahan saat logout: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Try to get user from remote first
      if (await networkInfo.isConnected) {
        try {
          final userModel = await remoteDataSource.getCurrentUser();
          
          if (userModel != null) {
            // Update cache
            await localDataSource.cacheUser(userModel);
            logger.i('Current user retrieved from remote', tag: 'AuthRepository');
            return Right(userModel);
          }
        } catch (e) {
          logger.w('Failed to get user from remote, trying cache', error: e, tag: 'AuthRepository');
        }
      }

      // Fallback to cached user
      final cachedUser = await localDataSource.getCachedUser();
      
      if (cachedUser != null) {
        logger.i('Current user retrieved from cache', tag: 'AuthRepository');
        return Right(cachedUser);
      }

      // No user found
      logger.d('No current user found', tag: 'AuthRepository');
      return const Left(UserNotFoundFailure(
        message: 'User tidak ditemukan',
      ));
    } on AuthException catch (e) {
      logger.e('Auth exception: ${e.message}', tag: 'AuthRepository');
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'AuthRepository');
      return Left(CacheFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      logger.e('Unknown error getting current user', error: e, tag: 'AuthRepository');
      return Left(UnknownFailure(
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      // Check remote first if online
      if (await networkInfo.isConnected) {
        final isSignedIn = await remoteDataSource.isSignedIn();
        logger.d('User signed in (remote): $isSignedIn', tag: 'AuthRepository');
        return Right(isSignedIn);
      }

      // Fallback to cache check
      final hasCached = await localDataSource.hasCachedUser();
      logger.d('User signed in (cache): $hasCached', tag: 'AuthRepository');
      return Right(hasCached);
    } catch (e) {
      logger.e('Error checking sign in status', error: e, tag: 'AuthRepository');
      // Return false on error (safer to assume not signed in)
      return const Right(false);
    }
  }
}