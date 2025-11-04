/// File: lib/features/game/domain/usecases/get_hint.dart
/// UseCase untuk get hint (correct number untuk cell tertentu)

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Get Hint
class GetHint implements UseCase<int, GetHintParams> {
  final GameRepository repository;

  GetHint(this.repository);

  @override
  Future<Either<Failure, int>> call(GetHintParams params) async {
    return await repository.getHint(
      params.currentBoard,
      params.solution,
      params.row,
      params.col,
    );
  }
}

/// Parameters untuk GetHint
class GetHintParams extends Params {
  final List<List<int?>> currentBoard;
  final List<List<int>> solution;
  final int row;
  final int col;

  GetHintParams({
    required this.currentBoard,
    required this.solution,
    required this.row,
    required this.col, required List<List<int?>> board,
  });

  @override
  List<Object?> get props => [currentBoard, solution, row, col];

  @override
  String? validate() {
    // Validate boards
    if (currentBoard.length != 9 || solution.length != 9) {
      return 'Board must have 9 rows';
    }

    // Validate position
    if (row < 0 || row >= 9 || col < 0 || col >= 9) {
      return 'Invalid position';
    }

    // Check if cell already filled
    if (currentBoard[row][col] != null) {
      return 'Cell is already filled';
    }

    return null;
  }
}