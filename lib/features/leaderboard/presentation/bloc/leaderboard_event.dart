/// File: lib/features/leaderboard/presentation/bloc/leaderboard_event.dart
/// Events untuk Leaderboard Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load Leaderboard Event
class LoadLeaderboard extends LeaderboardEvent {
  final String difficulty;
  final String filter; // 'daily', 'weekly', 'all_time'
  final int limit;

  const LoadLeaderboard({
    required this.difficulty,
    required this.filter,
    this.limit = 100,
  });

  @override
  List<Object?> get props => [difficulty, filter, limit];
}

/// Refresh Leaderboard Event
class RefreshLeaderboard extends LeaderboardEvent {
  const RefreshLeaderboard();
}

/// Change Filter Event
class ChangeLeaderboardFilter extends LeaderboardEvent {
  final String filter;

  const ChangeLeaderboardFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Change Difficulty Event
class ChangeLeaderboardDifficulty extends LeaderboardEvent {
  final String difficulty;

  const ChangeLeaderboardDifficulty(this.difficulty);

  @override
  List<Object?> get props => [difficulty];
}

/// Update User Leaderboard Event
class UpdateUserLeaderboard extends LeaderboardEvent {
  final String userId;
  final String difficulty;
  final int bestTime;
  final int totalSolved;

  const UpdateUserLeaderboard({
    required this.userId,
    required this.difficulty,
    required this.bestTime,
    required this.totalSolved,
  });

  @override
  List<Object?> get props => [userId, difficulty, bestTime, totalSolved];
}

/// Load User Rank Event
class LoadUserRank extends LeaderboardEvent {
  final String userId;
  final String difficulty;
  final String filter;

  const LoadUserRank({
    required this.userId,
    required this.difficulty,
    required this.filter,
  });

  @override
  List<Object?> get props => [userId, difficulty, filter];
}