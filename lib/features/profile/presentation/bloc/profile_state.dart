/// File: lib/features/profile/presentation/bloc/profile_state.dart
/// States untuk Profile Bloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/stats_entity.dart';

/// Base State
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading State
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Loaded State
class ProfileLoaded extends ProfileState {
  final StatsEntity stats;
  final List<AchievementEntity> achievements;

  const ProfileLoaded({
    required this.stats,
    required this.achievements,
  });

  @override
  List<Object?> get props => [stats, achievements];

  /// Get unlocked achievements
  List<AchievementEntity> get unlockedAchievements {
    return achievements.where((a) => a.isUnlocked).toList();
  }

  /// Get locked achievements
  List<AchievementEntity> get lockedAchievements {
    return achievements.where((a) => !a.isUnlocked).toList();
  }

  /// Get achievement progress percentage
  double get achievementProgress {
    if (achievements.isEmpty) return 0;
    return unlockedAchievements.length / achievements.length;
  }

  /// Copy with
  ProfileLoaded copyWith({
    StatsEntity? stats,
    List<AchievementEntity>? achievements,
  }) {
    return ProfileLoaded(
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
    );
  }
}

/// Error State
class ProfileError extends ProfileState {
  final String message;
  final String? code;

  const ProfileError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Updating State
class ProfileUpdating extends ProfileState {
  final StatsEntity currentStats;
  final List<AchievementEntity> currentAchievements;

  const ProfileUpdating({
    required this.currentStats,
    required this.currentAchievements,
  });

  @override
  List<Object?> get props => [currentStats, currentAchievements];
}

/// Update Success State
class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Update Error State
class ProfileUpdateError extends ProfileState {
  final String message;
  final StatsEntity currentStats;
  final List<AchievementEntity> currentAchievements;

  const ProfileUpdateError({
    required this.message,
    required this.currentStats,
    required this.currentAchievements,
  });

  @override
  List<Object?> get props => [message, currentStats, currentAchievements];
}

/// Achievement Unlocked State (for showing popup)
class AchievementUnlocked extends ProfileState {
  final AchievementEntity achievement;
  final StatsEntity currentStats;
  final List<AchievementEntity> currentAchievements;

  const AchievementUnlocked({
    required this.achievement,
    required this.currentStats,
    required this.currentAchievements,
  });

  @override
  List<Object?> get props => [achievement, currentStats, currentAchievements];
}