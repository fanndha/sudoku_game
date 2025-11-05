/// File: lib/features/game/presentation/bloc/game_bloc.dart
/// Bloc untuk manage game state dan logic (COMPLETE VERSION)

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/features/game/domain/entities/move_entity.dart';
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
        final gameState = GameStateModel.newGame(
          gameId: 'game_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'user_temp',
          puzzle: puzzle as PuzzleModel,
        );

        logger.i('Game started: ${gameState.gameId}', tag: 'GameBloc');
        emit(GameLoaded(gameState: gameState));

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
    
    if (currentState.selectedCellIndex == null) return;

    final row = currentState.selectedCellIndex! ~/ 9;
    final col = currentState.selectedCellIndex! % 9;
    final cell = currentState.board[row][col] as CellModel;

    if (cell.isFixed) return;

    if (currentState.isNoteMode) {
      add(GameToggleNoteEvent(number: event.number));
      return;
    }

    final boardForValidation = _getBoardAsNullableList(currentState.board);

    final validationResult = await validateMove(
      ValidateMoveParams(
        board: boardForValidation,
        row: row,
        col: col,
        value: event.number,
      ),
    );

    final isValid = validationResult.getOrElse(() => false);

    final move = MoveModel.valueMove(
      row: row,
      column: col,
      previousValue: cell.value,
      newValue: event.number,
    );

    final updatedCell = cell.setValue(event.number).setError(!isValid);
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
      errorsMade: isValid ? null : currentState.errorsMade + 1,
    );

    emit(GameLoaded(gameState: updatedState));

    add(const GameSaveEvent(saveToFirestore: false));
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

    final move = MoveModel.eraseMove(
      row: row,
      column: col,
      previousValue: cell.value,
      previousNotes: cell.notes,
    );

    final updatedCell = cell.clearValue();
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
    );

    emit(GameLoaded(gameState: updatedState));

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

    final move = MoveModel.noteMove(
      row: row,
      column: col,
      previousNotes: cell.notes,
      newNotes: cell.toggleNote(event.number).notes,
    );

    final updatedCell = cell.toggleNote(event.number);
    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    final updatedHistory = [
      ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
      move,
    ];

    final updatedState = currentState.copyWith(
      board: updatedBoard,
      moveHistory: updatedHistory,
      currentMoveIndex: updatedHistory.length - 1,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== REQUEST HINT ==========

  Future<void> _onRequestHint(
    GameRequestHintEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    // Check hints remaining
    if (currentState.hintsRemaining <= 0) {
      emit(GameNoHintsRemaining(gameState: currentState));
      Future.delayed(const Duration(seconds: 1), () {
        if (!isClosed && state is GameNoHintsRemaining) {
          emit(GameLoaded(gameState: currentState));
        }
      });
      return;
    }

    if (currentState.selectedCellIndex == null) return;

    final row = currentState.selectedCellIndex! ~/ 9;
    final col = currentState.selectedCellIndex! % 9;
    final cell = currentState.board[row][col];

    if (cell.isFixed || cell.isFilled) return;

    final boardForHint = _getBoardAsNullableList(currentState.board);
    final solution = _getSolutionAsList(currentState.puzzle);

    final hintResult = await getHint(
      GetHintParams(
        currentBoard: boardForHint,
        solution: solution,
        row: row,
        col: col, board: [],
      ),
    );

    hintResult.fold(
      (failure) {
        logger.e('Get hint failed: ${failure.message}', tag: 'GameBloc');
        emit(GameError(message: _mapFailureToMessage(failure)));
      },
      (hintValue) {
        final move = MoveModel.hintMove(
          row: row,
          column: col,
          previousValue: cell.value,
          newValue: hintValue,
        );

        final updatedCell = (cell as CellModel).setValue(hintValue);
        final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

        final updatedHistory = [
          ...currentState.moveHistory.take(currentState.currentMoveIndex + 1),
          move,
        ];

        final updatedState = currentState.copyWith(
          board: updatedBoard,
          moveHistory: updatedHistory,
          currentMoveIndex: updatedHistory.length - 1,
          hintsUsed: currentState.hintsUsed + 1,
          hintsRemaining: currentState.hintsRemaining - 1,
        );

        emit(GameHintShown(
          gameState: updatedState,
          row: row,
          col: col,
          hintValue: hintValue,
        ));

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            emit(GameLoaded(gameState: updatedState));
            add(const GameSaveEvent(saveToFirestore: false));
            add(const GameCheckCompletionEvent());
          }
        });
      },
    );
  }

  // ========== UNDO ==========

  Future<void> _onUndo(
    GameUndoEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    if (!currentState.canUndo) return;

    final move = currentState.moveHistory[currentState.currentMoveIndex];
    final row = move.row;
    final col = move.column;
    final cell = currentState.board[row][col] as CellModel;

    CellModel updatedCell;
    if (move.type == MoveType.note) {
      updatedCell = cell.copyWith(notes: move.previousNotes);
    } else {
      updatedCell = cell.copyWith(
        value: move.previousValue,
        isError: false,
        notes: move.previousNotes,
      );
    }

    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    final updatedState = currentState.copyWith(
      board: updatedBoard,
      currentMoveIndex: currentState.currentMoveIndex - 1,
    );

    emit(GameLoaded(gameState: updatedState));

    add(const GameSaveEvent(saveToFirestore: false));
  }

  // ========== REDO ==========

  Future<void> _onRedo(
    GameRedoEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    if (!currentState.canRedo) return;

    final move = currentState.moveHistory[currentState.currentMoveIndex + 1];
    final row = move.row;
    final col = move.column;
    final cell = currentState.board[row][col] as CellModel;

    CellModel updatedCell;
    if (move.type == MoveType.note) {
      updatedCell = cell.copyWith(notes: move.newNotes);
    } else {
      updatedCell = cell.copyWith(
        value: move.newValue,
        notes: move.newNotes,
      );
    }

    final updatedBoard = _updateBoard(currentState.board, row, col, updatedCell);

    final updatedState = currentState.copyWith(
      board: updatedBoard,
      currentMoveIndex: currentState.currentMoveIndex + 1,
    );

    emit(GameLoaded(gameState: updatedState));

    add(const GameSaveEvent(saveToFirestore: false));
  }

  // ========== PAUSE ==========

  Future<void> _onPause(
    GamePauseEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    final updatedState = currentState.copyWith(
      status: GameStatus.paused,
    );

    emit(GamePaused(gameState: updatedState));

    add(const GameSaveEvent(saveToFirestore: false));
  }

  // ========== RESUME ==========

  Future<void> _onResume(
    GameResumeEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GamePaused) return;

    final currentState = (state as GamePaused).gameState as GameStateModel;

    final updatedState = currentState.copyWith(
      status: GameStatus.playing,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== SAVE ==========

  Future<void> _onSave(
    GameSaveEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded && state is! GamePaused) return;

    final currentState = state is GameLoaded
        ? (state as GameLoaded).gameState
        : (state as GamePaused).gameState;

    final result = await saveGame(
      SaveGameParams(
        gameState: currentState,
        saveToFirestore: event.saveToFirestore,
      ),
    );

    result.fold(
      (failure) {
        logger.w('Save game failed: ${failure.message}', tag: 'GameBloc');
      },
      (_) {
        logger.d('Game saved successfully', tag: 'GameBloc');
      },
    );
  }

  // ========== CHECK COMPLETION ==========

  Future<void> _onCheckCompletion(
    GameCheckCompletionEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    final currentBoard = _getBoardAsNullableList(currentState.board);
    final solution = _getSolutionAsList(currentState.puzzle);

    final result = await checkCompletion(
      CheckCompletionParams(
        currentBoard: currentBoard,
        solution: solution,
      ),
    );

    result.fold(
      (failure) {
        logger.e('Check completion failed: ${failure.message}', tag: 'GameBloc');
      },
      (isComplete) {
        if (isComplete) {
          final completedState = currentState.copyWith(
            isCompleted: true,
            completedTime: DateTime.now(),
            status: GameStatus.completed,
          );

          emit(GameCompleted(
            gameState: completedState,
            finalTime: completedState.timeElapsed,
            hintsUsed: completedState.hintsUsed,
            errorsMade: completedState.errorsMade,
            accuracy: completedState.accuracy,
          ));

          add(const GameSaveEvent(saveToFirestore: true));
        }
      },
    );
  }

  // ========== RESTART ==========

  Future<void> _onRestart(
    GameRestartEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded && state is! GamePaused) return;

    final currentState = state is GameLoaded
        ? (state as GameLoaded).gameState as GameStateModel
        : (state as GamePaused).gameState as GameStateModel;

    final newGameState = GameStateModel.newGame(
      gameId: 'game_${DateTime.now().millisecondsSinceEpoch}',
      userId: currentState.userId,
      puzzle: currentState.puzzle as PuzzleModel,
    );

    emit(GameLoaded(gameState: newGameState));

    add(const GameSaveEvent(saveToFirestore: false));
  }

  // ========== VALIDATE ALL ==========

  Future<void> _onValidateAll(
    GameValidateAllEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;
    final solution = _getSolutionAsList(currentState.puzzle);

    var updatedBoard = currentState.board;

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final cell = updatedBoard[row][col] as CellModel;
        if (!cell.isFixed && cell.isFilled) {
          final isCorrect = cell.value == solution[row][col];
          final updatedCell = cell.setError(!isCorrect);
          updatedBoard = _updateBoard(updatedBoard, row, col, updatedCell);
        }
      }
    }

    final updatedState = currentState.copyWith(board: updatedBoard);
    emit(GameLoaded(gameState: updatedState));
  }

  // ========== UPDATE TIME ==========

  Future<void> _onUpdateTime(
    GameUpdateTimeEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    final updatedState = currentState.copyWith(
      timeElapsed: event.seconds,
    );

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== CLEAR SELECTION ==========

  Future<void> _onClearSelection(
    GameClearSelectionEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameLoaded) return;

    final currentState = (state as GameLoaded).gameState as GameStateModel;

    final updatedState = currentState.copyWith(clearSelectedCell: true);

    emit(GameLoaded(gameState: updatedState));
  }

  // ========== HELPER METHODS ==========

  List<List<int?>> _getBoardAsNullableList(List<List<CellEntity>> board) {
    return board.map((row) => row.map((cell) => cell.value).toList()).toList();
  }

  List<List<int>> _getSolutionAsList(dynamic puzzle) {
    if (puzzle is PuzzleModel) {
      return puzzle.solution;
    }
    return [];
  }

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