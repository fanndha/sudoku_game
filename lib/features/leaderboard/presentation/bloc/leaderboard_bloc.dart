/// File: lib/features/leaderboard/presentation/bloc/leaderboard_bloc.dart
/// BLoC untuk Leaderboard

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_leaderboard.dart';
import '../../domain/usecases/get_user_rank.dart';
import '../../domain/usecases/update_leaderboard.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';

/// Leaderboard Bloc
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final GetLeaderboard getLeaderboard;
  final GetUserRank getUserRank;
  final UpdateLeaderboard updateLeaderboard;

  // Current filter and difficulty
  String _currentDifficulty = 'easy';
  String _currentFilter = 'all_time';

  LeaderboardBloc({
    required this.getLeaderboard,
    required this.getUserRank,
    required this.updateLeaderboard,
  }) : super(const LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
    on<RefreshLeaderboard>(_onRefreshLeaderboard);
    on<ChangeLeaderboardFilter>(_onChangeFilter);
    on<ChangeLeaderboardDifficulty>(_onChangeDifficulty);
    on<UpdateUserLeaderboard>(_onUpdateUserLeaderboard);
    on<LoadUserRank>(_onLoadUserRank);
  }

  /// Load Leaderboard
  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);
    emit(const LeaderboardLoading());

    _currentDifficulty = event.difficulty;
    _currentFilter = event.filter;

    final result = await getLeaderboard(
      GetLeaderboardParams(
        difficulty: event.difficulty,
        filter: event.filter,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) {
        logger.e('Failed to load leaderboard: ${failure.message}', tag: 'LeaderboardBloc');
        emit(LeaderboardError(
          message: _mapFailureToMessage(failure),
          code: failure.code,
        ));
      },
      (entries) {
        logger.i('Loaded ${entries.length} entries', tag: 'LeaderboardBloc');
        emit(LeaderboardLoaded(
          entries: entries,
          difficulty: event.difficulty,
          filter: event.filter,
        ));
      },
    );
  }

  /// Refresh Leaderboard
  Future<void> _onRefreshLeaderboard(
    RefreshLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);
    
    add(LoadLeaderboard(
      difficulty: _currentDifficulty,
      filter: _currentFilter,
    ));
  }

  /// Change Filter
  Future<void> _onChangeFilter(
    ChangeLeaderboardFilter event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);
    _currentFilter = event.filter;
    
    add(LoadLeaderboard(
      difficulty: _currentDifficulty,
      filter: event.filter,
    ));
  }

  /// Change Difficulty
  Future<void> _onChangeDifficulty(
    ChangeLeaderboardDifficulty event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);
    _currentDifficulty = event.difficulty;
    
    add(LoadLeaderboard(
      difficulty: event.difficulty,
      filter: _currentFilter,
    ));
  }

  /// Update User Leaderboard
  Future<void> _onUpdateUserLeaderboard(
    UpdateUserLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);

    final currentState = state;
    if (currentState is LeaderboardLoaded) {
      emit(LeaderboardUpdating(
        currentEntries: currentState.entries,
        currentUserRank: currentState.userRank,
      ));
    }

    final result = await updateLeaderboard(
      UpdateLeaderboardParams(
        userId: event.userId,
        difficulty: event.difficulty,
        bestTime: event.bestTime,
        totalSolved: event.totalSolved,
      ),
    );

    result.fold(
      (failure) {
        logger.e('Failed to update leaderboard: ${failure.message}', tag: 'LeaderboardBloc');
        if (currentState is LeaderboardLoaded) {
          emit(LeaderboardUpdateError(
            message: _mapFailureToMessage(failure),
            currentEntries: currentState.entries,
            currentUserRank: currentState.userRank,
          ));
        } else {
          emit(LeaderboardError(message: _mapFailureToMessage(failure)));
        }
      },
      (_) {
        logger.i('Leaderboard updated successfully', tag: 'LeaderboardBloc');
        emit(const LeaderboardUpdateSuccess());
        
        // Reload leaderboard after update
        add(LoadLeaderboard(
          difficulty: event.difficulty,
          filter: _currentFilter,
        ));
      },
    );
  }

  /// Load User Rank
  Future<void> _onLoadUserRank(
    LoadUserRank event,
    Emitter<LeaderboardState> emit,
  ) async {
    logger.blocEvent('LeaderboardBloc', event);

    final currentState = state;
    if (currentState is! LeaderboardLoaded) return;

    final result = await getUserRank(
      GetUserRankParams(
        userId: event.userId,
        difficulty: event.difficulty,
        filter: event.filter,
      ),
    );

    result.fold(
      (failure) {
        logger.e('Failed to load user rank: ${failure.message}', tag: 'LeaderboardBloc');
        // Don't emit error, just log it
      },
      (userRank) {
        logger.i('User rank loaded: ${userRank?.rank ?? "Not ranked"}', tag: 'LeaderboardBloc');
        emit(currentState.copyWith(userRank: userRank));
      },
    );
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is ServerFailure) {
      return 'Terjadi kesalahan server';
    } else if (failure is FirestoreFailure) {
      return failure.message;
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}