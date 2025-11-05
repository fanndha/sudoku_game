/// File: lib/features/game/presentation/widgets/number_pad.dart
/// Number pad untuk input angka 1-9

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';

class NumberPad extends StatelessWidget {
  final Function(int number) onNumberTap;
  final bool isNoteMode;

  const NumberPad({
    Key? key,
    required this.onNumberTap,
    this.isNoteMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(9, (index) {
          final number = index + 1;
          return _NumberButton(
            number: number,
            isDark: isDark,
            isNoteMode: isNoteMode,
            onTap: () {
              Helpers.mediumHaptic();
              onNumberTap(number);
            },
          );
        }),
      ),
    );
  }
}

/// Number button widget
class _NumberButton extends StatelessWidget {
  final int number;
  final bool isDark;
  final bool isNoteMode;
  final VoidCallback onTap;

  const _NumberButton({
    required this.number,
    required this.isDark,
    required this.isNoteMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 32 - 72) / 9; // Calculate size

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                number.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (isNoteMode)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.edit,
                  size: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),
      ),
    );
  }
}