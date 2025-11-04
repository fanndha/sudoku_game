/// File: lib/features/game/domain/usecases/check_completion.dart
/// UseCase untuk check apakah puzzle sudah complete

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

/// UseCase untuk Check Completion
class CheckCompletion implements UseCase<bool, CheckCompletionParams> {
  final GameRepository repository;

  CheckCompletion(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckCompletionParams params) async {
    return await repository.checkCompletion(
      params.currentBoard,
      params.solution,
    );
  }
}

/// Parameters untuk CheckCompletion
class CheckCompletionParams extends Params {
  final List<List<int?>> currentBoard;
  final List<List<int>> solution;

  CheckCompletionParams({
    required this.currentBoard,
    required this.solution,
  });

  @override
  List<Object?> get props => [currentBoard, solution];

  @override
  String? validate() {
    if (currentBoard.length != 9 || solution.length != 9) {
      return 'Board must have 9 rows';
    }

    for (int i = 0; i < 9; i++) {
      if (currentBoard[i].length != 9 || solution[i].length != 9) {
        return 'Each row must have 9 columns';
      }
    }

    return null;
  }
}