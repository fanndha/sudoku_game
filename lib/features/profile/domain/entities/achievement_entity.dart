/// File: lib/features/profile/domain/entities/achievement_entity.dart
/// Entity untuk achievement

import 'package:equatable/equatable.dart';

/// Achievement Entity
class AchievementEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon; // Emoji or icon name
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int? progress;
  final int? target;
  final String category; // e.g., 'games', 'time', 'streak', 'special'
  final int points;

  const AchievementEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress,
    this.target,
    this.category = 'general',
    this.points = 0,
  });

  /// Get progress percentage
  double get progressPercentage {
    if (progress == null || target == null || target == 0) return 0.0;
    return (progress! / target!).clamp(0.0, 1.0);
  }

  /// Check if achievement is completed but not unlocked yet
  bool get isReadyToUnlock {
    if (isUnlocked) return false;
    if (progress == null || target == null) return false;
    return progress! >= target!;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        isUnlocked,
        unlockedAt,
        progress,
        target,
        category,
        points,
      ];

  @override
  String toString() {
    return 'AchievementEntity(id: $id, name: $name, isUnlocked: $isUnlocked, progress: $progress/$target)';
  }
}