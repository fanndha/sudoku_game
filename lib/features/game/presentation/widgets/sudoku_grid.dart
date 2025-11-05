/// File: lib/features/game/presentation/widgets/sudoku_grid.dart
/// Widget untuk 9x9 Sudoku grid

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/cell_entity.dart';
import 'sudoku_cell.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<CellEntity>> board;
  final int? selectedCellIndex;
  final Function(int cellIndex) onCellTap;

  const SudokuGrid({
    super.key,
    required this.board,
    required this.selectedCellIndex,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gridSize = size.width - 32; // 16 padding each side
    final cellSize = gridSize / 9;

    return Container(
      width: gridSize,
      height: gridSize,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.boardBackgroundDark
            : AppColors.boardBackground,
        border: Border.all(
          color: AppColors.gridLineBold,
          width: 2,
        ),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          final row = index ~/ 9;
          final col = index % 9;
          final cell = board[row][col];

          final isSelected = selectedCellIndex == index;
          final isHighlighted = _isHighlighted(index);
          final isSameNumber = _isSameNumber(cell);

          return SudokuCell(
            cell: cell,
            isSelected: isSelected,
            isHighlighted: isHighlighted,
            isSameNumber: isSameNumber,
            onTap: () {
              Helpers.lightHaptic();
              onCellTap(index);
            },
          );
        },
      ),
    );
  }

  /// Check if cell should be highlighted (same row, col, or box as selected)
  bool _isHighlighted(int cellIndex) {
    if (selectedCellIndex == null) return false;

    return Helpers.areCellsRelated(cellIndex, selectedCellIndex!);
  }

  /// Check if cell has same number as selected cell
  bool _isSameNumber(CellEntity cell) {
    if (selectedCellIndex == null) return false;
    if (cell.isEmpty) return false;

    final selectedRow = selectedCellIndex! ~/ 9;
    final selectedCol = selectedCellIndex! % 9;
    final selectedCell = board[selectedRow][selectedCol];

    if (selectedCell.isEmpty) return false;

    return cell.value == selectedCell.value;
  }
}