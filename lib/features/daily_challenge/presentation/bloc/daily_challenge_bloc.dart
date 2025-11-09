/// File: lib/features/daily_challenge/presentation/bloc/daily_challenge_bloc.dart
/// BLoC untuk Daily Challenge

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/complete_daily_challenge.dart';
import '../../domain/usecases/get_daily_challenge.dart';
import 'daily_challenge_event.dart';
import 'daily_challenge_state.dart';

/// Daily Challenge Bloc
class DailyChallengeBloc
    extends Bloc<DailyChallengeEvent, DailyChallengeState> {
  final GetDailyChallenge getDailyChallenge;
  final CompleteDailyChallenge completeDailyChallenge;

  DailyChallengeBloc({
    required this.getDailyChallenge,
    required this.completeDailyChallenge,
  }) : super(const DailyChallengeInitial()) {
    on<LoadTodayChallenge>(_onLoadTodayChallenge);
    on<LoadChallengeByDate>(_onLoadChallengeByDate);
    on<CompleteChallenge>(_onCompleteChallenge);
    on<ResetChallenge>(_onResetChallenge);
  }

  /// Load Today's Challenge
  Future<void> _onLoadTodayChallenge(
    LoadTodayChallenge event,
    Emitter<DailyChallengeState> emit,
  ) async {
    logger.blocEvent('DailyChallengeBloc', event);
    emit(const ChallengeLoading());

    final result = await getDailyChallenge();

    result.fold(
      (failure) {
        logger.e('Failed to load challenge: ${failure.message}', 
            tag: 'DailyChallengeBloc');
        emit(ChallengeError(
          message: _mapFailureToMessage(failure),
          code: failure.code,
        ));
      },
      (challenge) {
        logger.i('Challenge loaded: ${challenge.id}', tag: 'DailyChallengeBloc');
        
        if (challenge.isCompleted) {
          emit(ChallengeCompleted(challenge: challenge));
        } else {
          emit(ChallengeLoaded(challenge: challenge));
        }
      },
    );
  }

  /// Load Challenge by Date
  Future<void> _onLoadChallengeByDate(
    LoadChallengeByDate event,
    Emitter<DailyChallengeState> emit,
  ) async {
    logger.blocEvent('DailyChallengeBloc', event);
    emit(const ChallengeLoading());

    // TODO: Implement getChallengeByDate use case
    logger.w('Load by date not implemented', tag: 'DailyChallengeBloc');
    emit(const ChallengeError(
      message: 'Fitur belum tersedia',
    ));
  }

  /// Complete Challenge
  Future<void> _onCompleteChallenge(
    CompleteChallenge event,
    Emitter<DailyChallengeState> emit,
  ) async {
    logger.blocEvent('DailyChallengeBloc', event);

    // Get current challenge
    if (state is! ChallengeLoaded) {
      logger.w('No challenge loaded', tag: 'DailyChallengeBloc');
      return;
    }

    final currentChallenge = (state as ChallengeLoaded).challenge;
    emit(ChallengeSubmitting(challenge: currentChallenge));

    final result = await completeDailyChallenge(
      CompleteChallengeParams(
        challengeId: event.challengeId,
        userId: event.userId,
        timeSpent: event.timeSpent,
        hintsUsed: event.hintsUsed,
        moves: event.moves,
      ),
    );

    result.fold(
      (failure) {
        logger.e('Failed to complete challenge: ${failure.message}', 
            tag: 'DailyChallengeBloc');
        emit(ChallengeError(
          message: _mapFailureToMessage(failure),
          code: failure.code,
        ));
        
        // Return to loaded state
        emit(ChallengeLoaded(challenge: currentChallenge));
      },
      (_) {
        logger.i('Challenge completed successfully', tag: 'DailyChallengeBloc');
        
        // Update challenge as completed
        emit(ChallengeCompleted(
          challenge: currentChallenge,
          showCelebration: true,
        ));
      },
    );
  }

  /// Reset Challenge
  Future<void> _onResetChallenge(
    ResetChallenge event,
    Emitter<DailyChallengeState> emit,
  ) async {
    logger.blocEvent('DailyChallengeBloc', event);
    emit(const DailyChallengeInitial());
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is ServerFailure) {
      return 'Terjadi kesalahan server';
    } else if (failure is DocumentNotFoundFailure) {
      return 'Tantangan tidak ditemukan';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}