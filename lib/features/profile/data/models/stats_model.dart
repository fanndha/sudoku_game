/// File: lib/features/profile/data/models/stats_model.dart
/// Model untuk user statistics

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/stats_entity.dart';

/// Stats Model
class StatsModel extends StatsEntity {
  const StatsModel({
    required super.userId,
    required super.username,
    super.email,
    super.photoUrl,
    super.isPremium,
    super.totalGamesPlayed,
    super.totalGamesCompleted,
    super.totalHintsUsed,
    super.perfectGames,
    super.winStreak,
    super.bestStreak,
    super.lastPlayedDate,
    super.totalPlayTime,
    super.bestTimeEasy,
    super.bestTimeMedium,
    super.bestTimeHard,
    super.bestTimeExpert,
    required super.createdAt,
    required super.lastUpdated,
  });

  /// Create from Entity
  factory StatsModel.fromEntity(StatsEntity entity) {
    return StatsModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      photoUrl: entity.photoUrl,
      isPremium: entity.isPremium,
      totalGamesPlayed: entity.totalGamesPlayed,
      totalGamesCompleted: entity.totalGamesCompleted,
      totalHintsUsed: entity.totalHintsUsed,
      perfectGames: entity.perfectGames,
      winStreak: entity.winStreak,
      bestStreak: entity.bestStreak,
      lastPlayedDate: entity.lastPlayedDate,
      totalPlayTime: entity.totalPlayTime,
      bestTimeEasy: entity.bestTimeEasy,
      bestTimeMedium: entity.bestTimeMedium,
      bestTimeHard: entity.bestTimeHard,
      bestTimeExpert: entity.bestTimeExpert,
      createdAt: entity.createdAt,
      lastUpdated: entity.lastUpdated,
    );
  }

  /// Create from JSON
  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
      totalGamesCompleted: json['totalGamesCompleted'] as int? ?? 0,
      totalHintsUsed: json['totalHintsUsed'] as int? ?? 0,
      perfectGames: json['perfectGames'] as int? ?? 0,
      winStreak: json['winStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.parse(json['lastPlayedDate'] as String)
          : null,
      totalPlayTime: json['totalPlayTime'] as int? ?? 0,
      bestTimeEasy: json['bestTimeEasy'] as int?,
      bestTimeMedium: json['bestTimeMedium'] as int?,
      bestTimeHard: json['bestTimeHard'] as int?,
      bestTimeExpert: json['bestTimeExpert'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Create from Firestore
  factory StatsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return StatsModel(
      userId: doc.id,
      username: data['username'] as String? ?? 'Unknown',
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isPremium: data['isPremium'] as bool? ?? false,
      totalGamesPlayed: data['totalGamesPlayed'] as int? ?? 0,
      totalGamesCompleted: data['totalGamesCompleted'] as int? ?? 0,
      totalHintsUsed: data['totalHintsUsed'] as int? ?? 0,
      perfectGames: data['perfectGames'] as int? ?? 0,
      winStreak: data['winStreak'] as int? ?? 0,
      bestStreak: data['bestStreak'] as int? ?? 0,
      lastPlayedDate: data['lastPlayedDate'] != null
          ? (data['lastPlayedDate'] as Timestamp).toDate()
          : null,
      totalPlayTime: data['totalPlayTime'] as int? ?? 0,
      bestTimeEasy: data['bestTimeEasy'] as int?,
      bestTimeMedium: data['bestTimeMedium'] as int?,
      bestTimeHard: data['bestTimeHard'] as int?,
      bestTimeExpert: data['bestTimeExpert'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'totalGamesPlayed': totalGamesPlayed,
      'totalGamesCompleted': totalGamesCompleted,
      'totalHintsUsed': totalHintsUsed,
      'perfectGames': perfectGames,
      'winStreak': winStreak,
      'bestStreak': bestStreak,
      'lastPlayedDate': lastPlayedDate?.toIso8601String(),
      'totalPlayTime': totalPlayTime,
      'bestTimeEasy': bestTimeEasy,
      'bestTimeMedium': bestTimeMedium,
      'bestTimeHard': bestTimeHard,
      'bestTimeExpert': bestTimeExpert,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'totalGamesPlayed': totalGamesPlayed,
      'totalGamesCompleted': totalGamesCompleted,
      'totalHintsUsed': totalHintsUsed,
      'perfectGames': perfectGames,
      'winStreak': winStreak,
      'bestStreak': bestStreak,
      'lastPlayedDate': lastPlayedDate != null
          ? Timestamp.fromDate(lastPlayedDate!)
          : null,
      'totalPlayTime': totalPlayTime,
      'bestTimeEasy': bestTimeEasy,
      'bestTimeMedium': bestTimeMedium,
      'bestTimeHard': bestTimeHard,
      'bestTimeExpert': bestTimeExpert,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  /// Copy with
  StatsModel copyWith({
    String? userId,
    String? username,
    String? email,
    String? photoUrl,
    bool? isPremium,
    int? totalGamesPlayed,
    int? totalGamesCompleted,
    int? totalHintsUsed,
    int? perfectGames,
    int? winStreak,
    int? bestStreak,
    DateTime? lastPlayedDate,
    int? totalPlayTime,
    int? bestTimeEasy,
    int? bestTimeMedium,
    int? bestTimeHard,
    int? bestTimeExpert,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return StatsModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalGamesCompleted: totalGamesCompleted ?? this.totalGamesCompleted,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      perfectGames: perfectGames ?? this.perfectGames,
      winStreak: winStreak ?? this.winStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      bestTimeEasy: bestTimeEasy ?? this.bestTimeEasy,
      bestTimeMedium: bestTimeMedium ?? this.bestTimeMedium,
      bestTimeHard: bestTimeHard ?? this.bestTimeHard,
      bestTimeExpert: bestTimeExpert ?? this.bestTimeExpert,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}