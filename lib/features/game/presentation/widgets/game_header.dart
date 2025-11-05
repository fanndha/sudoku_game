/// File: lib/features/game/presentation/widgets/game_header.dart
/// Header untuk game page (difficulty, timer, progress)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/utils/formatters.dart';

class GameHeader extends StatelessWidget {
  final String difficulty;
  final int timeElapsed;
  final double progressPercentage;
  final VoidCallback onPause;

  const GameHeader({
    Key? key,
    required this.difficulty,
    required this.timeElapsed,
    required this.progressPercentage,
    required this.onPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row: Difficulty, Timer, Pause
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getDifficultyColor(difficulty)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.getDifficultyColor(difficulty),
                    width: 1,
                  ),
                ),
                child: Text(
                  Formatters.formatDifficulty(difficulty),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.getDifficultyColor(difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              // Timer
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    TimeFormatter.formatDurationSmart(timeElapsed),
                    style: AppTextStyles.timerText,
                  ),
                ],
              ),

              // Pause button
              IconButton(
                onPressed: onPause,
                icon: const Icon(Icons.pause_circle_outline),
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                iconSize: 28,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                  ),
                  Text(
                    '${progressPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.getDifficultyColor(difficulty),
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}