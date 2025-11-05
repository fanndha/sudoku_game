/// File: lib/features/leaderboard/data/models/leaderboard_entry_model.dart
/// Model untuk leaderboard entry

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

/// Leaderboard Entry Model
class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.userId,
    required super.username,
    super.photoUrl,
    required super.rank,
    required super.bestTime,
    required super.totalSolved,
    required super.lastUpdated,
    super.isPremium,
  });

  /// Create from Entity
  factory LeaderboardEntryModel.fromEntity(LeaderboardEntryEntity entity) {
    return LeaderboardEntryModel(
      userId: entity.userId,
      username: entity.username,
      photoUrl: entity.photoUrl,
      rank: entity.rank,
      bestTime: entity.bestTime,
      totalSolved: entity.totalSolved,
      lastUpdated: entity.lastUpdated,
      isPremium: entity.isPremium,
    );
  }

  /// Create from JSON
  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      photoUrl: json['photoUrl'] as String?,
      rank: json['rank'] as int? ?? 0,
      bestTime: json['bestTime'] as int,
      totalSolved: json['totalSolved'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  /// Create from Firestore
  factory LeaderboardEntryModel.fromFirestore(
    DocumentSnapshot doc,
    int rank,
  ) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return LeaderboardEntryModel(
      userId: doc.id,
      username: data['username'] as String? ?? 'Unknown',
      photoUrl: data['photoUrl'] as String?,
      rank: rank,
      bestTime: data['bestTime'] as int,
      totalSolved: data['totalSolved'] as int? ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      isPremium: data['isPremium'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'photoUrl': photoUrl,
      'rank': rank,
      'bestTime': bestTime,
      'totalSolved': totalSolved,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'photoUrl': photoUrl,
      'bestTime': bestTime,
      'totalSolved': totalSolved,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'isPremium': isPremium,
    };
  }

  /// Copy with
  LeaderboardEntryModel copyWith({
    String? userId,
    String? username,
    String? photoUrl,
    int? rank,
    int? bestTime,
    int? totalSolved,
    DateTime? lastUpdated,
    bool? isPremium,
  }) {
    return LeaderboardEntryModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      rank: rank ?? this.rank,
      bestTime: bestTime ?? this.bestTime,
      totalSolved: totalSolved ?? this.totalSolved,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}