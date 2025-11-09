/// File: lib/features/daily_challenge/presentation/bloc/daily_challenge_state.dart
/// States untuk Daily Challenge Bloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/daily_challenge_entity.dart';

/// Base State
abstract class DailyChallengeState extends Equatable {
  const DailyChallengeState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class DailyChallengeInitial extends DailyChallengeState {
  const DailyChallengeInitial();
}

/// Loading State
class ChallengeLoading extends DailyChallengeState {
  const ChallengeLoading();
}

/// Loaded State
class ChallengeLoaded extends DailyChallengeState {
  final DailyChallengeEntity challenge;

  const ChallengeLoaded({required this.challenge});

  @override
  List<Object?> get props => [challenge];
}

/// Submitting State (saat user menyelesaikan challenge)
class ChallengeSubmitting extends DailyChallengeState {
  final DailyChallengeEntity challenge;

  const ChallengeSubmitting({required this.challenge});

  @override
  List<Object?> get props => [challenge];
}

/// Completed State
class ChallengeCompleted extends DailyChallengeState {
  final DailyChallengeEntity challenge;
  final bool showCelebration;

  const ChallengeCompleted({
    required this.challenge,
    this.showCelebration = false,
  });

  @override
  List<Object?> get props => [challenge, showCelebration];
}

/// History Loaded State
class ChallengeHistoryLoaded extends DailyChallengeState {
  final List<DailyChallengeEntity> challenges;

  const ChallengeHistoryLoaded({required this.challenges});

  @override
  List<Object?> get props => [challenges];
}

/// Error State
class ChallengeError extends DailyChallengeState {
  final String message;
  final String? code;

  const ChallengeError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}