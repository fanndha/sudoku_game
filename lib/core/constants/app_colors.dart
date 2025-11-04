/// File: lib/core/constants/app_colors.dart
/// Konstanta warna untuk aplikasi Sudoku

import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFF6F00);
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color secondaryLight = Color(0xFFFF8F00);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  
  // Sudoku Board Colors
  static const Color boardBackground = Color(0xFFFFFFFF);
  static const Color boardBackgroundDark = Color(0xFF2C2C2C);
  static const Color gridLine = Color(0xFFBDBDBD);
  static const Color gridLineBold = Color(0xFF424242);
  
  // Cell Colors
  static const Color cellDefault = Color(0xFFFFFFFF);
  static const Color cellDefaultDark = Color(0xFF2C2C2C);
  static const Color cellSelected = Color(0xFFBBDEFB);
  static const Color cellSelectedDark = Color(0xFF1565C0);
  static const Color cellHighlight = Color(0xFFE3F2FD);
  static const Color cellHighlightDark = Color(0xFF0D47A1);
  static const Color cellFixed = Color(0xFFECEFF1);
  static const Color cellFixedDark = Color(0xFF37474F);
  static const Color cellError = Color(0xFFFFEBEE);
  static const Color cellErrorDark = Color(0xFFB71C1C);
  static const Color cellNote = Color(0xFF90CAF9);
  
  // Number Colors
  static const Color numberFixed = Color(0xFF263238);
  static const Color numberUser = Color(0xFF1E88E5);
  static const Color numberError = Color(0xFFD32F2F);
  static const Color numberNote = Color(0xFF757575);
  
  // Difficulty Colors
  static const Color difficultyEasy = Color(0xFF4CAF50);
  static const Color difficultyMedium = Color(0xFFFF9800);
  static const Color difficultyHard = Color(0xFFFF5722);
  static const Color difficultyExpert = Color(0xFFE91E63);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFF1E88E5);
  static const Color buttonSecondary = Color(0xFFBDBDBD);
  static const Color buttonSuccess = Color(0xFF4CAF50);
  static const Color buttonDanger = Color(0xFFF44336);
  static const Color buttonDisabled = Color(0xFFE0E0E0);
  
  // Achievement Colors
  static const Color achievementGold = Color(0xFFFFD700);
  static const Color achievementSilver = Color(0xFFC0C0C0);
  static const Color achievementBronze = Color(0xFFCD7F32);
  static const Color achievementLocked = Color(0xFF9E9E9E);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF1E88E5),
    Color(0xFF1565C0),
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF66BB6A),
    Color(0xFF43A047),
  ];
  
  static const List<Color> errorGradient = [
    Color(0xFFEF5350),
    Color(0xFFE53935),
  ];
  
  // Premium Colors
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumBadge = Color(0xFFFFA000);
  
  // Leaderboard Colors
  static const Color rank1 = Color(0xFFFFD700); // Gold
  static const Color rank2 = Color(0xFFC0C0C0); // Silver
  static const Color rank3 = Color(0xFFCD7F32); // Bronze
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  
  // Helper method untuk mendapatkan warna berdasarkan difficulty
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return difficultyEasy;
      case 'medium':
        return difficultyMedium;
      case 'hard':
        return difficultyHard;
      case 'expert':
        return difficultyExpert;
      default:
        return primary;
    }
  }
  
  // Helper method untuk mendapatkan warna rank
  static Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return rank1;
      case 2:
        return rank2;
      case 3:
        return rank3;
      default:
        return textSecondaryLight;
    }
  }
}