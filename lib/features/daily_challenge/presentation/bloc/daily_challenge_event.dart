/// File: lib/features/daily_challenge/presentation/bloc/daily_challenge_event.dart
/// Events untuk Daily Challenge Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class DailyChallengeEvent extends Equatable {
  const DailyChallengeEvent();

  @override
  List<Object?> get props => [];
}

/// Load Today's Challenge Event
class LoadTodayChallenge extends DailyChallengeEvent {
  const LoadTodayChallenge();
}

/// Load Challenge by Date Event
class LoadChallengeByDate extends DailyChallengeEvent {
  final String date;

  const LoadChallengeByDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Complete Challenge Event
class CompleteChallenge extends DailyChallengeEvent {
  final String challengeId;
  final String userId;
  final int timeSpent;
  final int hintsUsed;
  final int moves;

  const CompleteChallenge({
    required this.challengeId,
    required this.userId,
    required this.timeSpent,
    required this.hintsUsed,
    required this.moves,
  });

  @override
  List<Object?> get props => [
        challengeId,
        userId,
        timeSpent,
        hintsUsed,
        moves,
      ];
}

/// Reset Challenge Event
class ResetChallenge extends DailyChallengeEvent {
  const ResetChallenge();
}

/// Load Challenge History Event
class LoadChallengeHistory extends DailyChallengeEvent {
  final String userId;

  const LoadChallengeHistory(this.userId);

  @override
  List<Object?> get props => [userId];
}