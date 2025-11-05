/// File: lib/features/leaderboard/domain/entities/leaderboard_entry_entity.dart
/// Entity untuk single entry di leaderboard

import 'package:equatable/equatable.dart';

/// Leaderboard Entry Entity
class LeaderboardEntryEntity extends Equatable {
  final String userId;
  final String username;
  final String? photoUrl;
  final int rank;
  final int bestTime;        // dalam seconds
  final int totalSolved;
  final DateTime lastUpdated;
  final bool isPremium;

  const LeaderboardEntryEntity({
    required this.userId,
    required this.username,
    this.photoUrl,
    required this.rank,
    required this.bestTime,
    required this.totalSolved,
    required this.lastUpdated,
    this.isPremium = false,
  });

  /// Get initials dari username
  String get initials {
    if (username.isEmpty) return '?';
    
    final names = username.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
  }

  /// Check if top 3
  bool get isTopThree => rank >= 1 && rank <= 3;

  /// Get rank medal emoji
  String get rankMedal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        photoUrl,
        rank,
        bestTime,
        totalSolved,
        lastUpdated,
        isPremium,
      ];

  @override
  String toString() {
    return 'LeaderboardEntry(rank: $rank, username: $username, bestTime: $bestTime, totalSolved: $totalSolved)';
  }
}