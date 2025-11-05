/// File: lib/features/game/presentation/widgets/game_controls.dart
/// Game control buttons (undo, redo, erase, note, hint)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onErase;
  final VoidCallback onNote;
  final VoidCallback onHint;
  final bool canUndo;
  final bool canRedo;
  final bool isNoteMode;
  final int hintsRemaining;

  const GameControls({
    Key? key,
    required this.onUndo,
    required this.onRedo,
    required this.onErase,
    required this.onNote,
    required this.onHint,
    required this.canUndo,
    required this.canRedo,
    required this.isNoteMode,
    required this.hintsRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Undo
          _ControlButton(
            icon: Icons.undo,
            label: 'Undo',
            onTap: canUndo ? onUndo : null,
            enabled: canUndo,
          ),

          // Redo
          _ControlButton(
            icon: Icons.redo,
            label: 'Redo',
            onTap: canRedo ? onRedo : null,
            enabled: canRedo,
          ),

          // Erase
          _ControlButton(
            icon: Icons.backspace_outlined,
            label: 'Hapus',
            onTap: onErase,
            enabled: true,
          ),

          // Note
          _ControlButton(
            icon: Icons.edit_note,
            label: 'Catatan',
            onTap: onNote,
            enabled: true,
            isActive: isNoteMode,
          ),

          // Hint
          _ControlButton(
            icon: Icons.lightbulb_outline,
            label: 'Hint',
            badge: hintsRemaining > 0 ? hintsRemaining.toString() : null,
            onTap: onHint,
            enabled: true,
          ),
        ],
      ),
    );
  }
}

/// Control button widget
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isActive;
  final String? badge;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.enabled,
    this.isActive = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = enabled
        ? (isActive
            ? AppColors.primary
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return GestureDetector(
      onTap: enabled
          ? () {
              Helpers.mediumHaptic();
              onTap?.call();
            }
          : null,
      child: Container(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryLight.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isActive
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}