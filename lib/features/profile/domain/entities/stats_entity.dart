/// File: lib/features/profile/domain/entities/stats_entity.dart
/// Entity untuk user statistics

import 'package:equatable/equatable.dart';

/// Stats Entity
class StatsEntity extends Equatable {
  final String userId;
  final String username;
  final String? email;
  final String? photoUrl;
  final bool isPremium;
  
  // Game Stats
  final int totalGamesPlayed;
  final int totalGamesCompleted;
  final int totalHintsUsed;
  final int perfectGames;
  
  // Streak Stats
  final int winStreak;
  final int bestStreak;
  final DateTime? lastPlayedDate;
  
  // Time Stats
  final int totalPlayTime; // in seconds
  final int? bestTimeEasy;
  final int? bestTimeMedium;
  final int? bestTimeHard;
  final int? bestTimeExpert;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime lastUpdated;

  const StatsEntity({
    required this.userId,
    required this.username,
    this.email,
    this.photoUrl,
    this.isPremium = false,
    this.totalGamesPlayed = 0,
    this.totalGamesCompleted = 0,
    this.totalHintsUsed = 0,
    this.perfectGames = 0,
    this.winStreak = 0,
    this.bestStreak = 0,
    this.lastPlayedDate,
    this.totalPlayTime = 0,
    this.bestTimeEasy,
    this.bestTimeMedium,
    this.bestTimeHard,
    this.bestTimeExpert,
    required this.createdAt,
    required this.lastUpdated,
  });

  /// Calculate win rate
  double get winRate {
    if (totalGamesPlayed == 0) return 0.0;
    return totalGamesCompleted / totalGamesPlayed;
  }

  /// Get average hints per game
  double get averageHints {
    if (totalGamesCompleted == 0) return 0.0;
    return totalHintsUsed / totalGamesCompleted;
  }

  /// Check if has played today
  bool get hasPlayedToday {
    if (lastPlayedDate == null) return false;
    final now = DateTime.now();
    return lastPlayedDate!.year == now.year &&
        lastPlayedDate!.month == now.month &&
        lastPlayedDate!.day == now.day;
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
        photoUrl,
        isPremium,
        totalGamesPlayed,
        totalGamesCompleted,
        totalHintsUsed,
        perfectGames,
        winStreak,
        bestStreak,
        lastPlayedDate,
        totalPlayTime,
        bestTimeEasy,
        bestTimeMedium,
        bestTimeHard,
        bestTimeExpert,
        createdAt,
        lastUpdated,
      ];

  @override
  String toString() {
    return 'StatsEntity(userId: $userId, username: $username, gamesPlayed: $totalGamesPlayed, gamesCompleted: $totalGamesCompleted)';
  }
}