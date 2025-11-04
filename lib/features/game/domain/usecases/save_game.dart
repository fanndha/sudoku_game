/// File: lib/features/game/domain/usecases/save_game.dart
/// UseCase untuk save game state

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game_state_entity.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Save Game (Local & Firestore)
class SaveGame implements UseCase<void, SaveGameParams> {
  final GameRepository repository;

  SaveGame(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveGameParams params) async {
    // Save locally first
    final localResult = await repository.saveGame(params.gameState);

    // If local save fails, return failure
    if (localResult.isLeft()) {
      return localResult;
    }

    // If saveToFirestore is true, save to Firestore
    if (params.saveToFirestore) {
      return await repository.saveGameToFirestore(params.gameState);
    }

    return const Right(null);
  }
}

/// Parameters untuk SaveGame
class SaveGameParams extends Params {
  final GameStateEntity gameState;
  final bool saveToFirestore;

  SaveGameParams({
    required this.gameState,
    this.saveToFirestore = true,
  });

  @override
  List<Object?> get props => [gameState, saveToFirestore];

  @override
  String? validate() {
    if (gameState.gameId.isEmpty) {
      return 'Game ID cannot be empty';
    }
    if (gameState.userId.isEmpty) {
      return 'User ID cannot be empty';
    }
    return null;
  }
}