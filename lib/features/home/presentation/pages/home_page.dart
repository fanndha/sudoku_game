/// File: lib/features/home/presentation/pages/home_page.dart
/// Main home page aplikasi Sudoku

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/continue_game.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/home_header.dart';
import '../widgets/menu_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasSavedGame = false;
  bool _hasCompletedDailyChallenge = false;

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
    _checkDailyChallenge();
  }

  Future<void> _checkSavedGame() async {
    // TODO: Check if there's a saved game from local storage
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _hasSavedGame = false; // Set true jika ada saved game
      });
    }
  }

  Future<void> _checkDailyChallenge() async {
    // TODO: Check daily challenge status
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _hasCompletedDailyChallenge = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.backgroundLight,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header dengan profile & settings
              SliverToBoxAdapter(
                child: HomeHeader(
                  onProfileTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                  onSettingsTap: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
              ),

              // Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latih otakmu dengan puzzle klasik',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Daily Challenge Card
              if (!_hasCompletedDailyChallenge)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DailyChallengeCard(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.dailyChallenge);
                      },
                    ),
                  ),
                ),

              // Continue Game Card
              if (_hasSavedGame)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: ContinueGameCard(
                      difficulty: 'medium',
                      progress: 45,
                      timeSpent: 325,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.game);
                      },
                    ),
                  ),
                ),

              // Main Menu Grid
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildListDelegate([
                    // New Game
                    MenuButton(
                      icon: Icons.play_arrow,
                      title: AppStrings.newGame,
                      description: 'Mulai permainan baru',
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.difficultySelection,
                        );
                      },
                    ),

                    // Leaderboard
                    MenuButton(
                      icon: Icons.leaderboard,
                      title: AppStrings.leaderboard,
                      description: 'Lihat peringkat',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondary,
                          AppColors.secondaryDark,
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.leaderboard);
                      },
                    ),

                    // Profile & Stats
                    MenuButton(
                      icon: Icons.person,
                      title: AppStrings.profile,
                      description: 'Statistik & pencapaian',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.success,
                          AppColors.success.withOpacity(0.7),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profile);
                      },
                    ),

                    // Store
                    MenuButton(
                      icon: Icons.store,
                      title: AppStrings.store,
                      description: 'Premium & hint pack',
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.premiumGold,
                          AppColors.premiumBadge,
                        ],
                      ),
                      showBadge: true,
                      badgeText: 'BARU',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.store);
                      },
                    ),
                  ]),
                ),
              ),

              // Additional Menu Items
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Tutorial Button
                      _buildSecondaryButton(
                        context,
                        icon: Icons.school,
                        title: AppStrings.tutorial,
                        subtitle: 'Pelajari cara bermain',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.tutorial);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Settings Button
                      _buildSecondaryButton(
                        context,
                        icon: Icons.settings,
                        title: AppStrings.settings,
                        subtitle: 'Atur preferensi aplikasi',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.settings);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
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