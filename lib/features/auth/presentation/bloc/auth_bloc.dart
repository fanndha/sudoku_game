/// File: lib/features/auth/presentation/bloc/auth_bloc.dart
/// Bloc untuk manage authentication state

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/check_signed_in.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_anonymous.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc - Manage authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInAnonymous signInAnonymous;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final CheckSignedIn checkSignedIn;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInAnonymous,
    required this.signOut,
    required this.getCurrentUser,
    required this.checkSignedIn,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<AuthCheckSignedInEvent>(_onCheckSignedIn);
    on<AuthGetCurrentUserEvent>(_onGetCurrentUser);
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignInAnonymousEvent>(_onSignInAnonymous);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthRefreshUserEvent>(_onRefreshUser);
    on<AuthUpdatePremiumStatusEvent>(_onUpdatePremiumStatus);
  }

  /// Handler untuk check signed in (saat app start)
  Future<void> _onCheckSignedIn(
    AuthCheckSignedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    emit(const AuthLoading());

    final result = await checkSignedIn();

    result.fold(
      (failure) {
        logger.e('Check signed in failed: ${failure.message}', tag: 'AuthBloc');
        emit(const AuthUnauthenticated());
      },
      (isSignedIn) async {
        if (isSignedIn) {
          // User signed in, get user data
          add(const AuthGetCurrentUserEvent());
        } else {
          logger.d('User not signed in', tag: 'AuthBloc');
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Handler untuk get current user
  Future<void> _onGetCurrentUser(
    AuthGetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    emit(const AuthLoading());

    final result = await getCurrentUser();

    result.fold(
      (failure) {
        logger.e('Get current user failed: ${failure.message}', tag: 'AuthBloc');
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
      (user) {
        logger.i('Current user loaded: ${user.uid}', tag: 'AuthBloc');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  /// Handler untuk sign in with Google
  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    emit(const AuthLoading());

    final result = await signInWithGoogle();

    result.fold(
      (failure) {
        logger.e('Sign in with Google failed: ${failure.message}', tag: 'AuthBloc');
        
        // Special handling untuk user cancelled
        if (failure is UserCancelledFailure) {
          emit(const AuthUserCancelled());
          // Return ke unauthenticated after short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!isClosed) {
              emit(const AuthUnauthenticated());
            }
          });
        } else {
          emit(AuthError(message: _mapFailureToMessage(failure)));
        }
      },
      (user) {
        logger.i('Sign in with Google success: ${user.uid}', tag: 'AuthBloc');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  /// Handler untuk sign in anonymous
  Future<void> _onSignInAnonymous(
    AuthSignInAnonymousEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    emit(const AuthLoading());

    final result = await signInAnonymous();

    result.fold(
      (failure) {
        logger.e('Sign in anonymous failed: ${failure.message}', tag: 'AuthBloc');
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
      (user) {
        logger.i('Sign in anonymous success: ${user.uid}', tag: 'AuthBloc');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  /// Handler untuk sign out
  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    emit(const AuthLoading());

    final result = await signOut();

    result.fold(
      (failure) {
        logger.e('Sign out failed: ${failure.message}', tag: 'AuthBloc');
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
      (_) {
        logger.i('Sign out success', tag: 'AuthBloc');
        emit(const AuthSignOutSuccess());
        
        // Transition ke unauthenticated after short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            emit(const AuthUnauthenticated());
          }
        });
      },
    );
  }

  /// Handler untuk refresh user data
  Future<void> _onRefreshUser(
    AuthRefreshUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);
    
    // Don't emit loading untuk refresh (agar UI tidak flicker)
    final result = await getCurrentUser();

    result.fold(
      (failure) {
        logger.e('Refresh user failed: ${failure.message}', tag: 'AuthBloc');
        // Keep current state jika refresh gagal
      },
      (user) {
        logger.i('User refreshed: ${user.uid}', tag: 'AuthBloc');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  /// Handler untuk update premium status
  Future<void> _onUpdatePremiumStatus(
    AuthUpdatePremiumStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    logger.blocEvent('AuthBloc', event);

    // Update state jika sedang authenticated
    if (state is AuthAuthenticated) {
      // ignore: unused_local_variable
      final currentState = state as AuthAuthenticated;
      
      // Refresh user data to get latest from server
      add(const AuthRefreshUserEvent());
    }
  }

  /// Map Failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
    } else if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is UserNotFoundFailure) {
      return 'User tidak ditemukan. Silakan login kembali.';
    } else if (failure is ServerFailure) {
      return 'Terjadi kesalahan server. Silakan coba lagi.';
    } else {
      return failure.message;
    }
  }

  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);
    logger.blocEvent('AuthBloc', event);
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    logger.blocState('AuthBloc', change.nextState);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    logger.e('AuthBloc Error', error: error, stackTrace: stackTrace, tag: 'AuthBloc');
    super.onError(error, stackTrace);
  }
}