/// File: lib/features/game/domain/entities/move_entity.dart
/// Entity untuk track setiap move yang dibuat player

import 'package:equatable/equatable.dart';

/// Move Entity - Represent satu langkah yang dibuat player
/// Untuk undo/redo functionality
class MoveEntity extends Equatable {
  final int row;
  final int column;
  final int? previousValue;  // Nilai sebelumnya (null jika kosong)
  final int? newValue;       // Nilai baru (null jika di-erase)
  final List<int> previousNotes; // Notes sebelumnya
  final List<int> newNotes;      // Notes baru
  final DateTime timestamp;
  final MoveType type;

  const MoveEntity({
    required this.row,
    required this.column,
    this.previousValue,
    this.newValue,
    this.previousNotes = const [],
    this.newNotes = const [],
    required this.timestamp,
    required this.type,
  });

  /// Get cell index
  int get cellIndex => row * 9 + column;

  /// Check apakah move ini adalah input angka
  bool get isValueMove => type == MoveType.value;

  /// Check apakah move ini adalah notes
  bool get isNoteMove => type == MoveType.note;

  /// Check apakah move ini adalah erase
  bool get isEraseMove => newValue == null && previousValue != null;

  @override
  List<Object?> get props => [
        row,
        column,
        previousValue,
        newValue,
        previousNotes,
        newNotes,
        timestamp,
        type,
      ];

  @override
  String toString() {
    return 'Move([$row,$column] $previousValue -> $newValue, type: $type)';
  }
}

/// Enum untuk tipe move
enum MoveType {
  value,  // Input angka
  note,   // Input note
  erase,  // Hapus angka/note
  hint,   // Dari hint
}