/// File: lib/features/game/domain/usecases/get_possible_numbers.dart
/// UseCase untuk get possible numbers untuk cell tertentu

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Get Possible Numbers
class GetPossibleNumbers
    implements UseCase<List<int>, GetPossibleNumbersParams> {
  final GameRepository repository;

  GetPossibleNumbers(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(
    GetPossibleNumbersParams params,
  ) async {
    return await repository.getPossibleNumbers(
      params.board,
      params.row,
      params.col,
    );
  }
}

/// Parameters untuk GetPossibleNumbers
class GetPossibleNumbersParams extends Params {
  final List<List<int?>> board;
  final int row;
  final int col;

  GetPossibleNumbersParams({
    required this.board,
    required this.row,
    required this.col,
  });

  @override
  List<Object?> get props => [board, row, col];

  @override
  String? validate() {
    if (board.length != 9) {
      return 'Board must have 9 rows';
    }

    for (final row in board) {
      if (row.length != 9) {
        return 'Each row must have 9 columns';
      }
    }

    if (row < 0 || row >= 9) {
      return 'Row must be between 0-8';
    }

    if (col < 0 || col >= 9) {
      return 'Column must be between 0-8';
    }

    return null;
  }
}