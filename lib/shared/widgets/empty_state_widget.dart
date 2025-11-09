/// File: lib/shared/widgets/empty_state_widget.dart
/// Empty state widgets untuk berbagai kondisi

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Generic Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  final Color? iconColor;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.action,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.grey[400]!).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor ?? Colors.grey[400],
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Action
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// No Data Empty State
class NoDataEmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? action;

  const NoDataEmptyState({
    Key? key,
    this.title,
    this.message,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title ?? 'Tidak Ada Data',
      message: message ?? 'Belum ada data untuk ditampilkan',
      icon: Icons.inbox_outlined,
      action: action,
    );
  }
}

/// No Games Empty State
class NoGamesEmptyState extends StatelessWidget {
  final VoidCallback? onStartGame;

  const NoGamesEmptyState({
    Key? key,
    this.onStartGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Belum Ada Permainan',
      message: 'Mulai permainan baru untuk melihat riwayat di sini',
      icon: Icons.gamepad_outlined,
      iconColor: AppColors.primary,
      action: onStartGame != null
          ? ElevatedButton.icon(
              onPressed: onStartGame,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Mulai Bermain'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            )
          : null,
    );
  }
}

/// No Achievements Empty State
class NoAchievementsEmptyState extends StatelessWidget {
  const NoAchievementsEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Belum Ada Pencapaian',
      message: 'Selesaikan tantangan untuk mendapatkan pencapaian',
      icon: Icons.emoji_events_outlined,
      iconColor: AppColors.achievementGold,
    );
  }
}

/// No Search Results Empty State
class NoSearchResultsEmptyState extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const NoSearchResultsEmptyState({
    Key? key,
    this.searchQuery,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Tidak Ada Hasil',
      message: searchQuery != null
          ? 'Tidak ada hasil untuk "$searchQuery"'
          : 'Tidak ada hasil yang ditemukan',
      icon: Icons.search_off,
      action: onClearSearch != null
          ? TextButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.clear),
              label: const Text('Hapus Pencarian'),
            )
          : null,
    );
  }
}

/// No Internet Empty State
class NoInternetEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetEmptyState({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Tidak Ada Koneksi',
      message: 'Pastikan perangkat Anda terhubung ke internet',
      icon: Icons.wifi_off,
      iconColor: AppColors.error,
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            )
          : null,
    );
  }
}

/// Coming Soon Empty State
class ComingSoonEmptyState extends StatelessWidget {
  final String? title;
  final String? message;

  const ComingSoonEmptyState({
    Key? key,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title ?? 'Segera Hadir',
      message: message ?? 'Fitur ini akan segera tersedia',
      icon: Icons.construction,
      iconColor: AppColors.warning,
    );
  }
}

/// Maintenance Empty State
class MaintenanceEmptyState extends StatelessWidget {
  const MaintenanceEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Sedang Maintenance',
      message: 'Kami sedang melakukan perbaikan. Silakan coba lagi nanti.',
      icon: Icons.build,
      iconColor: AppColors.warning,
    );
  }
}

/// No Saved Game Empty State
class NoSavedGameEmptyState extends StatelessWidget {
  final VoidCallback? onNewGame;

  const NoSavedGameEmptyState({
    Key? key,
    this.onNewGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Tidak Ada Permainan Tersimpan',
      message: 'Mulai permainan baru untuk menyimpan progress Anda',
      icon: Icons.save_outlined,
      iconColor: AppColors.info,
      action: onNewGame != null
          ? ElevatedButton.icon(
              onPressed: onNewGame,
              icon: const Icon(Icons.add),
              label: const Text('Permainan Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            )
          : null,
    );
  }
}