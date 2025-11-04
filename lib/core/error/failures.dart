/// File: lib/core/error/failures.dart
/// Failure classes untuk functional error handling dengan dartz

import 'package:equatable/equatable.dart';

/// Base Failure Class
/// Menggunakan Equatable untuk comparison
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

// ========== SERVER FAILURES ==========

/// Server Failure - ketika ada error dari server/API
class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'ServerFailure: $message';
}

// ========== NETWORK FAILURES ==========

/// Network Failure - ketika tidak ada internet atau koneksi gagal
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'NetworkFailure: $message';
}

// ========== CACHE FAILURES ==========

/// Cache Failure - ketika ada error dengan local storage
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'CacheFailure: $message';
}

// ========== AUTH FAILURES ==========

/// Authentication Failure - ketika ada error saat autentikasi
class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Authentication error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'AuthFailure: $message';
}

/// User Not Found Failure
class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    String message = 'User not found',
    String? code,
  }) : super(message: message, code: code);
}

/// Invalid Credentials Failure
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    String message = 'Invalid credentials',
    String? code,
  }) : super(message: message, code: code);
}

/// User Cancelled Failure
class UserCancelledFailure extends AuthFailure {
  const UserCancelledFailure({
    String message = 'User cancelled sign in',
    String? code,
  }) : super(message: message, code: code);
}

// ========== FIREBASE FAILURES ==========

/// Firestore Failure - error dari Firestore
class FirestoreFailure extends Failure {
  const FirestoreFailure({
    String message = 'Firestore error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'FirestoreFailure: $message';
}

/// Permission Denied Failure
class PermissionDeniedFailure extends FirestoreFailure {
  const PermissionDeniedFailure({
    String message = 'Permission denied',
    String? code,
  }) : super(message: message, code: code);
}

/// Document Not Found Failure
class DocumentNotFoundFailure extends FirestoreFailure {
  const DocumentNotFoundFailure({
    String message = 'Document not found',
    String? code,
  }) : super(message: message, code: code);
}

// ========== GAME FAILURES ==========

/// Game Failure - error terkait game logic
class GameFailure extends Failure {
  const GameFailure({
    String message = 'Game error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'GameFailure: $message';
}

/// Invalid Move Failure
class InvalidMoveFailure extends GameFailure {
  const InvalidMoveFailure({
    String message = 'Invalid move',
    String? code,
  }) : super(message: message, code: code);
}

/// Puzzle Generation Failure
class PuzzleGenerationFailure extends GameFailure {
  const PuzzleGenerationFailure({
    String message = 'Failed to generate puzzle',
    String? code,
  }) : super(message: message, code: code);
}

/// Puzzle Solving Failure
class PuzzleSolvingFailure extends GameFailure {
  const PuzzleSolvingFailure({
    String message = 'Failed to solve puzzle',
    String? code,
  }) : super(message: message, code: code);
}

/// Game Not Found Failure
class GameNotFoundFailure extends GameFailure {
  const GameNotFoundFailure({
    String message = 'Game not found',
    String? code,
  }) : super(message: message, code: code);
}

// ========== IAP FAILURES ==========

/// In-App Purchase Failure
class IAPFailure extends Failure {
  const IAPFailure({
    String message = 'Purchase error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'IAPFailure: $message';
}

/// Purchase Cancelled Failure
class PurchaseCancelledFailure extends IAPFailure {
  const PurchaseCancelledFailure({
    String message = 'Purchase cancelled',
    String? code,
  }) : super(message: message, code: code);
}

/// Product Not Found Failure
class ProductNotFoundFailure extends IAPFailure {
  const ProductNotFoundFailure({
    String message = 'Product not found',
    String? code,
  }) : super(message: message, code: code);
}

/// Purchase Already Owned Failure
class PurchaseAlreadyOwnedFailure extends IAPFailure {
  const PurchaseAlreadyOwnedFailure({
    String message = 'Product already owned',
    String? code,
  }) : super(message: message, code: code);
}

/// Purchase Verification Failed Failure
class PurchaseVerificationFailedFailure extends IAPFailure {
  const PurchaseVerificationFailedFailure({
    String message = 'Purchase verification failed',
    String? code,
  }) : super(message: message, code: code);
}

// ========== ADS FAILURES ==========

/// Ad Failure - error terkait ads
class AdFailure extends Failure {
  const AdFailure({
    String message = 'Ad error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'AdFailure: $message';
}

/// Ad Not Available Failure
class AdNotAvailableFailure extends AdFailure {
  const AdNotAvailableFailure({
    String message = 'Ad not available',
    String? code,
  }) : super(message: message, code: code);
}

/// Ad Failed To Load Failure
class AdFailedToLoadFailure extends AdFailure {
  const AdFailedToLoadFailure({
    String message = 'Failed to load ad',
    String? code,
  }) : super(message: message, code: code);
}

/// Ad Failed To Show Failure
class AdFailedToShowFailure extends AdFailure {
  const AdFailedToShowFailure({
    String message = 'Failed to show ad',
    String? code,
  }) : super(message: message, code: code);
}

// ========== VALIDATION FAILURES ==========

/// Validation Failure - untuk input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = 'Validation error',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'ValidationFailure: $message';
}

/// Empty Field Failure
class EmptyFieldFailure extends ValidationFailure {
  final String fieldName;

  const EmptyFieldFailure({
    required this.fieldName,
    String? code,
  }) : super(message: '$fieldName cannot be empty', code: code);

  @override
  List<Object?> get props => [fieldName, code];
}

/// Invalid Format Failure
class InvalidFormatFailure extends ValidationFailure {
  final String fieldName;

  const InvalidFormatFailure({
    required this.fieldName,
    String? code,
  }) : super(message: 'Invalid format for $fieldName', code: code);

  @override
  List<Object?> get props => [fieldName, code];
}

// ========== SYNC FAILURES ==========

/// Sync Failure - error saat sinkronisasi data
class SyncFailure extends Failure {
  const SyncFailure({
    String message = 'Sync error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'SyncFailure: $message';
}

// ========== TIMEOUT FAILURES ==========

/// Timeout Failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timeout',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'TimeoutFailure: $message';
}

// ========== UNKNOWN FAILURES ==========

/// Unknown Failure - untuk error yang tidak teridentifikasi
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unknown error occurred',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);

  @override
  String toString() => 'UnknownFailure: $message';
}

// ========== HELPER FUNCTION ==========

/// Convert exception message to user-friendly message
String getFailureMessage(Failure failure) {
  if (failure is NetworkFailure) {
    return 'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
  } else if (failure is ServerFailure) {
    return 'Terjadi kesalahan server. Silakan coba lagi.';
  } else if (failure is CacheFailure) {
    return 'Terjadi kesalahan penyimpanan data.';
  } else if (failure is AuthFailure) {
    return 'Terjadi kesalahan autentikasi. ${failure.message}';
  } else if (failure is GameFailure) {
    return 'Terjadi kesalahan game. ${failure.message}';
  } else if (failure is IAPFailure) {
    return 'Terjadi kesalahan pembelian. ${failure.message}';
  } else if (failure is AdFailure) {
    return 'Iklan tidak tersedia saat ini.';
  } else {
    return failure.message;
  }
}