/// File: lib/features/game/domain/repositories/game_repository.dart
/// Repository interface untuk game operations

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/game_state_entity.dart';
import '../entities/puzzle_entity.dart';

/// Abstract Repository untuk Game
abstract class GameRepository {
  /// Generate puzzle baru berdasarkan difficulty
  Future<Either<Failure, PuzzleEntity>> generatePuzzle(String difficulty);

  /// Solve puzzle (untuk hint atau validasi)
  Future<Either<Failure, List<List<int>>>> solvePuzzle(
    List<List<int?>> puzzle,
  );

  /// Validate move apakah conflict dengan rules Sudoku
  Future<Either<Failure, bool>> validateMove(
    List<List<int?>> board,
    int row,
    int col,
    int value,
  );

  /// Get hint untuk cell tertentu
  Future<Either<Failure, int>> getHint(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
    int row,
    int col,
  );

  /// Get possible numbers untuk cell tertentu
  Future<Either<Failure, List<int>>> getPossibleNumbers(
    List<List<int?>> board,
    int row,
    int col,
  );

  /// Save game state locally
  Future<Either<Failure, void>> saveGame(GameStateEntity gameState);

  /// Save game state to Firestore
  Future<Either<Failure, void>> saveGameToFirestore(GameStateEntity gameState);

  /// Load game from local storage
  Future<Either<Failure, GameStateEntity?>> loadGame(String gameId);

  /// Load game from Firestore
  Future<Either<Failure, GameStateEntity?>> loadGameFromFirestore(
    String userId,
    String gameId,
  );

  /// Get all saved games (local)
  Future<Either<Failure, List<GameStateEntity>>> getAllSavedGames();

  /// Delete game
  Future<Either<Failure, void>> deleteGame(String gameId);

  /// Check apakah puzzle sudah complete
  Future<Either<Failure, bool>> checkCompletion(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
  );
}