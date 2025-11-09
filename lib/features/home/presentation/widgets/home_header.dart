/// File: lib/features/home/presentation/widgets/home_header.dart
/// Widget untuk header di home page

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final String? userName;
  final String? userPhotoUrl;
  final bool isPremium;
  final int? hintsCount;

  const HomeHeader({
    Key? key,
    required this.onProfileTap,
    required this.onSettingsTap,
    this.userName,
    this.userPhotoUrl,
    this.isPremium = false,
    this.hintsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: onProfileTap,
            child: Stack(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPremium
                          ? AppColors.premiumGold
                          : AppColors.primary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isPremium
                            ? AppColors.premiumGold.withOpacity(0.3)
                            : AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: userPhotoUrl != null
                        ? NetworkImage(userPhotoUrl!)
                        : null,
                    child: userPhotoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 28,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),

                // Premium Badge
                if (isPremium)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.premiumGold,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: GestureDetector(
              onTap: onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.premiumGold,
                                AppColors.premiumBadge,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName ?? 'Pemain',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Hints Counter (if not premium)
          if (!isPremium && hintsCount != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$hintsCount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Settings Button
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(Icons.settings_outlined),
            color: Colors.grey[700],
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}

/// Simple Home Header - versi lebih sederhana
class SimpleHomeHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const SimpleHomeHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (onBackPressed != null) ...[
            IconButton(
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey[700],
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/// Animated Home Header - dengan animasi
class AnimatedHomeHeader extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final String? userName;
  final bool isPremium;

  const AnimatedHomeHeader({
    Key? key,
    required this.onProfileTap,
    required this.onSettingsTap,
    this.userName,
    this.isPremium = false,
  }) : super(key: key);

  @override
  State<AnimatedHomeHeader> createState() => _AnimatedHomeHeaderState();
}

class _AnimatedHomeHeaderState extends State<AnimatedHomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: HomeHeader(
          onProfileTap: widget.onProfileTap,
          onSettingsTap: widget.onSettingsTap,
          userName: widget.userName,
          isPremium: widget.isPremium,
        ),
      ),
    );
  }
}

/// Home App Bar - custom app bar untuk home
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final bool isPremium;
  final VoidCallback onProfileTap;
  final List<Widget>? actions;

  const HomeAppBar({
    Key? key,
    this.userName,
    this.isPremium = false,
    required this.onProfileTap,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: GestureDetector(
        onTap: onProfileTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName ?? 'Pemain',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.premiumGold,
                            AppColors.premiumBadge,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}