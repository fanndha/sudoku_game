/// File: lib/features/profile/presentation/bloc/profile_bloc.dart
/// BLoC untuk Profile

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/features/profile/presentation/bloc/profile_event.dart'
    as event;
import 'package:sudoku_game/features/profile/presentation/bloc/profile_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_achievements.dart' as usecase;
import '../../domain/usecases/get_user_stats.dart' as usecase;
import '../../domain/usecases/unlock_achievement.dart' as usecase;
import '../../domain/usecases/update_user_stats.dart' as usecase;

/// Profile Bloc
class ProfileBloc extends Bloc<event.ProfileEvent, ProfileState> {
  final usecase.GetUserStats getUserStats;
  final usecase.UpdateUserStats updateUserStats;
  final usecase.GetAchievements getAchievements;
  final usecase.UnlockAchievement unlockAchievement;

  ProfileBloc({
    required this.getUserStats,
    required this.updateUserStats,
    required this.getAchievements,
    required this.unlockAchievement,
  }) : super(const ProfileInitial()) {
    on<event.LoadUserStats>(_onLoadUserStats);
    on<event.RefreshUserStats>(_onRefreshUserStats);
    on<event.UpdateUserStats>(_onUpdateUserStats);
    on<event.LoadAchievements>(_onLoadAchievements);
    on<event.UnlockAchievement>(_onUnlockAchievement);
  }

  /// Load User Stats
  Future<void> _onLoadUserStats(
    event.LoadUserStats event,
    Emitter<ProfileState> emit,
  ) async {
    logger.blocEvent('ProfileBloc', event);
    emit(const ProfileLoading());

    final statsResult = await getUserStats(
      usecase.GetUserStatsParams(userId: event.userId),
    );

    final achievementsResult = await getAchievements(
      usecase.GetAchievementsParams(userId: event.userId),
    );

    if (statsResult.isLeft() || achievementsResult.isLeft()) {
      final failure = statsResult.fold(
        (l) => l,
        (r) => achievementsResult.fold((l) => l, (r) => null),
      );

      if (failure != null) {
        logger.e(
          'Failed to load profile: ${failure.message}',
          tag: 'ProfileBloc',
        );
        emit(
          ProfileError(
            message: _mapFailureToMessage(failure),
            code: failure.code,
          ),
        );
      }
      return;
    }

    final stats = statsResult.getOrElse(
      () => throw Exception('Stats not found'),
    );
    final achievements = achievementsResult.getOrElse(
      () => throw Exception('Achievements not found'),
    );

    logger.i('Profile loaded successfully', tag: 'ProfileBloc');
    emit(ProfileLoaded(stats: stats, achievements: achievements));
  }

  /// Refresh User Stats
  Future<void> _onRefreshUserStats(
    event.RefreshUserStats event,
    Emitter<ProfileState> emit,
  ) async {
    logger.blocEvent('ProfileBloc', event);
    add(event.event.LoadUserStats(event.userId));
  }

  /// Update User Stats
  Future<void> _onUpdateUserStats(
    event.UpdateUserStats event,
    Emitter<ProfileState> emit,
  ) async {
    logger.blocEvent('ProfileBloc', event);

    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(
        ProfileUpdating(
          currentStats: currentState.stats,
          currentAchievements: currentState.achievements,
        ),
      );
    }

    final result = await updateUserStats(
      usecase.UpdateUserStatsParams(userId: event.userId, stats: event.stats),
    );

    result.fold(
      (failure) {
        logger.e(
          'Failed to update stats: ${failure.message}',
          tag: 'ProfileBloc',
        );
        if (currentState is ProfileLoaded) {
          emit(
            ProfileUpdateError(
              message: _mapFailureToMessage(failure),
              currentStats: currentState.stats,
              currentAchievements: currentState.achievements,
            ),
          );
        } else {
          emit(ProfileError(message: _mapFailureToMessage(failure)));
        }
      },
      (_) {
        logger.i('Stats updated successfully', tag: 'ProfileBloc');
        emit(const ProfileUpdateSuccess('Statistik berhasil diperbarui'));
        add(event.event.LoadUserStats(event.userId));
      },
    );
  }

  /// Load Achievements
  Future<void> _onLoadAchievements(
    event.LoadAchievements event,
    Emitter<ProfileState> emit,
  ) async {
    logger.blocEvent('ProfileBloc', event);

    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final result = await getAchievements(
      usecase.GetAchievementsParams(userId: event.userId),
    );

    result.fold(
      (failure) {
        logger.e(
          'Failed to load achievements: ${failure.message}',
          tag: 'ProfileBloc',
        );
      },
      (achievements) {
        logger.i(
          'Achievements loaded: ${achievements.length}',
          tag: 'ProfileBloc',
        );
        emit(currentState.copyWith(achievements: achievements));
      },
    );
  }

  /// Unlock Achievement
  Future<void> _onUnlockAchievement(
    event.UnlockAchievement event,
    Emitter<ProfileState> emit,
  ) async {
    logger.blocEvent('ProfileBloc', event);

    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final result = await unlockAchievement(
      usecase.UnlockAchievementParams(
        userId: event.userId,
        achievementId: event.achievementId,
      ),
    );

    result.fold(
      (failure) {
        logger.e(
          'Failed to unlock achievement: ${failure.message}',
          tag: 'ProfileBloc',
        );
        emit(
          ProfileUpdateError(
            message: _mapFailureToMessage(failure),
            currentStats: currentState.stats,
            currentAchievements: currentState.achievements,
          ),
        );
      },
      (achievement) {
        logger.i(
          'Achievement unlocked: ${achievement.name}',
          tag: 'ProfileBloc',
        );

        emit(
          AchievementUnlocked(
            achievement: achievement,
            currentStats: currentState.stats,
            currentAchievements: currentState.achievements,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          add(event.event.LoadUserStats(event.userId));
        });
      },
    );
  }

  /// Map Failure to Message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is ServerFailure) {
      return 'Terjadi kesalahan server';
    } else if (failure is CacheFailure) {
      return 'Gagal memuat data lokal';
    } else if (failure is FirestoreFailure) {
      return failure.message;
    } else {
      return 'Terjadi kesalahan tidak terduga';
    }
  }
}
