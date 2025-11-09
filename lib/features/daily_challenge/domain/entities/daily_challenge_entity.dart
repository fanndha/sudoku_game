/// File: lib/features/daily_challenge/domain/entities/daily_challenge_entity.dart
/// Entity untuk daily challenge

import 'package:equatable/equatable.dart';

/// Daily Challenge Entity
class DailyChallengeEntity extends Equatable {
  final String id;
  final String date; // Format: yyyy-MM-dd
  final String difficulty;
  final List<List<int>> puzzle; // 9x9 grid
  final List<List<int>> solution; // 9x9 grid
  final int participantsCount;
  final int completionsCount;
  final String? userBestTime; // User's best time for this challenge (if completed)
  final bool isCompleted; // Has user completed this challenge?
  final DateTime? completedAt;
  final int? userScore; // Score jika sudah complete

  const DailyChallengeEntity({
    required this.id,
    required this.date,
    required this.difficulty,
    required this.puzzle,
    required this.solution,
    this.participantsCount = 0,
    this.completionsCount = 0,
    this.userBestTime,
    this.isCompleted = false,
    this.completedAt,
    this.userScore,
  });

  /// Check if challenge is for today
  bool get isToday {
    final today = DateTime.now();
    final challengeDate = DateTime.parse(date);
    return today.year == challengeDate.year &&
        today.month == challengeDate.month &&
        today.day == challengeDate.day;
  }

  /// Check if challenge is expired
  bool get isExpired {
    final today = DateTime.now();
    final challengeDate = DateTime.parse(date);
    return today.isAfter(
      DateTime(
        challengeDate.year,
        challengeDate.month,
        challengeDate.day,
        23,
        59,
        59,
      ),
    );
  }

  /// Get completion rate
  double get completionRate {
    if (participantsCount == 0) return 0;
    return completionsCount / participantsCount;
  }

  /// Get difficulty color key
  String get difficultyKey => difficulty.toLowerCase();

  @override
  List<Object?> get props => [
        id,
        date,
        difficulty,
        puzzle,
        solution,
        participantsCount,
        completionsCount,
        userBestTime,
        isCompleted,
        completedAt,
        userScore,
      ];

  @override
  String toString() {
    return 'DailyChallengeEntity(id: $id, date: $date, difficulty: $difficulty, '
        'isCompleted: $isCompleted, participants: $participantsCount)';
  }

  /// Create empty challenge (for testing)
  factory DailyChallengeEntity.empty() {
    return DailyChallengeEntity(
      id: '',
      date: DateTime.now().toString().substring(0, 10),
      difficulty: 'medium',
      puzzle: List.generate(9, (_) => List.filled(9, 0)),
      solution: List.generate(9, (_) => List.filled(9, 0)),
    );
  }
}