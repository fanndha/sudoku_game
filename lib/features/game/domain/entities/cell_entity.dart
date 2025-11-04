/// File: lib/features/game/domain/entities/cell_entity.dart
/// Entity untuk single cell di Sudoku board

import 'package:equatable/equatable.dart';

/// Cell Entity - Represent satu kotak di Sudoku board
class CellEntity extends Equatable {
  final int row;        // 0-8
  final int column;     // 0-8
  final int? value;     // 1-9 atau null jika kosong
  final bool isFixed;   // true jika angka initial (tidak bisa diubah)
  final bool isError;   // true jika ada conflict
  final List<int> notes; // Catatan angka kandidat (1-9)

  const CellEntity({
    required this.row,
    required this.column,
    this.value,
    this.isFixed = false,
    this.isError = false,
    this.notes = const [],
  });

  /// Get cell index (0-80) dari row dan column
  int get index => row * 9 + column;

  /// Get box index (0-8) - kotak 3x3
  int get boxIndex => (row ~/ 3) * 3 + (column ~/ 3);

  /// Check apakah cell kosong
  bool get isEmpty => value == null;

  /// Check apakah cell terisi
  bool get isFilled => value != null;

  /// Check apakah cell bisa diubah (bukan fixed)
  bool get isEditable => !isFixed;

  /// Check apakah cell punya notes
  bool get hasNotes => notes.isNotEmpty;

  @override
  List<Object?> get props => [row, column, value, isFixed, isError, notes];

  @override
  String toString() {
    return 'Cell([$row,$column] value: $value, fixed: $isFixed, error: $isError)';
  }
}