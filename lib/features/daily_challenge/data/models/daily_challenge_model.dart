/// File: lib/features/daily_challenge/data/models/daily_challenge_model.dart
/// Model untuk daily challenge

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/daily_challenge_entity.dart';

/// Daily Challenge Model
class DailyChallengeModel extends DailyChallengeEntity {
  const DailyChallengeModel({
    required super.id,
    required super.date,
    required super.difficulty,
    required super.puzzle,
    required super.solution,
    super.participantsCount,
    super.completionsCount,
    super.userBestTime,
    super.isCompleted,
    super.completedAt,
    super.userScore,
  });

  /// Create from Entity
  factory DailyChallengeModel.fromEntity(DailyChallengeEntity entity) {
    return DailyChallengeModel(
      id: entity.id,
      date: entity.date,
      difficulty: entity.difficulty,
      puzzle: entity.puzzle,
      solution: entity.solution,
      participantsCount: entity.participantsCount,
      completionsCount: entity.completionsCount,
      userBestTime: entity.userBestTime,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      userScore: entity.userScore,
    );
  }

  /// Create from JSON
  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeModel(
      id: json['id'] as String,
      date: json['date'] as String,
      difficulty: json['difficulty'] as String,
      puzzle: _parsePuzzle(json['puzzle']),
      solution: _parsePuzzle(json['solution']),
      participantsCount: json['participantsCount'] as int? ?? 0,
      completionsCount: json['completionsCount'] as int? ?? 0,
      userBestTime: json['userBestTime'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      userScore: json['userScore'] as int?,
    );
  }

  /// Create from Firestore
  factory DailyChallengeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return DailyChallengeModel(
      id: doc.id,
      date: data['date'] as String,
      difficulty: data['difficulty'] as String,
      puzzle: _parsePuzzle(data['puzzle']),
      solution: _parsePuzzle(data['solution']),
      participantsCount: data['participantsCount'] as int? ?? 0,
      completionsCount: data['completionsCount'] as int? ?? 0,
      userBestTime: data['userBestTime'] as String?,
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      userScore: data['userScore'] as int?,
    );
  }

  /// Parse puzzle from dynamic data
  static List<List<int>> _parsePuzzle(dynamic puzzleData) {
    if (puzzleData is List) {
      return puzzleData.map((row) {
        if (row is List) {
          return row.map((cell) => cell as int).toList();
        }
        throw Exception('Invalid puzzle format');
      }).toList();
    }
    throw Exception('Invalid puzzle format');
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'difficulty': difficulty,
      'puzzle': puzzle,
      'solution': solution,
      'participantsCount': participantsCount,
      'completionsCount': completionsCount,
      'userBestTime': userBestTime,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'userScore': userScore,
    };
  }

  /// Convert to Firestore (without user-specific data)
  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'difficulty': difficulty,
      'puzzle': puzzle,
      'solution': solution,
      'participantsCount': participantsCount,
      'completionsCount': completionsCount,
    };
  }

  /// Convert to Firestore for user completion
  Map<String, dynamic> toUserCompletion() {
    return {
      'challengeId': id,
      'date': date,
      'difficulty': difficulty,
      'userBestTime': userBestTime,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'userScore': userScore,
    };
  }

  /// Copy with
  DailyChallengeModel copyWith({
    String? id,
    String? date,
    String? difficulty,
    List<List<int>>? puzzle,
    List<List<int>>? solution,
    int? participantsCount,
    int? completionsCount,
    String? userBestTime,
    bool? isCompleted,
    DateTime? completedAt,
    int? userScore,
  }) {
    return DailyChallengeModel(
      id: id ?? this.id,
      date: date ?? this.date,
      difficulty: difficulty ?? this.difficulty,
      puzzle: puzzle ?? this.puzzle,
      solution: solution ?? this.solution,
      participantsCount: participantsCount ?? this.participantsCount,
      completionsCount: completionsCount ?? this.completionsCount,
      userBestTime: userBestTime ?? this.userBestTime,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      userScore: userScore ?? this.userScore,
    );
  }
}