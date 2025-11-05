/// File: lib/features/game/presentation/widgets/sudoku_cell.dart
/// Widget untuk single Sudoku cell

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cell_entity.dart';

class SudokuCell extends StatelessWidget {
  final CellEntity cell;
  final bool isSelected;
  final bool isHighlighted;
  final bool isSameNumber;
  final VoidCallback onTap;

  const SudokuCell({
    Key? key,
    required this.cell,
    required this.isSelected,
    required this.isHighlighted,
    required this.isSameNumber,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getCellColor(isDark),
          border: Border.all(
            color: _getBorderColor(isDark),
            width: _getBorderWidth(),
          ),
        ),
        child: Center(
          child: cell.hasNotes && !cell.isFilled
              ? _buildNotes(isDark)
              : _buildNumber(isDark),
        ),
      ),
    );
  }

  /// Build cell number
  Widget _buildNumber(bool isDark) {
    if (cell.isEmpty) return const SizedBox();

    final textStyle = cell.isFixed
        ? AppTextStyles.sudokuNumberFixed
        : cell.isError
            ? AppTextStyles.sudokuNumberError
            : AppTextStyles.sudokuNumberUser;

    return Text(
      cell.value.toString(),
      style: textStyle,
    );
  }

  /// Build notes (pencil marks)
  Widget _buildNotes(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final number = index + 1;
        final hasNote = cell.notes.contains(number);

        return Center(
          child: hasNote
              ? Text(
                  number.toString(),
                  style: AppTextStyles.sudokuNumberNote,
                )
              : const SizedBox(),
        );
      },
    );
  }

  /// Get cell background color
  Color _getCellColor(bool isDark) {
    if (cell.isError) {
      return isDark ? AppColors.cellErrorDark : AppColors.cellError;
    }

    if (isSelected) {
      return isDark ? AppColors.cellSelectedDark : AppColors.cellSelected;
    }

    if (isSameNumber) {
      return isDark
          ? AppColors.cellHighlightDark.withOpacity(0.5)
          : AppColors.cellHighlight.withOpacity(0.5);
    }

    if (isHighlighted) {
      return isDark ? AppColors.cellHighlightDark : AppColors.cellHighlight;
    }

    if (cell.isFixed) {
      return isDark ? AppColors.cellFixedDark : AppColors.cellFixed;
    }

    return isDark ? AppColors.cellDefaultDark : AppColors.cellDefault;
  }

  /// Get border color
  Color _getBorderColor(bool isDark) {
    return isDark ? AppColors.gridLine : AppColors.gridLine;
  }

  /// Get border width (thicker for 3x3 box boundaries)
  double _getBorderWidth() {
    final isBoldRight = (cell.column + 1) % 3 == 0 && cell.column != 8;
    final isBoldBottom = (cell.row + 1) % 3 == 0 && cell.row != 8;

    if (isBoldRight || isBoldBottom) {
      return 2;
    }

    return 0.5;
  }
}