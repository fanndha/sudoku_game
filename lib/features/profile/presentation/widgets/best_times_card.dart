/// File: lib/features/profile/presentation/widgets/best_times_card.dart
/// Widget untuk menampilkan best times per difficulty

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/stats_entity.dart';

class BestTimesCard extends StatelessWidget {
  final StatsEntity stats;

  const BestTimesCard({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                const Icon(
                  Icons.timer,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Waktu Terbaik',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Best Times List
            _buildTimeItem(
              context,
              difficulty: 'Mudah',
              time: stats.bestTimeEasy,
              color: AppColors.difficultyEasy,
              icon: Icons.sentiment_satisfied,
            ),
            const Divider(height: 24),
            
            _buildTimeItem(
              context,
              difficulty: 'Sedang',
              time: stats.bestTimeMedium,
              color: AppColors.difficultyMedium,
              icon: Icons.sentiment_neutral,
            ),
            const Divider(height: 24),
            
            _buildTimeItem(
              context,
              difficulty: 'Sulit',
              time: stats.bestTimeHard,
              color: AppColors.difficultyHard,
              icon: Icons.sentiment_dissatisfied,
            ),
            const Divider(height: 24),
            
            _buildTimeItem(
              context,
              difficulty: 'Ahli',
              time: stats.bestTimeExpert,
              color: AppColors.difficultyExpert,
              icon: Icons.psychology,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(
    BuildContext context, {
    required String difficulty,
    required int? time,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        
        // Difficulty Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                difficulty,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                'Level $difficulty',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        // Time
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                time != null && time > 0
                    ? TimeFormatter.formatBestTime(time)
                    : '--:--',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}