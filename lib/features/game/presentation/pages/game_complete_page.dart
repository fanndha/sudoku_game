/// File: lib/features/game/presentation/pages/game_complete_page.dart
/// Game completion screen dengan stats

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';

class GameCompletePage extends StatefulWidget {
  const GameCompletePage({super.key});

  @override
  State<GameCompletePage> createState() => _GameCompletePageState();
}

class _GameCompletePageState extends State<GameCompletePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Trigger haptic feedback
    Future.delayed(const Duration(milliseconds: 300), () {
      Helpers.heavyHaptic();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is! GameCompleted) {
              return const Center(child: Text('Invalid state'));
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.successGradient,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Success animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Lottie.asset(
                            'assets/animations/success.json',
                            repeat: false,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.check_circle,
                                size: 120,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              AppStrings.gameComplete,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.gameCompleteDescription,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Stats card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _StatItem(
                                icon: Icons.timer,
                                label: AppStrings.yourTime,
                                value: TimeFormatter.formatDurationSmart(
                                  state.finalTime,
                                ),
                                color: AppColors.primary,
                              ),

                              const Divider(height: 32),

                              _StatItem(
                                icon: Icons.lightbulb_outline,
                                label: AppStrings.hintsUsed,
                                value: '${state.hintsUsed}',
                                color: AppColors.warning,
                              ),

                              const Divider(height: 32),

                              _StatItem(
                                icon: Icons.trending_up,
                                label: AppStrings.accuracy,
                                value: '${state.accuracy.toStringAsFixed(1)}%',
                                color: AppColors.success,
                              ),

                              const Divider(height: 32),

                              _StatItem(
                                icon: Icons.error_outline,
                                label: 'Kesalahan',
                                value: '${state.errorsMade}',
                                color: AppColors.error,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Buttons
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Play again
                            ElevatedButton(
                              onPressed: () => _handlePlayAgain(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(double.infinity, 54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.replay),
                                  SizedBox(width: 8),
                                  Text(
                                    'Main Lagi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // New game
                            OutlinedButton(
                              onPressed: () => _handleNewGame(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(double.infinity, 54),
                              ),
                              child: const Text(
                                'Puzzle Baru',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Back to home
                            TextButton(
                              onPressed: () => _handleBackToHome(context),
                              child: Text(
                                'Kembali ke Menu',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handlePlayAgain(BuildContext context) {
    final state = context.read<GameBloc>().state as GameCompleted;
    context.read<GameBloc>().add(const GameRestartEvent());
    Navigator.of(context).pop(); // Back to game page
  }

  void _handleNewGame(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigate to difficulty selection
    // Navigator.of(context).pushNamed(AppRoutes.difficultySelection);
  }

  void _handleBackToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
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
