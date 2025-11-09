/// File: lib/features/iap/presentation/widgets/restore_purchases_button.dart
/// Widget untuk restore purchases button

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RestorePurchasesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isIconButton;

  const RestorePurchasesButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isIconButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isIconButton) {
      return IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.restore),
        tooltip: 'Pulihkan Pembelian',
      );
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.restore),
      label: Text(
        isLoading ? 'Memulihkan...' : 'Pulihkan Pembelian',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

/// Restore Purchases Card - untuk ditampilkan sebagai card dengan informasi
class RestorePurchasesCard extends StatelessWidget {
  final VoidCallback onRestore;
  final bool isLoading;

  const RestorePurchasesCard({
    Key? key,
    required this.onRestore,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.restore,
                    color: AppColors.info,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pulihkan Pembelian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Untuk pengguna yang pernah membeli',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Jika Anda pernah membeli premium atau hint pack dan ingin memulihkan pembelian di perangkat ini, klik tombol di bawah.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Restore Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onRestore,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.restore),
                label: Text(
                  isLoading ? 'Memulihkan...' : 'Pulihkan Sekarang',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Info Text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan Anda login dengan akun yang sama dengan saat melakukan pembelian',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Restore Help Dialog - dialog dengan informasi tentang restore
class RestorePurchasesHelpDialog extends StatelessWidget {
  const RestorePurchasesHelpDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RestorePurchasesHelpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.help_outline, color: AppColors.info),
          const SizedBox(width: 12),
          const Text('Tentang Pulihkan Pembelian'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Apa itu Pulihkan Pembelian?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur ini memungkinkan Anda untuk memulihkan pembelian yang pernah dilakukan jika:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildPoint('Mengganti perangkat'),
            _buildPoint('Menginstal ulang aplikasi'),
            _buildPoint('Login dengan akun yang sama'),
            _buildPoint('Pembelian tidak muncul'),
            const SizedBox(height: 16),
            const Text(
              'Catatan Penting:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Hanya pembelian non-consumable (Premium) yang bisa dipulihkan\n'
              '• Hint Pack tidak bisa dipulihkan karena bersifat consumable\n'
              '• Anda harus login dengan akun yang sama\n'
              '• Proses restore gratis dan tidak dikenakan biaya',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Mengerti'),
        ),
      ],
    );
  }

  Widget _buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}