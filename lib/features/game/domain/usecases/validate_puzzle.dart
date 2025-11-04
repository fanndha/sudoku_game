/// File: lib/features/game/domain/usecases/validate_move.dart
/// UseCase untuk validate apakah move valid (tidak conflict)

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Validate Move
class ValidateMove implements UseCase<bool, ValidateMoveParams> {
  final GameRepository repository;

  ValidateMove(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateMoveParams params) async {
    return await repository.validateMove(
      params.board,
      params.row,
      params.col,
      params.value,
    );
  }
}

/// Parameters untuk ValidateMove
class ValidateMoveParams extends Params {
  final List<List<int?>> board;
  final int row;
  final int col;
  final int value;

  ValidateMoveParams({
    required this.board,
    required this.row,
    required this.col,
    required this.value,
  });

  @override
  List<Object?> get props => [board, row, col, value];

  @override
  String? validate() {
    // Validate board
    if (board.length != 9) {
      return 'Board must have 9 rows';
    }
    for (final row in board) {
      if (row.length != 9) {
        return 'Each row must have 9 columns';
      }
    }

    // Validate row & col
    if (row < 0 || row >= 9) {
      return 'Row must be between 0-8';
    }
    if (col < 0 || col >= 9) {
      return 'Column must be between 0-8';
    }

    // Validate value
    if (value < 1 || value > 9) {
      return 'Value must be between 1-9';
    }

    return null;
  }
}