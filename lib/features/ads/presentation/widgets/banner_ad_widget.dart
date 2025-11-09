/// File: lib/features/ads/presentation/widgets/banner_ad_widget.dart
/// Widget untuk menampilkan banner ad

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gads;
import '../bloc/ads_bloc.dart';
import '../bloc/ads_event.dart' as event;
import '../bloc/ads_state.dart' as state;

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  gads.BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    context.read<AdsBloc>().add(const event.LoadBannerAd());
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    context.read<AdsBloc>().add(const event.DisposeBannerAd());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsBloc, state.AdsState>(
      listener: (context, adsState) {
        if (adsState is state.BannerAdLoaded) {
          // Banner loaded successfully
        } else if (adsState is state.AdError &&
            adsState.adType == 'banner') {
          // Handle error silently or show small indicator
        }
      },
      builder: (context, adsState) {
        if (adsState is state.BannerAdLoaded) {
          return SizedBox(
            height: 60,
            child: Center(
              child: _bannerAd != null
                  ? gads.AdWidget(ad: _bannerAd!)
                  : const SizedBox.shrink(),
            ),
          );
        } else if (adsState is state.BannerAdLoading) {
          return SizedBox(
            height: 60,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
