/// File: lib/features/profile/presentation/bloc/profile_event.dart
/// Events untuk Profile Bloc

import 'package:equatable/equatable.dart';

/// Base Event
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load User Stats Event
class LoadUserStats extends ProfileEvent {
  final String userId;

  const LoadUserStats(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Refresh User Stats Event
class RefreshUserStats extends ProfileEvent {
  final String userId;

  const RefreshUserStats(this.userId);

  @override
  List<Object?> get props => [userId];

  get event => null;
}

/// Update User Stats Event
class UpdateUserStats extends ProfileEvent {
  final String userId;
  final Map<String, dynamic> stats;

  const UpdateUserStats({
    required this.userId,
    required this.stats,
  });

  @override
  List<Object?> get props => [userId, stats];

  get event => null;
}

/// Load Achievements Event
class LoadAchievements extends ProfileEvent {
  final String userId;

  const LoadAchievements(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Unlock Achievement Event
class UnlockAchievement extends ProfileEvent {
  final String userId;
  final String achievementId;

  const UnlockAchievement({
    required this.userId,
    required this.achievementId,
  });

  @override
  List<Object?> get props => [userId, achievementId];

  get event => null;
}

/// Update Profile Picture Event
class UpdateProfilePicture extends ProfileEvent {
  final String userId;
  final String photoUrl;

  const UpdateProfilePicture({
    required this.userId,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [userId, photoUrl];
}

/// Update Username Event
class UpdateUsername extends ProfileEvent {
  final String userId;
  final String username;

  const UpdateUsername({
    required this.userId,
    required this.username,
  });

  @override
  List<Object?> get props => [userId, username];
}