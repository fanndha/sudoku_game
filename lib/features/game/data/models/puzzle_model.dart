/// File: lib/features/game/data/models/puzzle_model.dart
/// Puzzle model untuk data layer (extends PuzzleEntity)

import '../../domain/entities/puzzle_entity.dart';

/// Puzzle Model - Data Transfer Object
class PuzzleModel extends PuzzleEntity {
  const PuzzleModel({
    required super.id,
    required super.puzzle,
    required super.solution,
    required super.difficulty,
    required super.filledCells,
    required super.createdAt,
  });

  /// Create PuzzleModel from PuzzleEntity
  factory PuzzleModel.fromEntity(PuzzleEntity entity) {
    return PuzzleModel(
      id: entity.id,
      puzzle: entity.puzzle,
      solution: entity.solution,
      difficulty: entity.difficulty,
      filledCells: entity.filledCells,
      createdAt: entity.createdAt,
    );
  }

  /// Create PuzzleModel from JSON
  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'] as String,
      puzzle: (json['puzzle'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((cell) => cell as int?)
              .toList())
          .toList(),
      solution: (json['solution'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((cell) => cell as int)
              .toList())
          .toList(),
      difficulty: json['difficulty'] as String,
      filledCells: json['filledCells'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert PuzzleModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puzzle': puzzle,
      'solution': solution,
      'difficulty': difficulty,
      'filledCells': filledCells,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create puzzle from raw data
  factory PuzzleModel.create({
    required String id,
    required List<List<int?>> puzzle,
    required List<List<int>> solution,
    required String difficulty,
  }) {
    // Count filled cells
    int filled = 0;
    for (final row in puzzle) {
      for (final cell in row) {
        if (cell != null) filled++;
      }
    }

    return PuzzleModel(
      id: id,
      puzzle: puzzle,
      solution: solution,
      difficulty: difficulty,
      filledCells: filled,
      createdAt: DateTime.now(),
    );
  }

  /// Copy with method
  PuzzleModel copyWith({
    String? id,
    List<List<int?>>? puzzle,
    List<List<int>>? solution,
    String? difficulty,
    int? filledCells,
    DateTime? createdAt,
  }) {
    return PuzzleModel(
      id: id ?? this.id,
      puzzle: puzzle ?? this.puzzle,
      solution: solution ?? this.solution,
      difficulty: difficulty ?? this.difficulty,
      filledCells: filledCells ?? this.filledCells,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'puzzle': puzzle,
      'solution': solution,
      'difficulty': difficulty,
      'filledCells': filledCells,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from Firestore
  factory PuzzleModel.fromFirestore(Map<String, dynamic> data) {
    return PuzzleModel(
      id: data['id'] as String,
      puzzle: (data['puzzle'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((cell) => cell as int?)
              .toList())
          .toList(),
      solution: (data['solution'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((cell) => cell as int)
              .toList())
          .toList(),
      difficulty: data['difficulty'] as String,
      filledCells: data['filledCells'] as int,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }
}