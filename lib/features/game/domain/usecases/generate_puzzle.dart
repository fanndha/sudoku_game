/// File: lib/features/game/domain/usecases/generate_puzzle.dart
/// UseCase untuk generate Sudoku puzzle

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/puzzle_entity.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Generate Puzzle
class GeneratePuzzle implements UseCase<PuzzleEntity, GeneratePuzzleParams> {
  final GameRepository repository;

  GeneratePuzzle(this.repository);

  @override
  Future<Either<Failure, PuzzleEntity>> call(
    GeneratePuzzleParams params,
  ) async {
    // Validate difficulty
    if (!_isValidDifficulty(params.difficulty)) {
      return const Left(ValidationFailure(
        message: 'Invalid difficulty level',
      ));
    }

    return await repository.generatePuzzle(params.difficulty);
  }

  /// Validate difficulty string
  bool _isValidDifficulty(String difficulty) {
    const validDifficulties = ['easy', 'medium', 'hard', 'expert'];
    return validDifficulties.contains(difficulty.toLowerCase());
  }
}

/// Parameters untuk GeneratePuzzle
class GeneratePuzzleParams extends Params {
  final String difficulty;

  GeneratePuzzleParams({required this.difficulty});

  @override
  List<Object?> get props => [difficulty];

  @override
  String? validate() {
    if (difficulty.isEmpty) {
      return 'Difficulty cannot be empty';
    }

    const validDifficulties = ['easy', 'medium', 'hard', 'expert'];
    if (!validDifficulties.contains(difficulty.toLowerCase())) {
      return 'Invalid difficulty. Must be: easy, medium, hard, or expert';
    }

    return null;
  }
}