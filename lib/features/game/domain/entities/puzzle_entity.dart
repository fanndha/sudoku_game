/// File: lib/features/game/domain/entities/puzzle_entity.dart
/// Entity untuk Sudoku puzzle

import 'package:equatable/equatable.dart';

/// Puzzle Entity - Represent complete Sudoku puzzle
class PuzzleEntity extends Equatable {
  final String id;                    // Unique puzzle ID
  final List<List<int?>> puzzle;      // 9x9 grid (null = empty cell)
  final List<List<int>> solution;     // 9x9 grid complete solution
  final String difficulty;            // easy, medium, hard, expert
  final int filledCells;              // Jumlah cell yang sudah terisi
  final DateTime createdAt;

  const PuzzleEntity({
    required this.id,
    required this.puzzle,
    required this.solution,
    required this.difficulty,
    required this.filledCells,
    required this.createdAt,
  });

  /// Get total empty cells
  int get emptyCells => 81 - filledCells;

  /// Get difficulty level (0-3)
  int get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 0;
      case 'medium':
        return 1;
      case 'hard':
        return 2;
      case 'expert':
        return 3;
      default:
        return 0;
    }
  }

  /// Check apakah puzzle valid (9x9)
  bool get isValid {
    return puzzle.length == 9 &&
        puzzle.every((row) => row.length == 9) &&
        solution.length == 9 &&
        solution.every((row) => row.length == 9);
  }

  /// Get value di posisi tertentu
  int? getValueAt(int row, int col) {
    if (row < 0 || row >= 9 || col < 0 || col >= 9) return null;
    return puzzle[row][col];
  }

  /// Get solution value di posisi tertentu
  int getSolutionAt(int row, int col) {
    if (row < 0 || row >= 9 || col < 0 || col >= 9) return 0;
    return solution[row][col];
  }

  /// Check apakah cell adalah fixed (initial puzzle)
  bool isFixedCell(int row, int col) {
    return getValueAt(row, col) != null;
  }

  /// Get all fixed cells positions
  List<List<int>> get fixedCellsPositions {
    final positions = <List<int>>[];
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (puzzle[row][col] != null) {
          positions.add([row, col]);
        }
      }
    }
    return positions;
  }

  @override
  List<Object?> get props => [
        id,
        puzzle,
        solution,
        difficulty,
        filledCells,
        createdAt,
      ];

  @override
  String toString() {
    return 'Puzzle(id: $id, difficulty: $difficulty, filled: $filledCells/81)';
  }
}