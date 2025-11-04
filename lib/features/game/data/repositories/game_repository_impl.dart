/// File: lib/features/game/data/repositories/game_repository_impl.dart
/// Implementation dari GameRepository

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/game_state_entity.dart';
import '../../domain/entities/puzzle_entity.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';
import '../datasources/game_remote_datasource.dart';
import '../models/game_state_model.dart';

/// Implementation dari GameRepository
class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;
  final GameLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GameRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PuzzleEntity>> generatePuzzle(String difficulty) async {
    try {
      logger.i('Generating puzzle: $difficulty', tag: 'GameRepository');

      // Generate puzzle (tidak perlu network, pure algorithm)
      final puzzle = await remoteDataSource.generatePuzzle(difficulty);

      logger.i('Puzzle generated successfully', tag: 'GameRepository');
      return Right(puzzle);
    } on PuzzleGenerationException catch (e) {
      logger.e('Puzzle generation failed: ${e.message}', tag: 'GameRepository');
      return Left(PuzzleGenerationFailure(message: e.message, code: e.code));
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error generating puzzle', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal membuat puzzle: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<List<int>>>> solvePuzzle(
    List<List<int?>> puzzle,
  ) async {
    try {
      logger.i('Solving puzzle', tag: 'GameRepository');

      final solution = await remoteDataSource.solvePuzzle(puzzle);

      logger.i('Puzzle solved successfully', tag: 'GameRepository');
      return Right(solution);
    } on PuzzleSolvingException catch (e) {
      logger.e('Puzzle solving failed: ${e.message}', tag: 'GameRepository');
      return Left(PuzzleSolvingFailure(message: e.message, code: e.code));
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error solving puzzle', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal menyelesaikan puzzle: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateMove(
    List<List<int?>> board,
    int row,
    int col,
    int value,
  ) async {
    try {
      final isValid = await remoteDataSource.validateMove(board, row, col, value);
      return Right(isValid);
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error validating move', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal validasi langkah: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getHint(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
    int row,
    int col,
  ) async {
    try {
      logger.i('Getting hint for [$row,$col]', tag: 'GameRepository');

      final hint = await remoteDataSource.getHint(currentBoard, solution, row, col);

      logger.i('Hint retrieved: $hint', tag: 'GameRepository');
      return Right(hint);
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error getting hint', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal mendapatkan petunjuk: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getPossibleNumbers(
    List<List<int?>> board,
    int row,
    int col,
  ) async {
    try {
      final possibleNumbers = await remoteDataSource.getPossibleNumbers(board, row, col);
      return Right(possibleNumbers);
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error getting possible numbers', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal mendapatkan angka yang mungkin: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveGame(GameStateEntity gameState) async {
    try {
      logger.i('Saving game locally: ${gameState.gameId}', tag: 'GameRepository');

      final gameStateModel = gameState is GameStateModel
          ? gameState
          : GameStateModel.fromEntity(gameState);

      await localDataSource.saveGame(gameStateModel);

      logger.i('Game saved locally', tag: 'GameRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'GameRepository');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error saving game', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal menyimpan game: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveGameToFirestore(
    GameStateEntity gameState,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'GameRepository');
        return const Left(NetworkFailure(message: 'Tidak ada koneksi internet'));
      }

      logger.i('Saving game to Firestore: ${gameState.gameId}', tag: 'GameRepository');

      final gameStateModel = gameState is GameStateModel
          ? gameState
          : GameStateModel.fromEntity(gameState);

      await remoteDataSource.saveGameToFirestore(gameStateModel);

      logger.i('Game saved to Firestore', tag: 'GameRepository');
      return const Right(null);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'GameRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'GameRepository');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error saving to Firestore', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal menyimpan ke server: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity?>> loadGame(String gameId) async {
    try {
      logger.i('Loading game locally: $gameId', tag: 'GameRepository');

      final gameState = await localDataSource.loadGame(gameId);

      if (gameState == null) {
        logger.d('Game not found locally: $gameId', tag: 'GameRepository');
        return const Right(null);
      }

      logger.i('Game loaded locally', tag: 'GameRepository');
      return Right(gameState);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'GameRepository');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error loading game', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal memuat game: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity?>> loadGameFromFirestore(
    String userId,
    String gameId,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        logger.w('No internet connection', tag: 'GameRepository');
        return const Left(NetworkFailure(message: 'Tidak ada koneksi internet'));
      }

      logger.i('Loading game from Firestore: $gameId', tag: 'GameRepository');

      final gameState = await remoteDataSource.loadGameFromFirestore(userId, gameId);

      if (gameState == null) {
        logger.d('Game not found in Firestore: $gameId', tag: 'GameRepository');
        return const Right(null);
      }

      await localDataSource.saveGame(gameState);

      logger.i('Game loaded from Firestore', tag: 'GameRepository');
      return Right(gameState);
    } on FirestoreException catch (e) {
      logger.e('Firestore exception: ${e.message}', tag: 'GameRepository');
      return Left(FirestoreFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      logger.e('Network exception: ${e.message}', tag: 'GameRepository');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error loading from Firestore', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal memuat dari server: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<GameStateEntity>>> getAllSavedGames() async {
    try {
      logger.i('Getting all saved games', tag: 'GameRepository');

      final games = await localDataSource.getAllSavedGames();

      logger.i('Loaded ${games.length} saved games', tag: 'GameRepository');
      return Right(games);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'GameRepository');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error getting saved games', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal memuat daftar game: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGame(String gameId) async {
    try {
      logger.i('Deleting game: $gameId', tag: 'GameRepository');

      await localDataSource.deleteGame(gameId);

      logger.i('Game deleted', tag: 'GameRepository');
      return const Right(null);
    } on CacheException catch (e) {
      logger.e('Cache exception: ${e.message}', tag: 'GameRepository');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error deleting game', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal menghapus game: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkCompletion(
    List<List<int?>> currentBoard,
    List<List<int>> solution,
  ) async {
    try {
      final isComplete = await remoteDataSource.checkCompletion(currentBoard, solution);
      return Right(isComplete);
    } on GameException catch (e) {
      logger.e('Game exception: ${e.message}', tag: 'GameRepository');
      return Left(GameFailure(message: e.message, code: e.code));
    } catch (e) {
      logger.e('Unknown error checking completion', error: e, tag: 'GameRepository');
      return Left(UnknownFailure(message: 'Gagal memeriksa penyelesaian: ${e.toString()}'));
    }
  }
}
