/// File: lib/features/game/domain/usecases/load_game.dart
/// UseCase untuk load game state

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game_state_entity.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Load Game
class LoadGame implements UseCase<GameStateEntity?, LoadGameParams> {
  final GameRepository repository;

  LoadGame(this.repository);

  @override
  Future<Either<Failure, GameStateEntity?>> call(
    LoadGameParams params,
  ) async {
    // Try load from local first
    final localResult = await repository.loadGame(params.gameId);

    // If found locally, return it
    if (localResult.isRight()) {
      final gameState = localResult.getOrElse(() => null);
      if (gameState != null) {
        return Right(gameState);
      }
    }

    // If not found locally and loadFromFirestore is true, try Firestore
    if (params.loadFromFirestore && params.userId != null) {
      return await repository.loadGameFromFirestore(
        params.userId!,
        params.gameId,
      );
    }

    return const Right(null);
  }
}

/// Parameters untuk LoadGame
class LoadGameParams extends Params {
  final String gameId;
  final String? userId;
  final bool loadFromFirestore;

  LoadGameParams({
    required this.gameId,
    this.userId,
    this.loadFromFirestore = true,
  });

  @override
  List<Object?> get props => [gameId, userId, loadFromFirestore];

  @override
  String? validate() {
    if (gameId.isEmpty) {
      return 'Game ID cannot be empty';
    }
    if (loadFromFirestore && (userId == null || userId!.isEmpty)) {
      return 'User ID required when loading from Firestore';
    }
    return null;
  }
}