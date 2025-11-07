/// File: lib/features/profile/data/models/achievement_model.dart
/// Model untuk achievement

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/achievement_entity.dart';

/// Achievement Model
class AchievementModel extends AchievementEntity {
  const AchievementModel({
    required super.id,
    required super.name,
    required super.description,
    required super.icon,
    super.isUnlocked,
    super.unlockedAt,
    super.progress,
    super.target,
    super.category,
    super.points,
  });

  /// Create from Entity
  factory AchievementModel.fromEntity(AchievementEntity entity) {
    return AchievementModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      icon: entity.icon,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt,
      progress: entity.progress,
      target: entity.target,
      category: entity.category,
      points: entity.points,
    );
  }

  /// Create from JSON
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progress: json['progress'] as int?,
      target: json['target'] as int?,
      category: json['category'] as String? ?? 'general',
      points: json['points'] as int? ?? 0,
    );
  }

  /// Create from Firestore
  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return AchievementModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String,
      icon: data['icon'] as String,
      isUnlocked: data['isUnlocked'] as bool? ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
      progress: data['progress'] as int?,
      target: data['target'] as int?,
      category: data['category'] as String? ?? 'general',
      points: data['points'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
      'target': target,
      'category': category,
      'points': points,
    };
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt != null
          ? Timestamp.fromDate(unlockedAt!)
          : null,
      'progress': progress,
      'target': target,
      'category': category,
      'points': points,
    };
  }

  /// Copy with
  AchievementModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? progress,
    int? target,
    String? category,
    int? points,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      category: category ?? this.category,
      points: points ?? this.points,
    );
  }
}