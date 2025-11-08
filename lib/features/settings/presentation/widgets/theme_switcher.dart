/// File: lib/features/settings/presentation/widgets/theme_switcher.dart
/// Widget untuk switch theme

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ThemeSwitcher extends StatelessWidget {
  final String currentTheme;
  final ValueChanged<String> onThemeChanged;

  const ThemeSwitcher({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tema Aplikasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildThemeCard(
                context,
                theme: 'light',
                title: 'Terang',
                icon: Icons.light_mode,
                isSelected: currentTheme == 'light',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeCard(
                context,
                theme: 'dark',
                title: 'Gelap',
                icon: Icons.dark_mode,
                isSelected: currentTheme == 'dark',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildThemeCard(
                context,
                theme: 'system',
                title: 'Sistem',
                icon: Icons.settings_brightness,
                isSelected: currentTheme == 'system',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required String theme,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onThemeChanged(theme),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}