/// File: lib/core/utils/helpers.dart
/// General helper utilities

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Helpers {
  // Prevent instantiation
  Helpers._();

  // ========== RANDOM GENERATORS ==========

  /// Generate random integer dalam range
  static int randomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  /// Generate random double dalam range
  static double randomDouble(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }

  /// Generate random boolean
  static bool randomBool() {
    return Random().nextBool();
  }

  /// Generate random string (alphanumeric)
  static String randomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Shuffle list randomly
  static List<T> shuffleList<T>(List<T> list) {
    final newList = List<T>.from(list);
    newList.shuffle();
    return newList;
  }

  // ========== HAPTIC FEEDBACK ==========

  /// Light haptic feedback
  static Future<void> lightHaptic() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback
  static Future<void> mediumHaptic() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback
  static Future<void> heavyHaptic() async {
    await HapticFeedback.heavyImpact();
  }

  /// Vibrate untuk error
  static Future<void> errorHaptic() async {
    await HapticFeedback.vibrate();
  }

  /// Selection click haptic
  static Future<void> selectionHaptic() async {
    await HapticFeedback.selectionClick();
  }

  // ========== DIALOG & SNACKBAR HELPERS ==========

  /// Show snackbar
  static void showSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }

  /// Show info snackbar
  static void showInfoSnackbar(BuildContext context, String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: Colors.blue,
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Tidak',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  // ========== DELAY & DEBOUNCE ==========

  /// Delay execution
  static Future<void> delay(Duration duration) async {
    await Future.delayed(duration);
  }

  /// Debounce function calls
  static Function debounce(
    Function function, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () {
        function();
      });
    };
  }

  // ========== SCREEN UTILS ==========

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// Check if portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get safe area padding
  static EdgeInsets safePadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // ========== KEYBOARD UTILS ==========

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Show keyboard
  static void showKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  // ========== COLOR UTILS ==========

  /// Darken color
  static Color darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return darkened.toColor();
  }

  /// Lighten color
  static Color lightenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return lightened.toColor();
  }

  /// Get contrasting text color (black or white) based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // ========== LIST UTILS ==========

  /// Check if list is null or empty
  static bool isNullOrEmpty(List? list) {
    return list == null || list.isEmpty;
  }

  /// Get first element or null
  static T? firstOrNull<T>(List<T> list) {
    return list.isEmpty ? null : list.first;
  }

  /// Get last element or null
  static T? lastOrNull<T>(List<T> list) {
    return list.isEmpty ? null : list.last;
  }

  /// Chunk list into smaller lists
  static List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  // ========== MAP UTILS ==========

  /// Check if map is null or empty
  static bool isMapNullOrEmpty(Map? map) {
    return map == null || map.isEmpty;
  }

  // ========== MATH UTILS ==========

  /// Clamp value between min and max
  static num clamp(num value, num min, num max) {
    return value < min ? min : (value > max ? max : value);
  }

  /// Calculate percentage
  static double percentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Round to decimal places
  static double roundToDecimal(double value, int decimalPlaces) {
    final mod = pow(10, decimalPlaces);
    return (value * mod).round() / mod;
  }

  // ========== SUDOKU SPECIFIC UTILS ==========

  /// Get row index from cell index (0-80 to 0-8)
  static int getRowIndex(int cellIndex) {
    return cellIndex ~/ 9;
  }

  /// Get column index from cell index (0-80 to 0-8)
  static int getColumnIndex(int cellIndex) {
    return cellIndex % 9;
  }

  /// Get box index from cell index (0-80 to 0-8)
  static int getBoxIndex(int cellIndex) {
    final row = getRowIndex(cellIndex);
    final col = getColumnIndex(cellIndex);
    return (row ~/ 3) * 3 + (col ~/ 3);
  }

  /// Get cell index from row and column
  static int getCellIndex(int row, int col) {
    return row * 9 + col;
  }

  /// Check if two cells are in same row
  static bool inSameRow(int cellIndex1, int cellIndex2) {
    return getRowIndex(cellIndex1) == getRowIndex(cellIndex2);
  }

  /// Check if two cells are in same column
  static bool inSameColumn(int cellIndex1, int cellIndex2) {
    return getColumnIndex(cellIndex1) == getColumnIndex(cellIndex2);
  }

  /// Check if two cells are in same box
  static bool inSameBox(int cellIndex1, int cellIndex2) {
    return getBoxIndex(cellIndex1) == getBoxIndex(cellIndex2);
  }

  /// Check if two cells are related (same row, column, or box)
  static bool areCellsRelated(int cellIndex1, int cellIndex2) {
    return inSameRow(cellIndex1, cellIndex2) ||
        inSameColumn(cellIndex1, cellIndex2) ||
        inSameBox(cellIndex1, cellIndex2);
  }

  // ========== DATE UTILS ==========

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get days difference from now
  static int daysDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}