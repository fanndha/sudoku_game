/// File: lib/features/game/presentation/bloc/game_event.dart
/// Events untuk GameBloc

import 'package:equatable/equatable.dart';

/// Base class untuk semua Game Events
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk start new game
class GameStartNewEvent extends GameEvent {
  final String difficulty;

  const GameStartNewEvent({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];
}

/// Event untuk load saved game
class GameLoadEvent extends GameEvent {
  final String gameId;

  const GameLoadEvent({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}

/// Event untuk select cell
class GameSelectCellEvent extends GameEvent {
  final int cellIndex;

  const GameSelectCellEvent({required this.cellIndex});

  @override
  List<Object?> get props => [cellIndex];
}

/// Event untuk input number ke cell
class GameInputNumberEvent extends GameEvent {
  final int number;

  const GameInputNumberEvent({required this.number});

  @override
  List<Object?> get props => [number];
}

/// Event untuk erase cell value
class GameEraseCellEvent extends GameEvent {
  const GameEraseCellEvent();
}

/// Event untuk toggle note mode
class GameToggleNoteModeEvent extends GameEvent {
  const GameToggleNoteModeEvent();
}

/// Event untuk toggle note di cell
class GameToggleNoteEvent extends GameEvent {
  final int number;

  const GameToggleNoteEvent({required this.number});

  @override
  List<Object?> get props => [number];
}

/// Event untuk request hint
class GameRequestHintEvent extends GameEvent {
  const GameRequestHintEvent();
}

/// Event untuk undo move
class GameUndoEvent extends GameEvent {
  const GameUndoEvent();
}

/// Event untuk redo move
class GameRedoEvent extends GameEvent {
  const GameRedoEvent();
}

/// Event untuk pause game
class GamePauseEvent extends GameEvent {
  const GamePauseEvent();
}

/// Event untuk resume game
class GameResumeEvent extends GameEvent {
  const GameResumeEvent();
}

/// Event untuk save game
class GameSaveEvent extends GameEvent {
  final bool saveToFirestore;

  const GameSaveEvent({this.saveToFirestore = true});

  @override
  List<Object?> get props => [saveToFirestore];
}

/// Event untuk check if puzzle completed
class GameCheckCompletionEvent extends GameEvent {
  const GameCheckCompletionEvent();
}

/// Event untuk restart game (same puzzle)
class GameRestartEvent extends GameEvent {
  const GameRestartEvent();
}

/// Event untuk validate all cells
class GameValidateAllEvent extends GameEvent {
  const GameValidateAllEvent();
}

/// Event untuk update time elapsed
class GameUpdateTimeEvent extends GameEvent {
  final int seconds;

  const GameUpdateTimeEvent({required this.seconds});

  @override
  List<Object?> get props => [seconds];
}

/// Event untuk clear selection
class GameClearSelectionEvent extends GameEvent {
  const GameClearSelectionEvent();
}