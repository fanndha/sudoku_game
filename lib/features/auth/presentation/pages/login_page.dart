/// File: lib/features/auth/presentation/pages/login_page.dart
/// Login page dengan Google Sign In dan Anonymous Sign In

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/google_signin_button.dart';
import '../widgets/anonymous_signin_button.dart';
import '../widgets/auth_loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn(BuildContext context) {
    Helpers.lightHaptic();
    context.read<AuthBloc>().add(const AuthSignInWithGoogleEvent());
  }

  void _handleAnonymousSignIn(BuildContext context) {
    Helpers.lightHaptic();
    context.read<AuthBloc>().add(const AuthSignInAnonymousEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to home
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state is AuthError) {
          // Show error
          Helpers.showErrorSnackbar(context, state.message);
        } else if (state is AuthUserCancelled) {
          // User cancelled, do nothing or show message
          Helpers.showInfoSnackbar(context, 'Login dibatalkan');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        AppColors.backgroundDark,
                        AppColors.surfaceDark,
                      ]
                    : [
                        AppColors.primaryLight.withOpacity(0.1),
                        Colors.white,
                      ],
              ),
            ),
            child: SafeArea(
              child: isLoading
                  ? const AuthLoadingWidget(
                      message: 'Mohon tunggu...',
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.08),

                          // Logo Section
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  // App Logo
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.surfaceDark
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadowLight,
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/logo/app_logo.png',
                                        width: 70,
                                        height: 70,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.grid_4x4,
                                            size: 50,
                                            color: AppColors.primary,
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Welcome Text
                                  Text(
                                    AppStrings.welcome,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    AppStrings.appDescription,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: isDark
                                                  ? AppColors.textSecondaryDark
                                                  : AppColors.textSecondaryLight,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.08),

                          // Illustration atau gambar (optional)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Image.asset(
                              'assets/images/backgrounds/menu_background.png',
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.grid_4x4_outlined,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: size.height * 0.08),

                          // Sign In Buttons
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  // Google Sign In Button
                                  GoogleSignInButton(
                                    onPressed: () => _handleGoogleSignIn(context),
                                    isLoading: isLoading,
                                  ),

                                  const SizedBox(height: 16),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? AppColors.dividerDark
                                              : AppColors.dividerLight,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'atau',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: isDark
                                                    ? AppColors.textSecondaryDark
                                                    : AppColors.textSecondaryLight,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? AppColors.dividerDark
                                              : AppColors.dividerLight,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Anonymous Sign In Button
                                  AnonymousSignInButton(
                                    onPressed: () => _handleAnonymousSignIn(context),
                                    isLoading: isLoading,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Terms & Privacy
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'Dengan masuk, Anda menyetujui\nSyarat & Ketentuan dan Kebijakan Privasi',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}