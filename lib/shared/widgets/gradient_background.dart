/// File: lib/shared/widgets/gradient_background.dart
/// Gradient background widget

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Gradient Background
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              [
                AppColors.primary.withOpacity(0.1),
                AppColors.backgroundLight,
              ],
        ),
      ),
      child: child,
    );
  }
}

/// Primary Gradient Background
class PrimaryGradientBackground extends StatelessWidget {
  final Widget child;

  const PrimaryGradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        AppColors.primary,
        AppColors.primaryDark,
      ],
      child: child,
    );
  }
}

/// Success Gradient Background
class SuccessGradientBackground extends StatelessWidget {
  final Widget child;

  const SuccessGradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: AppColors.successGradient,
      child: child,
    );
  }
}

/// Error Gradient Background
class ErrorGradientBackground extends StatelessWidget {
  final Widget child;

  const ErrorGradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: AppColors.errorGradient,
      child: child,
    );
  }
}

/// Radial Gradient Background
class RadialGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry center;
  final double radius;

  const RadialGradientBackground({
    Key? key,
    required this.child,
    required this.colors,
    this.center = Alignment.center,
    this.radius = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}