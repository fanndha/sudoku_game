/// File: lib/features/iap/presentation/widgets/premium_badge.dart
/// Widget untuk menampilkan premium badge

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PremiumBadge extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showIcon;

  const PremiumBadge({
    Key? key,
    this.size = 1.0,
    this.showText = true,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * size,
        vertical: 12 * size,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.premiumGold,
            AppColors.premiumBadge,
          ],
        ),
        borderRadius: BorderRadius.circular(12 * size),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumGold.withOpacity(0.3),
            blurRadius: 8 * size,
            offset: Offset(0, 4 * size),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 24 * size,
            ),
            if (showText) SizedBox(width: 8 * size),
          ],
          if (showText)
            Text(
              'PREMIUM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * size,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

/// Premium Badge Card - untuk ditampilkan sebagai card
class PremiumBadgeCard extends StatelessWidget {
  const PremiumBadgeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.premiumGold.withOpacity(0.1),
              AppColors.premiumBadge.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.premiumGold,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Premium Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium,
                size: 48,
                color: AppColors.premiumGold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Premium Text
            Text(
              'Akun Premium Aktif',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.premiumGold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              'Terima kasih telah mendukung kami!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Benefits Row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildBenefitChip('Tanpa Iklan', Icons.block),
                _buildBenefitChip('Petunjuk ∞', Icons.lightbulb),
                _buildBenefitChip('Tema Eksklusif', Icons.palette),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.premiumGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.premiumGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.premiumGold,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small Premium Icon - untuk ditampilkan di app bar atau list
class PremiumIcon extends StatelessWidget {
  final double size;

  const PremiumIcon({
    Key? key,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.premiumGold,
            AppColors.premiumBadge,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumGold.withOpacity(0.3),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.2),
          ),
        ],
      ),
      child: Icon(
        Icons.workspace_premium,
        color: Colors.white,
        size: size,
      ),
    );
  }
}