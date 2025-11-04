/// File: lib/core/error/exceptions.dart
/// Custom exceptions untuk error handling
library;

/// Base Exception Class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// ========== SERVER EXCEPTIONS ==========

/// Server Exception - ketika ada error dari server/API
class ServerException extends AppException {
  ServerException({
    super.message = 'Server error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'ServerException: $message';
}

// ========== NETWORK EXCEPTIONS ==========

/// Network Exception - ketika tidak ada internet atau koneksi gagal
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection',
    super.code,
    super.details,
  });

  @override
  String toString() => 'NetworkException: $message';
}

// ========== CACHE EXCEPTIONS ==========

/// Cache Exception - ketika ada error dengan local storage
class CacheException extends AppException {
  CacheException({
    super.message = 'Cache error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'CacheException: $message';
}

// ========== AUTH EXCEPTIONS ==========

/// Authentication Exception - ketika ada error saat autentikasi
class AuthException extends AppException {
  AuthException({
    super.message = 'Authentication error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// User Not Found Exception
class UserNotFoundException extends AuthException {
  UserNotFoundException({
    super.message = 'User not found',
    super.code,
  });
}

/// Invalid Credentials Exception
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException({
    super.message = 'Invalid credentials',
    super.code,
  });
}

/// User Cancelled Exception - ketika user membatalkan sign in
class UserCancelledException extends AuthException {
  UserCancelledException({
    super.message = 'User cancelled sign in',
    super.code,
  });
}

// ========== FIREBASE EXCEPTIONS ==========

/// Firestore Exception - error dari Firestore
class FirestoreException extends AppException {
  FirestoreException({
    super.message = 'Firestore error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'FirestoreException: $message';
}

/// Permission Denied Exception
class PermissionDeniedException extends FirestoreException {
  PermissionDeniedException({
    super.message = 'Permission denied',
    super.code,
  });
}

/// Document Not Found Exception
class DocumentNotFoundException extends FirestoreException {
  DocumentNotFoundException({
    super.message = 'Document not found',
    super.code,
  });
}

// ========== GAME EXCEPTIONS ==========

/// Game Exception - error terkait game logic
class GameException extends AppException {
  GameException({
    super.message = 'Game error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'GameException: $message';
}

/// Invalid Move Exception
class InvalidMoveException extends GameException {
  InvalidMoveException({
    super.message = 'Invalid move',
    super.code,
  });
}

/// Puzzle Generation Exception
class PuzzleGenerationException extends GameException {
  PuzzleGenerationException({
    super.message = 'Failed to generate puzzle',
    super.code,
  });
}

/// Puzzle Solving Exception
class PuzzleSolvingException extends GameException {
  PuzzleSolvingException({
    super.message = 'Failed to solve puzzle',
    super.code,
  });
}

/// Game Not Found Exception
class GameNotFoundException extends GameException {
  GameNotFoundException({
    super.message = 'Game not found',
    super.code,
  });
}

// ========== IAP EXCEPTIONS ==========

/// In-App Purchase Exception
class IAPException extends AppException {
  IAPException({
    super.message = 'Purchase error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'IAPException: $message';
}

/// Purchase Cancelled Exception
class PurchaseCancelledException extends IAPException {
  PurchaseCancelledException({
    super.message = 'Purchase cancelled',
    super.code,
  });
}

/// Product Not Found Exception
class ProductNotFoundException extends IAPException {
  ProductNotFoundException({
    super.message = 'Product not found',
    super.code,
  });
}

/// Purchase Already Owned Exception
class PurchaseAlreadyOwnedException extends IAPException {
  PurchaseAlreadyOwnedException({
    super.message = 'Product already owned',
    super.code,
  });
}

/// Purchase Verification Failed Exception
class PurchaseVerificationFailedException extends IAPException {
  PurchaseVerificationFailedException({
    super.message = 'Purchase verification failed',
    super.code,
  });
}

// ========== ADS EXCEPTIONS ==========

/// Ad Exception - error terkait ads
class AdException extends AppException {
  AdException({
    super.message = 'Ad error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'AdException: $message';
}

/// Ad Not Available Exception
class AdNotAvailableException extends AdException {
  AdNotAvailableException({
    super.message = 'Ad not available',
    super.code,
  });
}

/// Ad Failed To Load Exception
class AdFailedToLoadException extends AdException {
  AdFailedToLoadException({
    super.message = 'Failed to load ad',
    super.code,
  });
}

/// Ad Failed To Show Exception
class AdFailedToShowException extends AdException {
  AdFailedToShowException({
    super.message = 'Failed to show ad',
    super.code,
  });
}

// ========== VALIDATION EXCEPTIONS ==========

/// Validation Exception - untuk input validation errors
class ValidationException extends AppException {
  ValidationException({
    super.message = 'Validation error',
    super.code,
    super.details,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Empty Field Exception
class EmptyFieldException extends ValidationException {
  final String fieldName;
  
  EmptyFieldException({
    required this.fieldName,
    super.code,
  }) : super(message: '$fieldName cannot be empty');
}

/// Invalid Format Exception
class InvalidFormatException extends ValidationException {
  final String fieldName;
  
  InvalidFormatException({
    required this.fieldName,
    super.code,
  }) : super(message: 'Invalid format for $fieldName');
}

// ========== SYNC EXCEPTIONS ==========

/// Sync Exception - error saat sinkronisasi data
class SyncException extends AppException {
  SyncException({
    super.message = 'Sync error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'SyncException: $message';
}

// ========== TIMEOUT EXCEPTIONS ==========

/// Timeout Exception
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Request timeout',
    super.code,
    super.details,
  });

  @override
  String toString() => 'TimeoutException: $message';
}

// ========== UNKNOWN EXCEPTIONS ==========

/// Unknown Exception - untuk error yang tidak teridentifikasi
class UnknownException extends AppException {
  UnknownException({
    super.message = 'An unknown error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnknownException: $message';
}