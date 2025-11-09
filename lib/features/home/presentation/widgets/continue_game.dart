/// File: lib/features/home/presentation/widgets/continue_game_card.dart
/// Widget untuk continue game card

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/time_formatter.dart';

class ContinueGameCard extends StatelessWidget {
  final String difficulty;
  final int progress; // Percentage 0-100
  final int timeSpent; // in seconds
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ContinueGameCard({
    Key? key,
    required this.difficulty,
    required this.progress,
    required this.timeSpent,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
              colors: [
                _getDifficultyColor().withOpacity(0.1),
                _getDifficultyColor().withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Continue Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: _getDifficultyColor(),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title & Difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.continueGame,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                Formatters.formatDifficulty(difficulty),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Delete Button
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.grey[600],
                      iconSize: 20,
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getDifficultyColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getDifficultyColor(),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  // Time
                  Expanded(
                    child: _buildStatItem(
                      Icons.timer,
                      'Waktu',
                      TimeFormatter.formatDurationSmart(timeSpent),
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),

                  // Cells Filled
                  Expanded(
                    child: _buildStatItem(
                      Icons.grid_on,
                      'Terisi',
                      '${(81 * progress / 100).round()}/81',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor() {
    return AppColors.getDifficultyColor(difficulty);
  }
}

/// Compact Continue Game Card - versi lebih kecil
class CompactContinueGameCard extends StatelessWidget {
  final String difficulty;
  final int progress;
  final VoidCallback onTap;

  const CompactContinueGameCard({
    Key? key,
    required this.difficulty,
    required this.progress,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppColors.getDifficultyColor(difficulty);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: difficultyColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: difficultyColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            Formatters.formatDifficulty(difficulty),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                difficultyColor,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$progress%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: difficultyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// No Saved Game Widget - ditampilkan jika tidak ada saved game
class NoSavedGameWidget extends StatelessWidget {
  const NoSavedGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.save_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.noSavedGame,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mulai permainan baru untuk menyimpan progress',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}