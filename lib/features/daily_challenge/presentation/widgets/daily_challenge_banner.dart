/// File: lib/features/daily_challenge/presentation/widgets/daily_challenge_banner.dart
/// Widget banner untuk daily challenge (bisa dipakai di berbagai tempat)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/daily_challenge_entity.dart';

class DailyChallengeBanner extends StatelessWidget {
  final DailyChallengeEntity? challenge;
  final VoidCallback onTap;
  final bool compact;

  const DailyChallengeBanner({
    super.key,
    required this.challenge,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (challenge == null) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactBanner(context);
    }

    return _buildFullBanner(context);
  }

  Widget _buildFullBanner(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: challenge!.isCompleted
                  ? [
                      AppColors.success.withOpacity(0.8),
                      AppColors.success.withOpacity(0.6),
                    ]
                  : [
                      AppColors.secondary.withOpacity(0.8),
                      AppColors.secondaryDark.withOpacity(0.6),
                    ],
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  challenge!.isCompleted ? Icons.check_circle : Icons.stars,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tantangan Harian',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge!.isCompleted
                          ? 'Selesai! Skor: ${challenge!.userScore ?? 0}'
                          : '${challenge!.participantsCount} pemain ikut serta',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBanner(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: challenge!.isCompleted
              ? AppColors.success.withOpacity(0.1)
              : AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: challenge!.isCompleted
                ? AppColors.success.withOpacity(0.3)
                : AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              challenge!.isCompleted ? Icons.check_circle : Icons.stars,
              color: challenge!.isCompleted
                  ? AppColors.success
                  : AppColors.secondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                challenge!.isCompleted
                    ? 'Tantangan hari ini selesai'
                    : 'Main tantangan harian',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: challenge!.isCompleted
                      ? AppColors.success
                      : AppColors.secondary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

/// Simple text banner (for minimal design)
class SimpleDailyChallengeBanner extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const SimpleDailyChallengeBanner({
    super.key,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(isCompleted ? Icons.check_circle : Icons.stars, size: 18),
      label: Text(
        isCompleted ? 'Tantangan Selesai' : 'Tantangan Harian',
        style: const TextStyle(fontSize: 13),
      ),
      style: TextButton.styleFrom(
        foregroundColor: isCompleted ? AppColors.success : AppColors.secondary,
        backgroundColor: isCompleted
            ? AppColors.success.withOpacity(0.1)
            : AppColors.secondary.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
