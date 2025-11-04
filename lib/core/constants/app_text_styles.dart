/// File: lib/core/constants/app_text_styles.dart
/// Konstanta text style untuk aplikasi Sudoku

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // Base Font Family
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Roboto';

  // ========== HEADINGS - LIGHT THEME ==========
  static TextStyle headingH1Light = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
  );

  static TextStyle headingH2Light = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.3,
  );

  static TextStyle headingH3Light = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.2,
  );

  static TextStyle headingH4Light = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headingH5Light = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle headingH6Light = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  // ========== HEADINGS - DARK THEME ==========
  static TextStyle headingH1Dark = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.5,
  );

  static TextStyle headingH2Dark = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.3,
  );

  static TextStyle headingH3Dark = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.2,
  );

  static TextStyle headingH4Dark = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headingH5Dark = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headingH6Dark = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
  );

  // ========== BODY TEXT - LIGHT THEME ==========
  static TextStyle bodyLargeLight = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static TextStyle bodyMediumLight = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    height: 1.5,
  );

  static TextStyle bodySmallLight = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    height: 1.5,
  );

  // ========== BODY TEXT - DARK THEME ==========
  static TextStyle bodyLargeDark = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
    height: 1.5,
  );

  static TextStyle bodyMediumDark = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
    height: 1.5,
  );

  static TextStyle bodySmallDark = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
    height: 1.5,
  );

  // ========== BUTTON TEXT ==========
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // ========== SUDOKU NUMBER STYLES ==========
  static TextStyle sudokuNumberFixed = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.numberFixed,
  );

  static TextStyle sudokuNumberUser = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.numberUser,
  );

  static TextStyle sudokuNumberError = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.numberError,
  );

  static TextStyle sudokuNumberNote = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.numberNote,
  );

  // ========== CAPTION & LABELS ==========
  static TextStyle captionLight = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle captionDark = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
  );

  static TextStyle labelLight = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle labelDark = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
  );

  // ========== TIMER TEXT ==========
  static TextStyle timerText = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle timerTextLarge = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ========== SCORE & STATS TEXT ==========
  static TextStyle scoreText = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle statsNumberLight = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle statsNumberDark = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle statsLabelLight = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle statsLabelDark = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
  );

  // ========== LEADERBOARD TEXT ==========
  static TextStyle leaderboardRank = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle leaderboardName = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle leaderboardScore = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ========== DIFFICULTY TEXT ==========
  static TextStyle difficultyText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle difficultyDescription = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
  );

  // ========== ACHIEVEMENT TEXT ==========
  static TextStyle achievementTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle achievementDescription = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
  );

  // ========== DIALOG TEXT ==========
  static TextStyle dialogTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle dialogContent = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    height: 1.5,
  );

  // ========== ERROR TEXT ==========
  static TextStyle errorText = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  static TextStyle errorTextSmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  // ========== PREMIUM BADGE TEXT ==========
  static TextStyle premiumBadge = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // ========== APP BAR TEXT ==========
  static TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ========== HINT COUNTER TEXT ==========
  static TextStyle hintCounter = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ========== HELPER METHODS ==========
  
  /// Get heading style berdasarkan level dan theme
  static TextStyle getHeading(int level, bool isDark) {
    if (isDark) {
      switch (level) {
        case 1:
          return headingH1Dark;
        case 2:
          return headingH2Dark;
        case 3:
          return headingH3Dark;
        case 4:
          return headingH4Dark;
        case 5:
          return headingH5Dark;
        case 6:
          return headingH6Dark;
        default:
          return headingH4Dark;
      }
    } else {
      switch (level) {
        case 1:
          return headingH1Light;
        case 2:
          return headingH2Light;
        case 3:
          return headingH3Light;
        case 4:
          return headingH4Light;
        case 5:
          return headingH5Light;
        case 6:
          return headingH6Light;
        default:
          return headingH4Light;
      }
    }
  }

  /// Get body text style berdasarkan size dan theme
  static TextStyle getBodyText(String size, bool isDark) {
    if (isDark) {
      switch (size) {
        case 'large':
          return bodyLargeDark;
        case 'small':
          return bodySmallDark;
        default:
          return bodyMediumDark;
      }
    } else {
      switch (size) {
        case 'large':
          return bodyLargeLight;
        case 'small':
          return bodySmallLight;
        default:
          return bodyMediumLight;
      }
    }
  }

  /// Get button text style berdasarkan size
  static TextStyle getButtonText(String size) {
    switch (size) {
      case 'large':
        return buttonLarge;
      case 'small':
        return buttonSmall;
      default:
        return buttonMedium;
    }
  }
}