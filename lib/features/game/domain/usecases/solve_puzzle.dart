/// File: lib/features/game/domain/usecases/solve_puzzle.dart
/// UseCase untuk solve Sudoku puzzle

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Solve Puzzle
class SolvePuzzle
    implements UseCase<List<List<int>>, SolvePuzzleParams> {
  final GameRepository repository;

  SolvePuzzle(this.repository);

  @override
  Future<Either<Failure, List<List<int>>>> call(
    SolvePuzzleParams params,
  ) async {
    // Validate puzzle
    if (!_isValidPuzzle(params.puzzle)) {
      return const Left(ValidationFailure(
        message: 'Invalid puzzle format',
      ));
    }

    return await repository.solvePuzzle(params.puzzle);
  }

  /// Validate puzzle format (must be 9x9)
  bool _isValidPuzzle(List<List<int?>> puzzle) {
    if (puzzle.length != 9) return false;
    for (final row in puzzle) {
      if (row.length != 9) return false;
    }
    return true;
  }
}

/// Parameters untuk SolvePuzzle
class SolvePuzzleParams extends Params {
  final List<List<int?>> puzzle;

  SolvePuzzleParams({required this.puzzle});

  @override
  List<Object?> get props => [puzzle];

  @override
  String? validate() {
    if (puzzle.length != 9) {
      return 'Puzzle must have 9 rows';
    }

    for (int i = 0; i < puzzle.length; i++) {
      if (puzzle[i].length != 9) {
        return 'Row $i must have 9 columns';
      }

      for (int j = 0; j < puzzle[i].length; j++) {
        final value = puzzle[i][j];
        if (value != null && (value < 1 || value > 9)) {
          return 'Invalid value at [$i,$j]: $value. Must be 1-9 or null';
        }
      }
    }

    return null;
  }
}