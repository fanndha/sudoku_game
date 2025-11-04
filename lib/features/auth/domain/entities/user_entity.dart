/// File: lib/features/auth/domain/entities/user_entity.dart
/// User entity untuk domain layer (pure business object)

import 'package:equatable/equatable.dart';

/// User Entity - Pure business object
/// Tidak ada dependency ke framework atau library eksternal
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isPremium;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
    this.isPremium = false,
    this.createdAt,
    this.lastLoginAt,
  });

  /// Check apakah user sudah terautentikasi
  bool get isAuthenticated => uid.isNotEmpty && !isAnonymous;

  /// Check apakah user adalah guest
  bool get isGuest => isAnonymous;

  /// Get display name atau email
  String get displayNameOrEmail => displayName.isNotEmpty ? displayName : email;

  /// Get initials dari display name (untuk avatar)
  String get initials {
    if (displayName.isEmpty) return '?';
    
    final names = displayName.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
  }

  /// Check apakah ada photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        isAnonymous,
        isPremium,
        createdAt,
        lastLoginAt,
      ];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName)';
  }
}