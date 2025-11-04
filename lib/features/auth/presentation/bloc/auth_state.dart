/// File: lib/features/auth/presentation/bloc/auth_state.dart
/// States untuk AuthBloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class untuk semua Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - saat app baru start
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - saat proses authentication
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state - user sudah login
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];

  /// Helper method untuk check premium status
  bool get isPremium => user.isPremium;

  /// Helper method untuk check anonymous
  bool get isAnonymous => user.isAnonymous;

  /// Helper method untuk get user display name
  String get displayName => user.displayNameOrEmail;
}

/// Unauthenticated state - user belum login atau sudah logout
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state - terjadi error saat authentication
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Sign Out Success state - untuk show feedback saat logout
class AuthSignOutSuccess extends AuthState {
  const AuthSignOutSuccess();
}

/// User Cancelled state - user membatalkan sign in (khususnya Google)
class AuthUserCancelled extends AuthState {
  const AuthUserCancelled();
}