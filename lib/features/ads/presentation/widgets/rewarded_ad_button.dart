/// File: lib/features/ads/presentation/widgets/rewarded_ad_button.dart
/// Widget button untuk show rewarded ad

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/ads_bloc.dart';
import '../bloc/ads_event.dart';
import '../bloc/ads_state.dart';

class RewardedAdButton extends StatelessWidget {
  final String label;
  final VoidCallback? onRewardEarned;
  final VoidCallback? onAdNotAvailable;
  final IconData? icon;

  const RewardedAdButton({
    super.key,
    this.label = 'Tonton Iklan',
    this.onRewardEarned,
    this.onAdNotAvailable,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is RewardedAdShown) {
          if (state.rewardEarned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terima kasih! Reward telah diterima'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );
            onRewardEarned?.call();
          }
        } else if (state is AdNotAvailable && state.adType == 'rewarded') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.warning,
            ),
          );
          onAdNotAvailable?.call();
        } else if (state is AdError && state.adType == 'rewarded') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RewardedAdLoading;

        return ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  context.read<AdsBloc>().add(const ShowRewardedAd());
                },
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(icon ?? Icons.play_circle_outline),
          label: Text(isLoading ? 'Memuat...' : label),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        );
      },
    );
  }
}