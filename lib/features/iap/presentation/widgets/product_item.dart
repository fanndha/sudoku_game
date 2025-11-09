/// File: lib/features/iap/presentation/widgets/product_item.dart
/// Widget untuk menampilkan product item di store

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/iap_constans.dart';
import '../../domain/entities/product_entity.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  final bool isPremium;
  final VoidCallback onPurchase;

  const ProductItem({
    Key? key,
    required this.product,
    required this.onPurchase,
    this.isPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAlreadyOwned = isPremium && product.isPremiumPackage;
    
    return Card(
      elevation: isAlreadyOwned ? 1 : 3,
      child: InkWell(
        onTap: isAlreadyOwned ? null : onPurchase,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: product.isPremiumPackage
                ? Border.all(
                    color: AppColors.premiumGold,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row - Icon & Title
              Row(
                children: [
                  // Product Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getIconBackgroundColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getProductIcon(),
                      color: _getIconColor(),
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Title & Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (product.isPremiumPackage) ...[
                              Icon(
                                Icons.star,
                                color: AppColors.premiumGold,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.price,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
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
                product.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Features List (for premium)
              if (product.isPremiumPackage) ...[
                _buildFeaturesList(),
                const SizedBox(height: 16),
              ],
              
              // Hint Pack Info
              if (product.isHintPack) ...[
                _buildHintPackInfo(),
                const SizedBox(height: 16),
              ],
              
              // Purchase Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAlreadyOwned ? null : onPurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAlreadyOwned
                        ? Colors.grey
                        : (product.isPremiumPackage
                            ? AppColors.premiumGold
                            : AppColors.primary),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isAlreadyOwned ? Icons.check_circle : Icons.shopping_cart,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAlreadyOwned ? 'Sudah Dimiliki' : 'Beli Sekarang',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Already Owned Badge
              if (isAlreadyOwned) ...[
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.success,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Aktif',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build features list for premium
  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fitur Premium:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...IAPConstants.premiumFeatures.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  /// Build hint pack info
  Widget _buildHintPackInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dapatkan ${IAPConstants.hintsPerPack} petunjuk untuk membantu menyelesaikan puzzle yang sulit',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get product icon
  IconData _getProductIcon() {
    if (product.isPremiumPackage) {
      return Icons.workspace_premium;
    } else if (product.isHintPack) {
      return Icons.lightbulb;
    } else {
      return Icons.shopping_bag;
    }
  }

  /// Get icon background color
  Color _getIconBackgroundColor() {
    if (product.isPremiumPackage) {
      return AppColors.premiumGold.withOpacity(0.1);
    } else if (product.isHintPack) {
      return AppColors.warning.withOpacity(0.1);
    } else {
      return AppColors.primary.withOpacity(0.1);
    }
  }

  /// Get icon color
  Color _getIconColor() {
    if (product.isPremiumPackage) {
      return AppColors.premiumGold;
    } else if (product.isHintPack) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }
}