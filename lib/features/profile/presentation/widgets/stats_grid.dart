/// File: lib/features/profile/presentation/widgets/stats_grid.dart
/// Widget untuk grid statistics

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/stats_entity.dart';
import 'stats_card.dart';

class StatsGrid extends StatelessWidget {
  final StatsEntity stats;

  const StatsGrid({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        // Total Games Played
        StatsCard(
          title: 'Total Dimainkan',
          value: Formatters.formatNumber(stats.totalGamesPlayed),
          icon: Icons.sports_esports,
          color: AppColors.primary,
        ),
        
        // Total Games Completed
        StatsCard(
          title: 'Total Selesai',
          value: Formatters.formatNumber(stats.totalGamesCompleted),
          icon: Icons.check_circle,
          color: AppColors.success,
        ),
        
        // Win Rate
        StatsCard(
          title: 'Win Rate',
          value: Formatters.formatPercentage(stats.winRate, 0),
          icon: Icons.trending_up,
          color: AppColors.difficultyMedium,
        ),
        
        // Current Streak
        StatsCard(
          title: 'Streak Saat Ini',
          value: '${stats.winStreak} hari',
          icon: Icons.local_fire_department,
          color: AppColors.difficultyHard,
        ),
        
        // Best Streak
        StatsCard(
          title: 'Streak Terbaik',
          value: '${stats.bestStreak} hari',
          icon: Icons.emoji_events,
          color: AppColors.premiumGold,
        ),
        
        // Total Hints Used
        StatsCard(
          title: 'Total Petunjuk',
          value: Formatters.formatNumber(stats.totalHintsUsed),
          icon: Icons.lightbulb,
          color: AppColors.warning,
        ),
        
        // Perfect Games
        StatsCard(
          title: 'Permainan Sempurna',
          value: Formatters.formatNumber(stats.perfectGames),
          icon: Icons.star,
          color: AppColors.premiumGold,
        ),
        
        // Total Play Time
        StatsCard(
          title: 'Total Waktu Bermain',
          value: TimeFormatter.formatDurationHuman(
            stats.totalPlayTime,
            showSeconds: false,
          ),
          icon: Icons.timer,
          color: AppColors.info,
        ),
      ],
    );
  }
}