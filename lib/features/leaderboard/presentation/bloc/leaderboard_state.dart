/// File: lib/features/leaderboard/presentation/bloc/leaderboard_state.dart
/// States untuk Leaderboard Bloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

/// Base State
abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

/// Loading State
class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

/// Loaded State
class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntryEntity> entries;
  final LeaderboardEntryEntity? userRank;
  final String difficulty;
  final String filter;

  const LeaderboardLoaded({
    required this.entries,
    this.userRank,
    required this.difficulty,
    required this.filter,
  });

  @override
  List<Object?> get props => [entries, userRank, difficulty, filter];

  /// Check if entries is empty
  bool get isEmpty => entries.isEmpty;

  /// Get top 3 entries
  List<LeaderboardEntryEntity> get topThree {
    if (entries.length < 3) return entries;
    return entries.sublist(0, 3);
  }

  /// Copy with
  LeaderboardLoaded copyWith({
    List<LeaderboardEntryEntity>? entries,
    LeaderboardEntryEntity? userRank,
    String? difficulty,
    String? filter,
  }) {
    return LeaderboardLoaded(
      entries: entries ?? this.entries,
      userRank: userRank ?? this.userRank,
      difficulty: difficulty ?? this.difficulty,
      filter: filter ?? this.filter,
    );
  }
}

/// Error State
class LeaderboardError extends LeaderboardState {
  final String message;
  final String? code;

  const LeaderboardError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Updating State (when updating leaderboard in background)
class LeaderboardUpdating extends LeaderboardState {
  final List<LeaderboardEntryEntity> currentEntries;
  final LeaderboardEntryEntity? currentUserRank;

  const LeaderboardUpdating({
    required this.currentEntries,
    this.currentUserRank,
  });

  @override
  List<Object?> get props => [currentEntries, currentUserRank];
}

/// Update Success State (brief state before going back to loaded)
class LeaderboardUpdateSuccess extends LeaderboardState {
  const LeaderboardUpdateSuccess();
}

/// Update Error State
class LeaderboardUpdateError extends LeaderboardState {
  final String message;
  final List<LeaderboardEntryEntity> currentEntries;
  final LeaderboardEntryEntity? currentUserRank;

  const LeaderboardUpdateError({
    required this.message,
    required this.currentEntries,
    this.currentUserRank,
  });

  @override
  List<Object?> get props => [message, currentEntries, currentUserRank];
}