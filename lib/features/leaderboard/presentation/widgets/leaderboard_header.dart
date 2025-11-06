/// File: lib/features/leaderboard/presentation/widgets/leaderboard_header.dart
/// Widget untuk menampilkan top 3 dengan podium

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class LeaderboardHeader extends StatelessWidget {
  final List<LeaderboardEntryEntity> entries;

  const LeaderboardHeader({
    Key? key,
    required this.entries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.premiumGold,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Top 3 Pemain',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Podium
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place
                if (entries.length > 1)
                  Expanded(child: _buildPodium(context, entries[1], 2)),
                
                const SizedBox(width: 8),
                
                // 1st Place
                if (entries.isNotEmpty)
                  Expanded(child: _buildPodium(context, entries[0], 1)),
                
                const SizedBox(width: 8),
                
                // 3rd Place
                if (entries.length > 2)
                  Expanded(child: _buildPodium(context, entries[2], 3)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(
    BuildContext context,
    LeaderboardEntryEntity entry,
    int rank,
  ) {
    final heights = {1: 140.0, 2: 110.0, 3: 90.0};
    final colors = {
      1: AppColors.rank1,
      2: AppColors.rank2,
      3: AppColors.rank3,
    };
    final avatarSizes = {1: 36.0, 2: 30.0, 3: 26.0};

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        CircleAvatar(
          radius: avatarSizes[rank],
          backgroundColor: colors[rank],
          backgroundImage: entry.photoUrl != null
              ? NetworkImage(entry.photoUrl!)
              : null,
          child: entry.photoUrl == null
              ? Text(
                  entry.initials,
                  style: TextStyle(
                    fontSize: rank == 1 ? 24 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 8),
        
        // Username
        Text(
          entry.username,
          style: TextStyle(
            fontSize: rank == 1 ? 14 : 12,
            fontWeight: rank == 1 ? FontWeight.bold : FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        
        // Best Time
        Text(
          TimeFormatter.formatBestTime(entry.bestTime),
          style: TextStyle(
            fontSize: rank == 1 ? 13 : 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        // Podium Box
        Container(
          width: double.infinity,
          height: heights[rank],
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors[rank]!,
                colors[rank]!.withOpacity(0.7),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: colors[rank]!.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Medal Emoji
              Text(
                entry.rankMedal,
                style: TextStyle(
                  fontSize: rank == 1 ? 48 : 36,
                ),
              ),
              const SizedBox(height: 4),
              // Rank Number
              Text(
                '#$rank',
                style: TextStyle(
                  fontSize: rank == 1 ? 20 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}