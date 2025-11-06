/// File: lib/features/leaderboard/presentation/widgets/leaderboard_filter.dart
/// Widget untuk filter tabs (Daily, Weekly, All Time)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LeaderboardFilter extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const LeaderboardFilter({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            filter: 'all_time',
            label: 'Semua',
            icon: Icons.emoji_events,
          ),
          _buildTab(
            context,
            filter: 'weekly',
            label: 'Mingguan',
            icon: Icons.calendar_view_week,
          ),
          _buildTab(
            context,
            filter: 'daily',
            label: 'Harian',
            icon: Icons.today,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String filter,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedFilter == filter;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => onFilterChanged(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected 
                    ? AppColors.primary 
                    : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                  color: isSelected 
                      ? AppColors.primary 
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}