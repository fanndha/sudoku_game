/// File: lib/features/game/presentation/bloc/game_state.dart
/// States untuk GameBloc

import 'package:equatable/equatable.dart';
import '../../domain/entities/game_state_entity.dart';

/// Base class untuk semua Game States
abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class GameInitial extends GameState {
  const GameInitial();
}

/// Loading state - saat generate/load puzzle
class GameLoading extends GameState {
  final String? message;

  const GameLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Game loaded and ready to play
class GameLoaded extends GameState {
  final GameStateEntity gameState;

  const GameLoaded({required this.gameState});

  @override
  List<Object?> get props => [gameState];

  /// Helper getters
  bool get canUndo => gameState.canUndo;
  bool get canRedo => gameState.canRedo;
  bool get isNoteMode => gameState.isNoteMode;
  bool get isCompleted => gameState.isCompleted;
  bool get isPaused => gameState.status == GameStatus.paused;
  int get hintsRemaining => gameState.hintsRemaining;
  double get progressPercentage => gameState.progressPercentage;
  String get difficulty => gameState.difficulty;
}

/// Game paused
class GamePaused extends GameState {
  final GameStateEntity gameState;

  const GamePaused({required this.gameState});

  @override
  List<Object?> get props => [gameState];
}

/// Game completed
class GameCompleted extends GameState {
  final GameStateEntity gameState;
  final int finalTime;
  final int hintsUsed;
  final int errorsMade;
  final double accuracy;

  const GameCompleted({
    required this.gameState,
    required this.finalTime,
    required this.hintsUsed,
    required this.errorsMade,
    required this.accuracy,
  });

  @override
  List<Object?> get props => [
        gameState,
        finalTime,
        hintsUsed,
        errorsMade,
        accuracy,
      ];
}

/// Game saved successfully
class GameSaved extends GameState {
  final GameStateEntity gameState;

  const GameSaved({required this.gameState});

  @override
  List<Object?> get props => [gameState];
}

/// Hint shown - temporary state
class GameHintShown extends GameState {
  final GameStateEntity gameState;
  final int row;
  final int col;
  final int hintValue;

  const GameHintShown({
    required this.gameState,
    required this.row,
    required this.col,
    required this.hintValue,
  });

  @override
  List<Object?> get props => [gameState, row, col, hintValue];
}

/// No hints remaining
class GameNoHintsRemaining extends GameState {
  final GameStateEntity gameState;

  const GameNoHintsRemaining({required this.gameState});

  @override
  List<Object?> get props => [gameState];
}

/// Error state
class GameError extends GameState {
  final String message;

  const GameError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Game not found (when loading)
class GameNotFound extends GameState {
  const GameNotFound();
}