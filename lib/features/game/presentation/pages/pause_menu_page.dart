/// File: lib/features/game/presentation/pages/pause_menu_page.dart
/// Pause menu dialog

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';

class PauseMenuPage extends StatelessWidget {
  const PauseMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        _handleResume(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pause icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pause_circle_outline,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  AppStrings.gamePaused,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 32),

                // Menu buttons
                _MenuButton(
                  icon: Icons.play_arrow,
                  label: AppStrings.resume,
                  color: AppColors.success,
                  onTap: () => _handleResume(context),
                ),

                const SizedBox(height: 12),

                _MenuButton(
                  icon: Icons.restart_alt,
                  label: AppStrings.restart,
                  color: AppColors.warning,
                  onTap: () => _handleRestart(context),
                ),

                const SizedBox(height: 12),

                _MenuButton(
                  icon: Icons.settings,
                  label: AppStrings.settings,
                  color: AppColors.info,
                  onTap: () => _handleSettings(context),
                ),

                const SizedBox(height: 12),

                _MenuButton(
                  icon: Icons.home,
                  label: 'Ke Menu Utama',
                  color: AppColors.error,
                  onTap: () => _handleQuit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleResume(BuildContext context) {
    context.read<GameBloc>().add(const GameResumeEvent());
    Navigator.of(context).pop();
  }

  void _handleRestart(BuildContext context) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: AppStrings.restart,
      message: AppStrings.restartConfirm,
    );

    if (confirm) {
      context.read<GameBloc>().add(const GameRestartEvent());
      Navigator.of(context).pop();
    }
  }

  void _handleSettings(BuildContext context) {
    Helpers.showInfoSnackbar(context, 'Settings akan segera hadir!');
  }

  void _handleQuit(BuildContext context) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Keluar',
      message: 'Yakin ingin keluar? Progress akan disimpan.',
    );

    if (confirm) {
      // Save game first
      context.read<GameBloc>().add(const GameSaveEvent());
      
      // Pop until home
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

/// Menu button widget
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Helpers.mediumHaptic();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}