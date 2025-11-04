/// File: lib/features/game/presentation/bloc/game_bloc.dart
/// Bloc untuk manage game state dan logic

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/features/game/domain/usecases/validate_puzzle.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/game_state_entity.dart';
import '../../domain/entities/cell_entity.dart';
import '../../domain/usecases/generate_puzzle.dart';
import '../../domain/usecases/get_hint.dart';
import '../../domain/usecases/save_game.dart';
import '../../domain/usecases/load_game.dart';
import '../../domain/usecases/check_completion.dart';
import '../../domain/usecases/get_possible_numbers.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/models/cell_model.dart';
import '../../data/models/move_model.dart';
import 'game_event.dart';
import 'game_state.dart';

/// GameBloc - Manage game state and logic
class GameBloc extends Bloc<GameEvent, GameState> {
  final GeneratePuzzle generatePuzzle;
  final ValidateMove validateMove;
  final GetHint getHint;
  final SaveGame saveGame;
  final LoadGame loadGame;
  final CheckCompletion checkCompletion;
  final GetPossibleNumbers getPossibleNumbers;

  GameBloc({
    required this.generatePuzzle,
    required this.validateMove,
    required this.getHint,
    required this.saveGame,
    required this.loadGame,
    required this.checkCompletion,
    required this.getPossibleNumbers,
  }) : super(const GameInitial()) {
    // Register event handlers
    on<GameStartNewEvent>(_onStartNew);
    on<GameLoadEvent>(_onLoad);
    on<GameSelectCellEvent>(_onSelectCell);
    on<GameInputNumberEvent>(_onInputNumber);
    on<GameEraseCellEvent>(_onEraseCell);
    on<GameToggleNoteModeEvent>(_onToggleNoteMode);
    on<GameToggleNoteEvent>(_onToggleNote);
    on<GameRequestHintEvent>(_onRequestHint);
    on<GameUndoEvent>(_onUndo);
    on<GameRedoEvent>(_onRedo);
    on<GamePauseEvent>(_onPause);
    on<GameResumeEvent>(_onResume);
    on<GameSaveEvent>(_onSave);
    on<GameCheckCompletionEvent>(_onCheckCompletion);
    on<GameRestartEvent>(_onRestart);
    on<GameValidateAllEvent>(_onValidateAll);
    on<GameUpdateTimeEvent>(_onUpdateTime);
    on<GameClearSelectionEvent>(_onClearSelection);
  }

  // ========== START NEW GAME ==========

  Future<void> _onStartNew(
    GameStartNewEvent event,
    Emitter<GameState> emit,
  ) async {
    logger.blocEvent('GameBloc', event);
    emit(const GameLoading(message: 'Membuat puzzle...'));

    final result = await generatePuzzle(
      GeneratePuzzleParams(difficulty: event.difficulty),
    );

    result.fold(
      (failure) {
        logger.e('Generate puzzle failed: ${failure.message}', tag: 'GameBloc');
        emit(GameError(message: _mapFailureToMessage(failure)));
      },
      (puzzle) {
        // Create new game state
        final gameState = GameStateModel.newGame(
          gameId: 'game_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'user_temp', // Will be set from AuthBloc
          puzzle: puzzle as PuzzleModel,
        );

        logger.i('Game started: ${gameState.gameId}', tag: 'GameBloc');
        emit(GameLoaded(gameState: gameState));

        // Auto-save
        add(const GameSaveEvent(saveToFirestore: false));
      },
    );
  }

  // ========== LOAD GAME ==========

  Future<void> _onLoad(
    GameLoadEvent event,
    Emitter<GameState> emit,
  ) async {
    logger.blocEvent('GameBloc', event);
    emit(const GameLoading(message: 'Memuat game...'));

    final result = await loadGame(
      LoadGameParams(gameId: event.gameId),
    );

    result.fold(
      (failure) {
        logger.e('Load game failed: ${failure.message}', tag: 'GameBloc');
        emit(GameError(message: _mapFailureToMessage(failure)));
      },
      (gameState) {
        if (gameState == null) {
          logger.w('Game not found: ${event.gameId}', tag: 'GameBloc');
          emit(const GameNotFound());
        } else {
          logger.i('Game loaded: ${gameState.gameId}', tag: 'GameBloc');
          emit(GameLoaded(gameState: gameState));
        }
      },
    );
  }

  // ========== SELECT CELL ==========

