/// File: lib/features/game/data/models/game_state_model.dart
/// Game State model untuk data layer (extends GameStateEntity)

import '../../domain/entities/game_state_entity.dart';
import '../../domain/entities/cell_entity.dart';
import '../../domain/entities/move_entity.dart';
import 'cell_model.dart';
import 'move_model.dart';
import 'puzzle_model.dart';

/// Game State Model - Data Transfer Object
class GameStateModel extends GameStateEntity {
  const GameStateModel({
    required super.gameId,
    required super.userId,
    required super.puzzle,
    required super.board,
    super.moveHistory,
    super.currentMoveIndex,
    super.selectedCellIndex,
    super.isNoteMode,
    super.isCompleted,
    super.hintsUsed,
    super.hintsRemaining,
    required super.timeElapsed,
    required super.startTime,
    super.completedTime,
    super.errorsMade,
    super.status,
  });

  /// Create GameStateModel from GameStateEntity
  factory GameStateModel.fromEntity(GameStateEntity entity) {
    return GameStateModel(
      gameId: entity.gameId,
      userId: entity.userId,
      puzzle: entity.puzzle,
      board: entity.board,
      moveHistory: entity.moveHistory,
      currentMoveIndex: entity.currentMoveIndex,
      selectedCellIndex: entity.selectedCellIndex,
      isNoteMode: entity.isNoteMode,
      isCompleted: entity.isCompleted,
      hintsUsed: entity.hintsUsed,
      hintsRemaining: entity.hintsRemaining,
      timeElapsed: entity.timeElapsed,
      startTime: entity.startTime,
      completedTime: entity.completedTime,
      errorsMade: entity.errorsMade,
      status: entity.status,
    );
  }

  /// Create GameStateModel from JSON
  factory GameStateModel.fromJson(Map<String, dynamic> json) {
    return GameStateModel(
      gameId: json['gameId'] as String,
      userId: json['userId'] as String,
      puzzle: PuzzleModel.fromJson(json['puzzle'] as Map<String, dynamic>),
      board: (json['board'] as List<dynamic>)
          .map((row) => (row as List<dynamic>)
              .map((cell) => CellModel.fromJson(cell as Map<String, dynamic>))
              .toList())
          .toList(),
      moveHistory: (json['moveHistory'] as List<dynamic>?)
              ?.map((move) => MoveModel.fromJson(move as Map<String, dynamic>))
              .toList() ??
          [],
      currentMoveIndex: json['currentMoveIndex'] as int? ?? -1,
      selectedCellIndex: json['selectedCellIndex'] as int?,
      isNoteMode: json['isNoteMode'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      hintsUsed: json['hintsUsed'] as int? ?? 0,
      hintsRemaining: json['hintsRemaining'] as int? ?? 3,
      timeElapsed: json['timeElapsed'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      completedTime: json['completedTime'] != null
          ? DateTime.parse(json['completedTime'] as String)
          : null,
      errorsMade: json['errorsMade'] as int? ?? 0,
      status: GameStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GameStatus.playing,
      ),
    );
  }

  /// Convert GameStateModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'userId': userId,
      'puzzle': (puzzle as PuzzleModel).toJson(),
      'board': board
          .map((row) => row
              .map((cell) => (cell as CellModel).toJson())
              .toList())
          .toList(),
      'moveHistory': moveHistory
          .map((move) => (move as MoveModel).toJson())
          .toList(),
      'currentMoveIndex': currentMoveIndex,
      'selectedCellIndex': selectedCellIndex,
      'isNoteMode': isNoteMode,
      'isCompleted': isCompleted,
      'hintsUsed': hintsUsed,
      'hintsRemaining': hintsRemaining,
      'timeElapsed': timeElapsed,
      'startTime': startTime.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
      'errorsMade': errorsMade,
      'status': status.name,
    };
  }

  /// Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return toJson(); // Same format for now
  }

  /// Create from Firestore
  factory GameStateModel.fromFirestore(Map<String, dynamic> data) {
    return GameStateModel.fromJson(data);
  }

  /// Create new game state from puzzle
  factory GameStateModel.newGame({
    required String gameId,
    required String userId,
    required PuzzleModel puzzle,
  }) {
    // Initialize board from puzzle
    final board = List.generate(
      9,
      (row) => List.generate(
        9,
        (col) {
          final value = puzzle.puzzle[row][col];
          if (value != null) {
            return CellModel.fixed(row, col, value);
          } else {
            return CellModel.empty(row, col);
          }
        },
      ),
    );

    return GameStateModel(
      gameId: gameId,
      userId: userId,
      puzzle: puzzle,
      board: board,
      moveHistory: [],
      currentMoveIndex: -1,
      selectedCellIndex: null,
      isNoteMode: false,
      isCompleted: false,
      hintsUsed: 0,
      hintsRemaining: 3,
      timeElapsed: 0,
      startTime: DateTime.now(),
      errorsMade: 0,
      status: GameStatus.playing,
    );
  }

  /// Copy with method
  GameStateModel copyWith({
    String? gameId,
    String? userId,
    PuzzleModel? puzzle,
    List<List<CellEntity>>? board,
    List<MoveEntity>? moveHistory,
    int? currentMoveIndex,
    int? selectedCellIndex,
    bool? clearSelectedCell,
    bool? isNoteMode,
    bool? isCompleted,
    int? hintsUsed,
    int? hintsRemaining,
    int? timeElapsed,
    DateTime? startTime,
    DateTime? completedTime,
    int? errorsMade,
    GameStatus? status,
  }) {
    return GameStateModel(
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      puzzle: puzzle ?? this.puzzle,
      board: board ?? this.board,
      moveHistory: moveHistory ?? this.moveHistory,
      currentMoveIndex: currentMoveIndex ?? this.currentMoveIndex,
      selectedCellIndex: clearSelectedCell == true
          ? null
          : (selectedCellIndex ?? this.selectedCellIndex),
      isNoteMode: isNoteMode ?? this.isNoteMode,
      isCompleted: isCompleted ?? this.isCompleted,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      startTime: startTime ?? this.startTime,
      completedTime: completedTime ?? this.completedTime,
      errorsMade: errorsMade ?? this.errorsMade,
      status: status ?? this.status,
    );
  }
}