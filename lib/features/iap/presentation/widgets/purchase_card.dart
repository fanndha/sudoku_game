/// File: lib/features/iap/presentation/widgets/purchase_card.dart
/// Widget untuk menampilkan purchase card

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/purchase_entity.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseEntity purchase;

  const PurchaseCard({
    super.key,
    required this.purchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Product ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getProductName(purchase.productId),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Purchase Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatDateTime(purchase.purchaseDate),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Transaction ID (if available)
            if (purchase.transactionId != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 16,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ID: ${purchase.transactionId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            // Acknowledged Badge
            if (purchase.isAcknowledged) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Terverifikasi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get product name from product ID
  String _getProductName(String productId) {
    if (productId.contains('premium')) {
      return 'Premium Package';
    } else if (productId.contains('hint')) {
      return 'Hint Pack (20 Hints)';
    } else {
      return Formatters.capitalizeWords(productId.replaceAll('_', ' '));
    }
  }

  /// Build status chip
  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData icon;

    switch (purchase.status.toLowerCase()) {
      case 'purchased':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        statusText = 'Berhasil';
        icon = Icons.check_circle;
        break;
      case 'restored':
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        statusText = 'Dipulihkan';
        icon = Icons.restore;
        break;
      case 'pending':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        statusText = 'Pending';
        icon = Icons.pending;
        break;
      case 'canceled':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        statusText = 'Dibatalkan';
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        statusText = purchase.status;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}