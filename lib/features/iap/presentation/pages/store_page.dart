/// File: lib/features/iap/presentation/pages/store_page.dart
/// Main page untuk Store/IAP

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/iap_bloc.dart';
import '../bloc/iap_event.dart';
import '../bloc/iap_state.dart';
import '../widgets/premium_badge.dart';
import '../widgets/product_item.dart';
import '../widgets/restore_purchases_button.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    context.read<IAPBloc>().add(const InitializeIAP());
    context.read<IAPBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.store),
        actions: [
          RestorePurchasesButton(
            onPressed: () {
              context.read<IAPBloc>().add(const RestorePurchases());
            },
          ),
        ],
      ),
      body: BlocConsumer<IAPBloc, IAPState>(
        listener: (context, state) {
          if (state is PurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pembelian berhasil! Terima kasih!'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is PurchaseCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pembelian dibatalkan'),
                backgroundColor: AppColors.warning,
              ),
            );
          } else if (state is PurchasesRestored) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Pemulihan selesai! ${state.purchases.length} pembelian dipulihkan',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is IAPError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is IAPInitializing || state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return _buildProducts(state);
          } else if (state is Purchasing) {
            return _buildPurchasing(state);
          } else if (state is RestoringPurchases) {
            return _buildRestoring();
          } else if (state is IAPError) {
            return _buildError(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProducts(ProductsLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Premium Badge if user is premium
        if (state.isPremium) ...[
          const PremiumBadge(),
          const SizedBox(height: 24),
        ],

        // Store Header
        _buildHeader(),
        const SizedBox(height: 24),

        // Products List
        ...state.products.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductItem(
              product: product,
              isPremium: state.isPremium,
              onPurchase: () {
                context.read<IAPBloc>().add(PurchaseProduct(product.id));
              },
            ),
          );
        }).toList(),

        const SizedBox(height: 24),

        // Info Text
        _buildInfoText(),
      ],
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primaryLight.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.store, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              'Sudoku Store',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tingkatkan pengalaman bermain Anda!',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchasing(Purchasing state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Memproses pembelian...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Mohon tunggu', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRestoring() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Memulihkan pembelian...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Mohon tunggu', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Oops!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.info),
                const SizedBox(width: 8),
                Text(
                  'Informasi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '• Pembelian bersifat permanen\n'
              '• Premium menghapus semua iklan\n'
              '• Hint pack dapat dibeli berkali-kali\n'
              '• Gunakan "Pulihkan Pembelian" jika ganti perangkat',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
