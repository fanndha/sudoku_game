/// File: lib/features/game/data/models/move_model.dart
/// Move model untuk data layer (extends MoveEntity)

import '../../domain/entities/move_entity.dart';

/// Move Model - Data Transfer Object
class MoveModel extends MoveEntity {
  const MoveModel({
    required super.row,
    required super.column,
    super.previousValue,
    super.newValue,
    super.previousNotes,
    super.newNotes,
    required super.timestamp,
    required super.type,
  });

  /// Create MoveModel from MoveEntity
  factory MoveModel.fromEntity(MoveEntity entity) {
    return MoveModel(
      row: entity.row,
      column: entity.column,
      previousValue: entity.previousValue,
      newValue: entity.newValue,
      previousNotes: entity.previousNotes,
      newNotes: entity.newNotes,
      timestamp: entity.timestamp,
      type: entity.type,
    );
  }

  /// Create MoveModel from JSON
  factory MoveModel.fromJson(Map<String, dynamic> json) {
    return MoveModel(
      row: json['row'] as int,
      column: json['column'] as int,
      previousValue: json['previousValue'] as int?,
      newValue: json['newValue'] as int?,
      previousNotes: (json['previousNotes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      newNotes: (json['newNotes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MoveType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MoveType.value,
      ),
    );
  }

  /// Convert MoveModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'column': column,
      'previousValue': previousValue,
      'newValue': newValue,
      'previousNotes': previousNotes,
      'newNotes': newNotes,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
    };
  }

  /// Create value move
  factory MoveModel.valueMove({
    required int row,
    required int column,
    int? previousValue,
    required int newValue,
  }) {
    return MoveModel(
      row: row,
      column: column,
      previousValue: previousValue,
      newValue: newValue,
      timestamp: DateTime.now(),
      type: MoveType.value,
    );
  }

  /// Create note move
  factory MoveModel.noteMove({
    required int row,
    required int column,
    List<int> previousNotes = const [],
    required List<int> newNotes,
  }) {
    return MoveModel(
      row: row,
      column: column,
      previousNotes: previousNotes,
      newNotes: newNotes,
      timestamp: DateTime.now(),
      type: MoveType.note,
    );
  }

  /// Create erase move
  factory MoveModel.eraseMove({
    required int row,
    required int column,
    int? previousValue,
    List<int> previousNotes = const [],
  }) {
    return MoveModel(
      row: row,
      column: column,
      previousValue: previousValue,
      newValue: null,
      previousNotes: previousNotes,
      newNotes: [],
      timestamp: DateTime.now(),
      type: MoveType.erase,
    );
  }

  /// Create hint move
  factory MoveModel.hintMove({
    required int row,
    required int column,
    int? previousValue,
    required int newValue,
  }) {
    return MoveModel(
      row: row,
      column: column,
      previousValue: previousValue,
      newValue: newValue,
      timestamp: DateTime.now(),
      type: MoveType.hint,
    );
  }
}