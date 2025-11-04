/// File: lib/features/game/data/datasources/game_remote_datasource.dart
/// Remote data source untuk game (Firestore + Sudoku Algorithm)

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudoku_game/core/constants/firebase_constans.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/game_state_model.dart';
import '../models/puzzle_model.dart';

/// Abstract class untuk Game Remote Data Source
abstract class GameRemoteDataSource {
  /// Generate Sudoku puzzle
  Future<PuzzleModel> generatePuzzle(String difficulty);
  
  /// Solve Sudoku puzzle
  Future<List<List<int>>> solvePuzzle(List<List<int?>> puzzle);
  
  /// Validate move
  Future<bool> validateMove(
    List<List<int?>> board,
    int row,
    int col,
    int value,
  );
  
  /// Get hint
  Future<int> getHint(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
    int row,
    int col,
  );
  
  /// Get possible numbers
  Future<List<int>> getPossibleNumbers(
    List<List<int?>> board,
    int row,
    int col,
  );
  
  /// Save game to Firestore
  Future<void> saveGameToFirestore(GameStateModel gameState);
  
  /// Load game from Firestore
  Future<GameStateModel?> loadGameFromFirestore(String userId, String gameId);
  
  /// Check completion
  Future<bool> checkCompletion(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
  );
}

/// Implementation
class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final FirebaseFirestore firestore;
  final Random random = Random();
  final Uuid uuid = const Uuid();

  GameRemoteDataSourceImpl({required this.firestore});

  // ========== SUDOKU GENERATION ==========

  @override
  Future<PuzzleModel> generatePuzzle(String difficulty) async {
    try {
      logger.i('Generating puzzle: $difficulty', tag: 'GameRemote');

      // 1. Generate complete solved board
      final solution = await _generateCompleteSolution();

      // 2. Remove numbers based on difficulty
      final puzzle = await _createPuzzleFromSolution(solution, difficulty);

      // 3. Create puzzle model
      final puzzleModel = PuzzleModel.create(
        id: uuid.v4(),
        puzzle: puzzle,
        solution: solution,
        difficulty: difficulty,
      );

      logger.i('Puzzle generated successfully', tag: 'GameRemote');
      return puzzleModel;
    } catch (e) {
      logger.e('Error generating puzzle', error: e, tag: 'GameRemote');
      throw GameException(
        message: 'Gagal membuat puzzle: ${e.toString()}',
      );
    }
  }

  /// Generate complete solved 9x9 board
  Future<List<List<int>>> _generateCompleteSolution() async {
    // Start dengan empty board
    final board = List.generate(9, (_) => List<int>.filled(9, 0));

    // Fill diagonal 3x3 boxes first (tidak ada conflict)
    _fillDiagonalBoxes(board);

    // Solve remaining cells
    _solveSudoku(board);

    return board;
  }

  /// Fill diagonal 3x3 boxes (independent boxes)
  void _fillDiagonalBoxes(List<List<int>> board) {
    for (int box = 0; box < 9; box += 3) {
      _fillBox(board, box, box);
    }
  }

  /// Fill single 3x3 box dengan random numbers
  void _fillBox(List<List<int>> board, int row, int col) {
    final numbers = List.generate(9, (i) => i + 1)..shuffle(random);
    int index = 0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        board[row + i][col + j] = numbers[index++];
      }
    }
  }

  /// Solve Sudoku menggunakan backtracking
  bool _solveSudoku(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          // Try numbers 1-9
          final numbers = List.generate(9, (i) => i + 1);
          numbers.shuffle(random); // Shuffle untuk variasi

          for (final num in numbers) {
            if (_isSafe(board, row, col, num)) {
              board[row][col] = num;

              if (_solveSudoku(board)) {
                return true;
              }

              board[row][col] = 0; // Backtrack
            }
          }
          return false;
        }
      }
    }
    return true; // All cells filled
  }

  /// Check if number placement is safe
  bool _isSafe(List<List<int>> board, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num) return false;
    }

    // Check column
    for (int x = 0; x < 9; x++) {
      if (board[x][col] == num) return false;
    }

    // Check 3x3 box
    final startRow = row - row % 3;
    final startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) return false;
      }
    }

    return true;
  }

  /// Create puzzle by removing numbers from solution
  Future<List<List<int?>>> _createPuzzleFromSolution(
    List<List<int>> solution,
    String difficulty,
  ) async {
    // Copy solution to puzzle
    final puzzle = List.generate(
      9,
      (i) => List<int?>.from(solution[i]),
    );

    // Get number of cells to remove based on difficulty
    final cellsToRemove = _getCellsToRemove(difficulty);

    // Get all cell positions
    final positions = <List<int>>[];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        positions.add([i, j]);
      }
    }
    positions.shuffle(random);

    // Remove cells
    int removed = 0;
    for (final pos in positions) {
      if (removed >= cellsToRemove) break;

      final row = pos[0];
      final col = pos[1];
      // ignore: unused_local_variable
      final backup = puzzle[row][col];

      puzzle[row][col] = null;

      // Check if puzzle still has unique solution
      // (Simplified: skip uniqueness check for performance)
      // In production, implement proper uniqueness check

      removed++;
    }

    return puzzle;
  }

  /// Get number of cells to remove based on difficulty
  int _getCellsToRemove(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return random.nextInt(6) + 40; // 40-45 removed (36-41 filled)
      case 'medium':
        return random.nextInt(6) + 45; // 45-50 removed (31-36 filled)
      case 'hard':
        return random.nextInt(6) + 50; // 50-55 removed (26-31 filled)
      case 'expert':
        return random.nextInt(6) + 55; // 55-60 removed (21-26 filled)
      default:
        return 45;
    }
  }

  // ========== SOLVE PUZZLE ==========

  @override
  Future<List<List<int>>> solvePuzzle(List<List<int?>> puzzle) async {
    try {
      // Convert nullable to non-nullable
      final board = List.generate(
        9,
        (i) => List.generate(9, (j) => puzzle[i][j] ?? 0),
      );

      if (_solveSudoku(board)) {
        return board;
      } else {
        throw PuzzleSolvingException(message: 'Puzzle tidak dapat diselesaikan');
      }
    } catch (e) {
      logger.e('Error solving puzzle', error: e, tag: 'GameRemote');
      throw GameException(message: 'Gagal menyelesaikan puzzle');
    }
  }

  // ========== VALIDATE MOVE ==========

  @override
  Future<bool> validateMove(
    List<List<int?>> board,
    int row,
    int col,
    int value,
  ) async {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (x != col && board[row][x] == value) return false;
    }

    // Check column
    for (int x = 0; x < 9; x++) {
      if (x != row && board[x][col] == value) return false;
    }

    // Check 3x3 box
    final startRow = row - row % 3;
    final startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        final r = startRow + i;
        final c = startCol + j;
        if ((r != row || c != col) && board[r][c] == value) {
          return false;
        }
      }
    }

    return true;
  }

  // ========== GET HINT ==========

  @override
  Future<int> getHint(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
    int row,
    int col,
  ) async {
    if (currentBoard[row][col] != null) {
      throw GameException(message: 'Cell sudah terisi');
    }

    return solution[row][col];
  }

  // ========== GET POSSIBLE NUMBERS ==========

  @override
  Future<List<int>> getPossibleNumbers(
    List<List<int?>> board,
    int row,
    int col,
  ) async {
    if (board[row][col] != null) {
      return [];
    }

    final possible = <int>[];

    for (int num = 1; num <= 9; num++) {
      if (await validateMove(board, row, col, num)) {
        possible.add(num);
      }
    }

    return possible;
  }

  // ========== FIRESTORE OPERATIONS ==========

  @override
  Future<void> saveGameToFirestore(GameStateModel gameState) async {
    try {
      logger.firebase(
        'SET',
        '${FirebaseConstants.usersCollection}/${gameState.userId}/${FirebaseConstants.gamesSubcollection}',
        documentId: gameState.gameId,
      );

      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(gameState.userId)
          .collection(FirebaseConstants.gamesSubcollection)
          .doc(gameState.gameId)
          .set(gameState.toFirestore());

      logger.i('Game saved to Firestore', tag: 'GameRemote');
    } catch (e) {
      logger.e('Error saving to Firestore', error: e, tag: 'GameRemote');
      throw FirestoreException(message: 'Gagal menyimpan ke server');
    }
  }

  @override
  Future<GameStateModel?> loadGameFromFirestore(
    String userId,
    String gameId,
  ) async {
    try {
      logger.firebase(
        'GET',
        '${FirebaseConstants.usersCollection}/$userId/${FirebaseConstants.gamesSubcollection}',
        documentId: gameId,
      );

      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.gamesSubcollection)
          .doc(gameId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return GameStateModel.fromFirestore(doc.data()!);
    } catch (e) {
      logger.e('Error loading from Firestore', error: e, tag: 'GameRemote');
      throw FirestoreException(message: 'Gagal memuat dari server');
    }
  }

  // ========== CHECK COMPLETION ==========

  @override
  Future<bool> checkCompletion(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
  ) async {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (currentBoard[i][j] != solution[i][j]) {
          return false;
        }
      }
    }
    return true;
  }
}