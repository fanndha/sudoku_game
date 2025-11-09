/// File: lib/features/home/presentation/widgets/daily_challenge_card.dart
/// Widget untuk daily challenge card

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class DailyChallengeCard extends StatefulWidget {
  final VoidCallback onTap;
  final bool isCompleted;
  final int? participantsCount;
  final String? bestTime;

  const DailyChallengeCard({
    Key? key,
    required this.onTap,
    this.isCompleted = false,
    this.participantsCount,
    this.bestTime,
  }) : super(key: key);

  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isCompleted
                    ? [
                        AppColors.success,
                        AppColors.success.withOpacity(0.7),
                      ]
                    : [
                        AppColors.secondary,
                        AppColors.secondaryDark,
                      ],
              ),
            ),
            child: Stack(
              children: [
                // Background Pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PatternPainter(),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.isCompleted
                                  ? Icons.check_circle
                                  : Icons.calendar_today,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Title & Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.dailyChallenge,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getTodayDate(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
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

                      const SizedBox(height: 16),

                      // Status Text
                      Text(
                        widget.isCompleted
                            ? 'Selamat! Kamu sudah menyelesaikan tantangan hari ini'
                            : AppStrings.completeDailyChallenge,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),

                      // Stats (if available)
                      if (widget.participantsCount != null ||
                          widget.bestTime != null) ...[
                        const SizedBox(height: 16),
                        _buildStats(),
                      ],
                    ],
                  ),
                ),

                // Completed Badge
                if (widget.isCompleted)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'SELESAI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (widget.participantsCount != null) ...[
            Expanded(
              child: _buildStatItem(
                Icons.people,
                '${widget.participantsCount} Pemain',
              ),
            ),
          ],
          if (widget.participantsCount != null && widget.bestTime != null)
            Container(
              width: 1,
              height: 30,
              color: Colors.white.withOpacity(0.3),
            ),
          if (widget.bestTime != null) ...[
            Expanded(
              child: _buildStatItem(
                Icons.timer,
                widget.bestTime!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

/// Pattern Painter untuk background
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw circles
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.2 + i * 0.2);
      final y = size.height * (0.3 + (i % 2) * 0.4);
      canvas.drawCircle(
        Offset(x, y),
        30,
        paint,
      );
    }

    // Draw squares
    final squarePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(
        size.width * (0.3 + i * 0.3),
        size.height * (0.5 + (i % 2) * 0.3),
      );
      canvas.rotate(math.pi / 4);
      canvas.drawRect(
        const Rect.fromLTWH(-15, -15, 30, 30),
        squarePaint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Compact Daily Challenge Card - versi lebih kecil
class CompactDailyChallengeCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isCompleted;

  const CompactDailyChallengeCard({
    Key? key,
    required this.onTap,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isCompleted
                  ? [
                      AppColors.success.withOpacity(0.1),
                      AppColors.success.withOpacity(0.05),
                    ]
                  : [
                      AppColors.secondary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.05),
                    ],
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.calendar_today,
                  color: isCompleted ? AppColors.success : AppColors.secondary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tantangan Harian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? AppColors.success : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted ? 'Sudah selesai hari ini' : 'Main sekarang!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

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