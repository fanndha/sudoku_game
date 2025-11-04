/// File: lib/features/auth/presentation/bloc/auth_event.dart
/// Events untuk AuthBloc

import 'package:equatable/equatable.dart';

/// Base class untuk semua Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk check apakah user sudah signed in (saat app start)
class AuthCheckSignedInEvent extends AuthEvent {
  const AuthCheckSignedInEvent();
}

/// Event untuk get current user data
class AuthGetCurrentUserEvent extends AuthEvent {
  const AuthGetCurrentUserEvent();
}

/// Event untuk sign in dengan Google
class AuthSignInWithGoogleEvent extends AuthEvent {
  const AuthSignInWithGoogleEvent();
}

/// Event untuk sign in sebagai anonymous
class AuthSignInAnonymousEvent extends AuthEvent {
  const AuthSignInAnonymousEvent();
}

/// Event untuk sign out
class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

/// Event untuk refresh user data (setelah purchase/update profile)
class AuthRefreshUserEvent extends AuthEvent {
  const AuthRefreshUserEvent();
}

/// Event untuk update user premium status
class AuthUpdatePremiumStatusEvent extends AuthEvent {
  final bool isPremium;

  const AuthUpdatePremiumStatusEvent({required this.isPremium});

  @override
  List<Object?> get props => [isPremium];
}