/// File: lib/features/game/domain/entities/game_state_entity.dart
/// Entity untuk track keseluruhan game state

import 'package:equatable/equatable.dart';
import 'cell_entity.dart';
import 'move_entity.dart';
import 'puzzle_entity.dart';

/// Game State Entity - Complete game state
class GameStateEntity extends Equatable {
  final String gameId;
  final String userId;
  final PuzzleEntity puzzle;
  final List<List<CellEntity>> board;  // 9x9 current board state
  final List<MoveEntity> moveHistory;  // History untuk undo/redo
  final int currentMoveIndex;          // Current position di history
  final int? selectedCellIndex;        // Index cell yang dipilih (0-80)
  final bool isNoteMode;               // Mode catatan aktif atau tidak
  final bool isCompleted;
  final int hintsUsed;
  final int hintsRemaining;            // Hint yang tersisa
  final int timeElapsed;               // Detik
  final DateTime startTime;
  final DateTime? completedTime;
  final int errorsMade;
  final GameStatus status;

  const GameStateEntity({
    required this.gameId,
    required this.userId,
    required this.puzzle,
    required this.board,
    this.moveHistory = const [],
    this.currentMoveIndex = -1,
    this.selectedCellIndex,
    this.isNoteMode = false,
    this.isCompleted = false,
    this.hintsUsed = 0,
    this.hintsRemaining = 3,
    required this.timeElapsed,
    required this.startTime,
    this.completedTime,
    this.errorsMade = 0,
    this.status = GameStatus.playing,
  });

  /// Check apakah ada cell yang dipilih
  bool get hasCellSelected => selectedCellIndex != null;

  /// Get selected cell
  CellEntity? get selectedCell {
    if (selectedCellIndex == null) return null;
    final row = selectedCellIndex! ~/ 9;
    final col = selectedCellIndex! % 9;
    return board[row][col];
  }

  /// Check apakah bisa undo
  bool get canUndo => currentMoveIndex >= 0;

  /// Check apakah bisa redo
  bool get canRedo => currentMoveIndex < moveHistory.length - 1;

  /// Get total cells filled (excluding fixed)
  int get filledCells {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell.isFilled && !cell.isFixed) {
          count++;
        }
      }
    }
    return count;
  }

  /// Get total empty cells
  int get emptyCells {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell.isEmpty && !cell.isFixed) {
          count++;
        }
      }
    }
    return count;
  }

  /// Get progress percentage
  double get progressPercentage {
    final total = 81 - puzzle.filledCells; // Total cells to fill
    if (total == 0) return 100.0;
    return (filledCells / total * 100).clamp(0.0, 100.0);
  }

  /// Check apakah game sudah selesai
  bool get isFinished => isCompleted || status == GameStatus.completed;

  /// Get accuracy (correct moves / total moves)
  double get accuracy {
    if (moveHistory.isEmpty) return 100.0;
    final correctMoves = moveHistory.length - errorsMade;
    return (correctMoves / moveHistory.length * 100).clamp(0.0, 100.0);
  }

  /// Get difficulty
  String get difficulty => puzzle.difficulty;

  @override
  List<Object?> get props => [
        gameId,
        userId,
        puzzle,
        board,
        moveHistory,
        currentMoveIndex,
        selectedCellIndex,
        isNoteMode,
        isCompleted,
        hintsUsed,
        hintsRemaining,
        timeElapsed,
        startTime,
        completedTime,
        errorsMade,
        status,
      ];

  @override
  String toString() {
    return 'GameState(id: $gameId, status: $status, progress: ${progressPercentage.toStringAsFixed(1)}%)';
  }
}

/// Enum untuk game status
enum GameStatus {
  playing,    // Sedang bermain
  paused,     // Dipause
  completed,  // Selesai
  abandoned,  // Ditinggalkan/tidak diselesaikan
}