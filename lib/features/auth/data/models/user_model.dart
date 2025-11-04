/// File: lib/features/auth/data/models/user_model.dart
/// User model untuk data layer (extends UserEntity)

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// User Model - Data Transfer Object
/// Extends UserEntity dan menambahkan toJson/fromJson untuk serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
    super.isAnonymous,
    super.isPremium,
    super.createdAt,
    super.lastLoginAt,
  });

  /// Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      isAnonymous: entity.isAnonymous,
      isPremium: entity.isPremium,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Create UserModel from JSON (untuk local storage)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Guest',
      photoUrl: json['photoUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    
    if (data == null) {
      throw Exception('Document data is null');
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'Guest',
      photoUrl: data['photoUrl'] as String?,
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      isPremium: data['isPremium'] as bool? ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create UserModel from Firebase User
  factory UserModel.fromFirebaseUser(
    dynamic firebaseUser, {
    bool isPremium = false,
  }) {
    return UserModel(
      uid: firebaseUser.uid as String,
      email: firebaseUser.email as String? ?? '',
      displayName: firebaseUser.displayName as String? ?? 'Guest',
      photoUrl: firebaseUser.photoURL as String?,
      isAnonymous: firebaseUser.isAnonymous as bool? ?? false,
      isPremium: isPremium,
      createdAt: firebaseUser.metadata?.creationTime,
      lastLoginAt: firebaseUser.metadata?.lastSignInTime,
    );
  }

  /// Convert UserModel to JSON (untuk local storage)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isPremium': isPremium,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Convert UserModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isPremium': isPremium,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  /// Create empty user (untuk initial state)
  factory UserModel.empty() {
    return const UserModel(
      uid: '',
      email: '',
      displayName: 'Guest',
      isAnonymous: true,
    );
  }

  /// Copy with method untuk immutability
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isAnonymous,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Update last login time
  UserModel updateLastLogin() {
    return copyWith(lastLoginAt: DateTime.now());
  }

  /// Upgrade to premium
  UserModel upgradeToPremium() {
    return copyWith(isPremium: true);
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, '
        'isAnonymous: $isAnonymous, isPremium: $isPremium)';
  }
}