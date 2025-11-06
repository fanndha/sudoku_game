/// File: lib/features/leaderboard/presentation/widgets/leaderboard_item.dart
/// Widget untuk single item dalam leaderboard list

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final bool isCurrentUser;

  const LeaderboardItem({
    Key? key,
    required this.entry,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCurrentUser 
          ? AppColors.primary.withOpacity(0.1) 
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        // Rank
        leading: SizedBox(
          width: 50,
          child: Center(
            child: entry.isTopThree
                ? Text(
                    entry.rankMedal,
                    style: const TextStyle(fontSize: 28),
                  )
                : Text(
                    '#${entry.rank}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
        // User Info
        title: Row(
          children: [
            Expanded(
              child: Text(
                entry.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (entry.isPremium) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                size: 18,
                color: AppColors.premiumGold,
              ),
            ],
          ],
        ),
        subtitle: Text(
          '${entry.totalSolved} puzzle selesai',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        // Best Time
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              TimeFormatter.formatBestTime(entry.bestTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: entry.isTopThree 
                    ? AppColors.getDifficultyColor('expert')
                    : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Best Time',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}