  Future<void> _onSelectCell(
    GameSelectCellEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    final row = event.cellIndex ~/ 9;
    final col = event.cellIndex % 9;
    final cell = currentState.board[row][col];

    // Don't select fixed cells
    if (cell.isFixed) return;

    final updatedState = currentState.copyWith(
      selectedCellIndex: event.cellIndex,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== INPUT NUMBER ==========

  Future<void> _onInputNumber(
    GameInputNumberEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    
    // Check if cell selected
    if (currentState.selectedCellIndex == null) return;

    final row = currentState.selectedCellIndex! ~/ 9;
    final col = currentState.selectedCellIndex! % 9;
    final cell = currentState.board[row][col] as CellModel;

    // Don't modify fixed cells
    if (cell.isFixed) return;

    // If note mode, toggle note instead
    if (currentState.isNoteMode) {
      add(GameToggleNoteEvent(number: event.number));
      return;
    }

    // Get current board for validation
    final boardForValidation = _getBoardAsNullableList(currentState.board);

    // Validate move
    final validationResult = await validateMove(
      ValidateMoveParams(
        board: boardForValidation,
        row: row,
        col: col,
        value: event.number,
      ),
    );

    final isValid = validationResult.getOrElse(() => false);

    // Create move
    final move = MoveModel.valueMove(
      row: row,
      column: col,
      previousValue: cell.value,
      newValue: event.number,
    );

    // Update cell
    final updatedCell = cell.setValue(event.number).setError(!isValid);
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    // Update move history
    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    // Update game state
    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
      errorsMade: isValid ? null : currentState.errorsMade + 1,
    );

    emit(GameLoaded(gameState: updatedState));

    // Auto-save
    add(const GameSaveEvent(saveToFirestore: false));

    // Check completion
    add(const GameCheckCompletionEvent());
  }

  // ========== ERASE CELL ==========

  Future<void> _onEraseCell(
    GameEraseCellEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    
    if (currentState.selectedCellIndex == null) return;

    final row = currentState.selectedCellIndex! ~/ 9;
    final col = currentState.selectedCellIndex! % 9;
    final cell = currentState.board[row][col] as CellModel;

    if (cell.isFixed || cell.isEmpty) return;

    // Create move
    final move = MoveModel.eraseMove(
      row: row,
      column: col,
      previousValue: cell.value,
      previousNotes: cell.notes,
    );

    // Update cell
    final updatedCell = cell.clearValue();
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    // Update move history
    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    // Update game state
    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
    );

    emit(GameLoaded(gameState: updatedState));

    // Auto-save
    add(const GameSaveEvent(saveToFirestore: false));
  }

  // ========== TOGGLE NOTE MODE ==========

  Future<void> _onToggleNoteMode(
    GameToggleNoteModeEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    final updatedState = currentState.copyWith(
      isNoteMode: !currentState.isNoteMode,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== TOGGLE NOTE ==========

  Future<void> _onToggleNote(
    GameToggleNoteEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    
    if (currentState.selectedCellIndex == null) return;

    final row = currentState.selectedCellIndex! ~/ 9;
    final col = currentState.selectedCellIndex! % 9;
    final cell = currentState.board[row][col] as CellModel;

    if (cell.isFixed || cell.isFilled) return;

    // Create move
    final move = MoveModel.noteMove(
      row: row,
      column: col,
      previousNotes: cell.notes,
      newNotes: cell.toggleNote(event.number).notes,
    );

    // Update cell
    final updatedCell = cell.toggleNote(event.number);
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    // Update move history
    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    // Update game state
    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== HELPER METHODS ==========

  /// Convert board to nullable list for validation
  List<List<int?>> _getBoardAsNullableList(List<List<CellEntity>> board) {
    return board.map((row) => row.map((cell) => cell.value).toList()).toList();
  }

  /// Update board with new cell
  List<List<CellEntity>> _updateBoard(
    List<List<CellEntity>> board,
    int row,
    int col,
    CellEntity newCell,
  ) {
    final newBoard = List<List<CellEntity>>.from(
      board.map((r) => List<CellEntity>.from(r)),
    );
    newBoard[row][col] = newCell;
    return newBoard;
  }

  /// Map Failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is GameFailure) {
      return failure.message;
    } else if (failure is PuzzleGenerationFailure) {
      return 'Gagal membuat puzzle. Silakan coba lagi.';
    } else {
      return failure.message;
    }
  }

  @override
  void onEvent(GameEvent event) {
    super.onEvent(event);
    logger.blocEvent('GameBloc', event);
  }

  @override
  void onChange(Change<GameState> change) {
    super.onChange(change);
    logger.blocState('GameBloc', change.nextState);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    logger.e('GameBloc Error', error: error, stackTrace: stackTrace, tag: 'GameBloc');
    super.onError(error, stackTrace);
  }
}