/// File: lib/features/game/presentation/pages/difficulty_selection_page.dart
/// Page untuk memilih difficulty level

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../widgets/difficulty_card.dart';

class DifficultySelectionPage extends StatelessWidget {
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectDifficulty),
        elevation: 0,
      ),
      body: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameLoaded) {
            // Navigate to game page
            Navigator.of(context).pushReplacementNamed(AppRoutes.game);
          } else if (state is GameError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message ?? AppStrings.generatingPuzzle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          AppColors.backgroundDark,
                          AppColors.surfaceDark,
                        ]
                      : [
                          AppColors.primaryLight.withOpacity(0.1),
                          Colors.white,
                        ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        AppStrings.selectDifficulty,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Pilih tingkat kesulitan yang sesuai dengan kemampuan Anda',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),

                      const SizedBox(height: 32),

                      // Easy
                      DifficultyCard(
                        difficulty: 'easy',
                        description: AppStrings.easyDescription,
                        icon: Icons.sentiment_satisfied_alt,
                        onTap: () => _startGame(context, 'easy'),
                      ),

                      // Medium
                      DifficultyCard(
                        difficulty: 'medium',
                        description: AppStrings.mediumDescription,
                        icon: Icons.sentiment_neutral,
                        onTap: () => _startGame(context, 'medium'),
                      ),

                      // Hard
                      DifficultyCard(
                        difficulty: 'hard',
                        description: AppStrings.hardDescription,
                        icon: Icons.sentiment_dissatisfied,
                        onTap: () => _startGame(context, 'hard'),
                      ),

                      // Expert
                      DifficultyCard(
                        difficulty: 'expert',
                        description: AppStrings.expertDescription,
                        icon: Icons.psychology,
                        onTap: () => _startGame(context, 'expert'),
                      ),

                      const SizedBox(height: 16),
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

  void _startGame(BuildContext context, String difficulty) {
    context.read<GameBloc>().add(GameStartNewEvent(difficulty: difficulty));
  }
}